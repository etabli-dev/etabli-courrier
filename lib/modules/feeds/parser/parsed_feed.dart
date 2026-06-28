import 'package:meta/meta.dart';

// Unified shape for both RSS 2.0 and Atom 1.0 documents.

@immutable
class ParsedFeed {
  const ParsedFeed({
    required this.title,
    required this.items,
    this.link,
    this.description,
  });

  final String title;
  final String? link;
  final String? description;
  final List<ParsedFeedItem> items;
}

@immutable
class ParsedFeedItem {
  const ParsedFeedItem({
    required this.guid,
    required this.title,
    this.link,
    this.author,
    this.content,
    this.publishedAt,
  });

  final String guid;
  final String title;
  final String? link;
  final String? author;
  final String? content;
  final DateTime? publishedAt;
}
