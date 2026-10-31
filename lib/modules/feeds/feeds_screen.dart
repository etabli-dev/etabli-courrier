import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import '../../core/net/bounded_http.dart';
import '../mail/render/mime_render_plan.dart';
import 'data/feed_repository.dart';
import 'sync/feeds_sync_backend.dart';
import 'ui/feed_item_list.dart';
import 'ui/feed_subscription_list.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({required this.db, super.key});
  final CourrierDatabase db;

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  late final _subscriptions = (widget.db.select(
    widget.db.feedSubscriptions,
  )..orderBy([(t) => OrderingTerm.asc(t.title)])).watch();

  bool _busy = false;
  Future<void> _add() async {
    final raw = await showDialog<String>(
      context: context,
      builder: (_) => const _FeedUrlDialog(),
    );
    if (raw == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final uri = requireHttps(Uri.parse(raw.trim()));
      await widget.db.transaction(() async {
        final account =
            await (widget.db.select(widget.db.accounts)..where(
                  (t) =>
                      t.kind.equals('local') &
                      t.displayName.equals('Local feeds'),
                ))
                .getSingleOrNull();
        final id =
            account?.id ??
            await widget.db
                .into(widget.db.accounts)
                .insert(
                  AccountsCompanion.insert(
                    kind: 'local',
                    displayName: 'Local feeds',
                  ),
                );
        final repo = FeedRepository(db: widget.db, accountId: id);
        if (!(await repo.listSubscriptions()).any(
          (s) => s.url == uri.toString(),
        )) {
          await repo.subscribe(url: uri.toString(), title: uri.host);
        }
      });
      await _refresh();
    } catch (_) {
      _message('Could not add feed. Use an HTTPS RSS or Atom URL.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  Future<void> _refresh() async {
    setState(() => _busy = true);
    var count = 0;
    var failed = false;
    try {
      final accounts = await (widget.db.select(
        widget.db.accounts,
      )..where((t) => t.kind.equals('local') & t.enabled.equals(true))).get();
      for (final account in accounts) {
        final backend = FeedsSyncBackend(
          repository: FeedRepository(db: widget.db, accountId: account.id),
        );
        try {
          final result = await backend.pull(accountId: account.id);
          count += result.pulled;
          failed |= !result.success;
        } finally {
          backend.close();
        }
      }
      _message(
        failed
            ? 'Some feeds could not refresh. Cached articles are retained.'
            : 'Checked $count articles. Nextcloud News refreshes from Accounts.',
      );
    } catch (_) {
      _message('Could not refresh feeds. Cached articles are retained.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(FeedSubscription subscription) async {
    final repository = FeedRepository(
      db: widget.db,
      accountId: subscription.accountId,
    );
    final owner = await (widget.db.select(
      widget.db.accounts,
    )..where((t) => t.id.equals(subscription.accountId))).getSingle();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FeedPage(
          subscription: subscription,
          repository: repository,
          allowRemoval: owner.kind == 'local',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Wrap(
        spacing: 12,
        children: [
          TextButton.icon(
            onPressed: _busy ? null : _add,
            icon: const Icon(Icons.add),
            label: const Text('Add HTTPS feed'),
          ),
          TextButton.icon(
            onPressed: _busy ? null : _refresh,
            icon: const Icon(Icons.refresh),
            label: Text(_busy ? 'Refreshing…' : 'Refresh local feeds'),
          ),
        ],
      ),
      Expanded(
        child: StreamBuilder<List<FeedSubscription>>(
          stream: _subscriptions,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Could not load subscriptions.'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return FeedSubscriptionList(
              subscriptions: snapshot.data!,
              unreadCounts: const {},
              onSubscriptionTap: _open,
            );
          },
        ),
      ),
    ],
  );
}

class _FeedPage extends StatefulWidget {
  const _FeedPage({
    required this.subscription,
    required this.repository,
    required this.allowRemoval,
  });
  final bool allowRemoval;
  final FeedSubscription subscription;
  final FeedRepository repository;
  @override
  State<_FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<_FeedPage> {
  late final _items =
      (widget.repository.db.select(widget.repository.db.feedItems)
            ..where((t) => t.feedId.equals(widget.subscription.id))
            ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]))
          .watch();

  Future<void> _read(FeedItem item) async {
    try {
      await widget.repository.markRead(item.id);
      if (!mounted) return;
      final text = const MimeRenderer().sanitiseHtmlToText(item.content ?? '');
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(item.title)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                text.isEmpty ? 'No saved article content.' : text,
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open this article. Please try again.'),
          ),
        );
      }
    }
  }

  bool _removing = false;
  Future<void> _remove() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Remove this local feed?'),
        content: const Text(
          'The subscription and its cached articles will be removed from this device. The feed website is unchanged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (approved != true || !mounted) return;
    setState(() => _removing = true);
    try {
      await widget.repository.unsubscribe(widget.subscription.id);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not remove the feed. Please retry.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _removing = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.subscription.title),
      actions: [
        if (widget.allowRemoval)
          IconButton(
            tooltip: 'Remove local feed',
            onPressed: _removing ? null : _remove,
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    ),
    body: StreamBuilder<List<FeedItem>>(
      stream: _items,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load saved articles.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return FeedItemList(items: snapshot.data!, onItemTap: _read);
      },
    ),
  );
}

class _FeedUrlDialog extends StatefulWidget {
  const _FeedUrlDialog();
  @override
  State<_FeedUrlDialog> createState() => _FeedUrlDialogState();
}

class _FeedUrlDialogState extends State<_FeedUrlDialog> {
  final _url = TextEditingController();
  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add feed'),
    content: TextField(
      controller: _url,
      keyboardType: TextInputType.url,
      autocorrect: false,
      maxLength: 4096,
      decoration: const InputDecoration(labelText: 'HTTPS RSS or Atom URL'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _url.text),
        child: const Text('Add'),
      ),
    ],
  );
}
