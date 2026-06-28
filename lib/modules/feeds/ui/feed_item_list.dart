import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';

class FeedItemList extends StatelessWidget {
  FeedItemList({required this.items, this.onItemTap, super.key});

  final List<FeedItem> items;
  final ValueChanged<FeedItem>? onItemTap;

  final DateFormat _date = DateFormat.MMMd();

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const _Empty();
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space3,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space4),
      itemBuilder: (context, i) {
        final item = items[i];
        return InkWell(
          onTap: onItemTap == null ? null : () => onItemTap!(item),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: CourrierTokens.space2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!item.read)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(
                      top: 6,
                      right: CourrierTokens.space2,
                    ),
                    color: CourrierTokens.accent,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: CourrierTokens.space1),
                      Row(
                        children: [
                          if (item.author != null) ...[
                            Expanded(
                              child: Text(
                                item.author!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ] else
                            const Spacer(),
                          if (item.publishedAt != null)
                            Text(
                              _date.format(item.publishedAt!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ],
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
          'No items in this feed.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
