import 'package:courrier/modules/mail/backend/demo_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

const _creds = PasswordCredentials(
  username: 'test@example.org',
  password: 'pw',
);

void main() {
  group('DemoMailBackend', () {
    test('connect seeds inbox + sent + drafts + trash + archive', () async {
      final backend = DemoMailBackend();
      await backend.connect(_creds);
      final folders = await backend.listFolders();
      expect(
        folders.map((f) => f.name),
        containsAll(['INBOX', 'Sent', 'Drafts', 'Trash', 'Archive']),
      );
      final specialUses = folders.map((f) => f.specialUse).whereType<String>();
      expect(
        specialUses,
        containsAll([r'\Inbox', r'\Sent', r'\Drafts', r'\Trash', r'\Archive']),
      );
    });

    test('fetchEnvelopes returns newest first within the window', () async {
      final backend = DemoMailBackend();
      await backend.connect(_creds);
      final envelopes = await backend.fetchEnvelopes(folderName: 'INBOX');
      expect(envelopes, isNotEmpty);
      for (var i = 0; i < envelopes.length - 1; i++) {
        expect(
          envelopes[i].receivedAt.isAfter(envelopes[i + 1].receivedAt) ||
              envelopes[i].receivedAt == envelopes[i + 1].receivedAt,
          isTrue,
          reason: 'newest must come first',
        );
      }
    });

    test('fetchBody surfaces text + html + attachments', () async {
      final backend = DemoMailBackend();
      await backend.connect(_creds);
      final newsletter = await backend.fetchBody(folderName: 'INBOX', uid: 104);
      expect(
        newsletter.htmlPart,
        contains('tracker.example.org/pixel.gif'),
        reason: 'fixture must carry the remote img for the render test',
      );
      final receipts = await backend.fetchBody(folderName: 'INBOX', uid: 105);
      expect(receipts.attachments, hasLength(1));
      expect(receipts.attachments.first.filename, 'receipts-q2.pdf');
    });

    test('applyFlags flips seen + flagged + answered locally', () async {
      final backend = DemoMailBackend();
      await backend.connect(_creds);
      await backend.applyFlags(
        folderName: 'INBOX',
        updates: [
          const FlagUpdate(uid: 101, flag: 'seen', value: true),
          const FlagUpdate(uid: 101, flag: 'flagged', value: true),
        ],
      );
      final envelopes = await backend.fetchEnvelopes(folderName: 'INBOX');
      final updated = envelopes.firstWhere((e) => e.uid == 101);
      expect(updated.flags.seen, isTrue);
      expect(updated.flags.flagged, isTrue);
    });

    test('moveMessages: inbox → trash, then expungeTrash clears it', () async {
      final backend = DemoMailBackend();
      await backend.connect(_creds);
      await backend.moveMessages(
        sourceFolder: 'INBOX',
        destinationFolder: 'Trash',
        uids: [101],
      );
      final inboxAfter = await backend.fetchEnvelopes(folderName: 'INBOX');
      expect(inboxAfter.map((e) => e.uid), isNot(contains(101)));
      final trashBefore = await backend.fetchEnvelopes(folderName: 'Trash');
      expect(trashBefore, isNotEmpty);

      await backend.expungeTrash(trashFolderName: 'Trash');
      final trashAfter = await backend.fetchEnvelopes(folderName: 'Trash');
      expect(trashAfter, isEmpty);
    });

    test('operations without connect surface UnauthorizedError', () async {
      final backend = DemoMailBackend();
      expect(() => backend.listFolders(), throwsA(isA<Exception>()));
    });
  });
}
