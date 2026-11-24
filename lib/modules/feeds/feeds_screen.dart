import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import '../../core/net/bounded_http.dart';
import '../../l10n/l10n.dart';
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
      _message((l10n) => l10n.feedsAddFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String Function(AppLocalizations l10n) text) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(text(context.l10n))));
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
        (l10n) =>
            failed ? l10n.feedsRefreshPartial : l10n.feedsRefreshDone(count),
      );
    } catch (_) {
      _message((l10n) => l10n.feedsRefreshFailed);
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
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Wrap(
          spacing: 12,
          children: [
            _FullWording(
              full: l10n.feedsAddTooltip,
              label: l10n.feedsAdd,
              child: TextButton.icon(
                onPressed: _busy ? null : _add,
                icon: const Icon(Icons.add),
                label: Text(l10n.feedsAdd),
              ),
            ),
            _FullWording(
              full: l10n.feedsRefreshTooltip,
              label: l10n.feedsRefresh,
              child: TextButton.icon(
                onPressed: _busy ? null : _refresh,
                icon: const Icon(Icons.refresh),
                label: Text(_busy ? l10n.feedsRefreshing : l10n.feedsRefresh),
              ),
            ),
          ],
        ),
        Expanded(
          child: StreamBuilder<List<FeedSubscription>>(
            stream: _subscriptions,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(context.l10n.feedsSubscriptionsLoadFailed),
                );
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
}

/// Keeps the full wording of a shortened button label available as a tooltip.
class _FullWording extends StatelessWidget {
  const _FullWording({
    required this.full,
    required this.label,
    required this.child,
  });

  final String full;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      full == label ? child : Tooltip(message: full, child: child);
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
                text.isEmpty ? context.l10n.feedsNoArticleContent : text,
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.feedsArticleOpenFailed)),
        );
      }
    }
  }

  bool _removing = false;
  Future<void> _remove() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(c.l10n.feedsRemoveTitle),
        content: Text(c.l10n.feedsRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(c.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(c.l10n.feedsRemove),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.feedsRemoveFailed)));
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
            tooltip: context.l10n.feedsRemoveTooltip,
            onPressed: _removing ? null : _remove,
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    ),
    body: StreamBuilder<List<FeedItem>>(
      stream: _items,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(context.l10n.feedsArticlesLoadFailed));
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
    title: Text(context.l10n.feedsAddTitle),
    content: TextField(
      controller: _url,
      keyboardType: TextInputType.url,
      autocorrect: false,
      maxLength: 4096,
      decoration: InputDecoration(labelText: context.l10n.feedsUrlLabel),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _url.text),
        child: Text(context.l10n.feedsAddConfirm),
      ),
    ],
  );
}
