import 'dart:convert';

import '../../modules/calendar/sync/calendar_sync_backend.dart';
import '../../modules/contacts/sync/contacts_sync_backend.dart';
import '../../modules/feeds/data/feed_repository.dart';
import '../../modules/feeds/sync/feeds_sync_backend.dart';
import '../../modules/feeds/sync/nextcloud_news_client.dart';
import '../../modules/mail/backend/imap_mail_backend.dart';
import '../../modules/mail/backend/mail_credentials.dart';
import '../../modules/mail/data/mail_repository.dart';
import '../../modules/notes/sync/nextcloud_notes_client.dart';
import '../../modules/notes/sync/notes_sync_backend.dart';
import '../../modules/tasks/sync/tasks_sync_backend.dart';
import '../config/secrets_store.dart';
import '../db/database.dart';
import '../net/bounded_http.dart';
import '../net/dav/dav_client.dart';
import 'sync_backend.dart';

class AccountServices {
  AccountServices({required this.db, required this.secrets});
  final CourrierDatabase db;
  final SecretsStore secrets;
  final Map<int, Future<String>> _passes = {};

  Future<String> sync(Account account) => _passes.putIfAbsent(
    account.id,
    () => _sync(account).whenComplete(() => _passes.remove(account.id)),
  );

  Future<String> _sync(Account account) async {
    if (!account.enabled) {
      throw StateError(
        'Account setup is incomplete. Reconnect the same account to finish setup.',
      );
    }
    if (account.kind == 'local') return 'Local data stays on this device.';
    if (account.kind == 'imap') {
      return withMail(account, (repository) async {
        final folders = await repository.syncFolders();
        if (folders.length > 200) {
          throw StateError(
            'More than 200 mail folders; this account exceeds the current sync limit.',
          );
        }
        var messages = 0;
        for (final folder in folders) {
          messages += await repository.syncEnvelopes(folderName: folder.name);
        }
        return 'Checked ${folders.length} folders; $messages new envelopes. Open a message to download its body.';
      });
    }
    if (account.kind != 'nextcloud') {
      throw StateError(
        'This provider is not enabled in this build. Existing cached data is retained.',
      );
    }
    final bundle = await _connection(account.id);
    final password = bundle['app_password'];
    if (password == null || password.isEmpty) {
      throw StateError(
        'The app password is unavailable. Reconnect this account.',
      );
    }
    final base = serverBase(account.baseUrl!);
    final credentials = DavCredentials(
      username: account.username!,
      password: password,
    );
    final dav = DavClient(credentials: credentials);
    final notes = NextcloudNotesClient(baseUrl: base, credentials: credentials);
    final news = NextcloudNewsClient(baseUrl: base, credentials: credentials);
    final feeds = FeedsSyncBackend(
      repository: FeedRepository(db: db, accountId: account.id),
      newsClient: news,
    );
    Uri resolve(Collection c) => sameOrigin(base, c.remoteHref!);
    final backends = <(String, SyncBackend)>[
      (
        'Calendar',
        CalendarSyncBackend(
          db: db,
          davClient: dav,
          collectionUrlResolver: resolve,
        ),
      ),
      (
        'Contacts',
        ContactsSyncBackend(
          db: db,
          davClient: dav,
          collectionUrlResolver: resolve,
        ),
      ),
      (
        'Tasks',
        TasksSyncBackend(
          db: db,
          davClient: dav,
          collectionUrlResolver: resolve,
        ),
      ),
      ('Notes', NotesSyncBackend(db: db, client: notes)),
      ('News', feeds),
    ];
    final reports = <String>[];
    try {
      for (final (label, backend) in backends) {
        try {
          final push = await backend.push(accountId: account.id);
          if (!push.success) {
            reports.add(
              '$label: ${push.conflicts > 0 ? 'conflict; local changes retained' : push.error?.message ?? 'could not upload; changes retained'}',
            );
            continue;
          }
          final pull = await backend.pull(accountId: account.id);
          reports.add(
            pull.success
                ? '$label: ${pull.pulled} records read, ${push.pushed} changes sent'
                : '$label: ${pull.error?.message ?? 'could not refresh'}; cached data retained',
          );
        } on Exception {
          reports.add(
            '$label: could not refresh; cached data retained. Check connection and server app permissions.',
          );
        }
      }
      return reports.join('\n');
    } finally {
      await dav.close();
      notes.close();
      news.close();
      feeds.close();
    }
  }

  Future<T> withMail<T>(
    Account account,
    Future<T> Function(MailRepository) action,
  ) async {
    final current = await (db.select(
      db.accounts,
    )..where((t) => t.id.equals(account.id))).getSingle();
    if (!current.enabled) {
      throw StateError('Account is disconnected. Reconnect it first.');
    }
    final bundle = await _connection(account.id);
    final raw = bundle['mail_config'];
    final password = bundle['password'];
    if (raw == null || raw.isEmpty || password == null || password.isEmpty) {
      throw StateError(
        'Mail connection settings are incomplete. Reconnect the account.',
      );
    }
    final config = jsonDecode(raw) as Map<String, dynamic>;
    if (!['ssl', 'starttls'].contains(config['tls'])) {
      throw StateError('Secure mail transport is required.');
    }
    final backend = ImapMailBackend(
      host: config['host'] as String,
      port: config['port'] as int,
      isSecure: config['tls'] == 'ssl',
    );
    final repository = MailRepository(
      db: db,
      backend: backend,
      accountId: account.id,
    );
    try {
      await backend
          .connect(
            PasswordCredentials(
              username: account.username!,
              password: password,
            ),
          )
          .timeout(const Duration(seconds: 30));
      return await action(repository).timeout(const Duration(minutes: 2));
    } finally {
      await backend.disconnect();
    }
  }

  Future<Map<String, String>> _connection(int id) async {
    final raw = await secrets.read(id, 'connection');
    if (raw != null) return Map<String, String>.from(jsonDecode(raw) as Map);
    return {
      for (final key in ['password', 'app_password', 'mail_config'])
        key: await secrets.read(id, key) ?? '',
    };
  }

  Future<MailMessage> downloadMessage(MailMessage message) async {
    final folder = await (db.select(
      db.mailFolders,
    )..where((t) => t.id.equals(message.folderId))).getSingle();
    final account = await (db.select(
      db.accounts,
    )..where((t) => t.id.equals(folder.accountId))).getSingle();
    if (account.kind != 'imap') {
      throw StateError(
        'This message is in an offline archive or an unavailable provider.',
      );
    }
    await withMail(account, (repository) async {
      await repository.syncEnvelopes(folderName: folder.name);
      await repository.loadBody(folderName: folder.name, messageId: message.id);
    });
    return (db.select(
      db.mailMessages,
    )..where((t) => t.id.equals(message.id))).getSingle();
  }
}
