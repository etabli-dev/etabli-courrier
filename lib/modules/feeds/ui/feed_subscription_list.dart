import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';

class FeedSubscriptionList extends StatelessWidget {
  const FeedSubscriptionList({
    required this.subscriptions,
    required this.unreadCounts,
    this.onSubscriptionTap,
    super.key,
  });

  final List<FeedSubscription> subscriptions;
  final Map<int, int> unreadCounts;
  final ValueChanged<FeedSubscription>? onSubscriptionTap;

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const _Empty();
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space3,
      ),
      itemCount: subscriptions.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space4),
      itemBuilder: (context, i) {
        final sub = subscriptions[i];
        final unread = unreadCounts[sub.id] ?? 0;
        return InkWell(
          onTap: onSubscriptionTap == null
              ? null
              : () => onSubscriptionTap!(sub),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: CourrierTokens.space2,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (sub.folder != null)
                        Text(
                          sub.folder!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: CourrierTokens.space2,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: CourrierTokens.accent),
                    ),
                    child: Text(
                      '$unread',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CourrierTokens.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space6),
        child: Text(
          'No subscriptions yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
