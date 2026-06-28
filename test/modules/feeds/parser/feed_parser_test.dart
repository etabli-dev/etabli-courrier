import 'dart:io';

import 'package:courrier/modules/feeds/parser/feed_parser.dart';
import 'package:flutter_test/flutter_test.dart';

String _load(String name) =>
    File('test/fixtures/feeds/$name').readAsStringSync();

const _parser = FeedParser();

void main() {
  group('FeedParser — RSS 2.0', () {
    test('parses channel + items + content:encoded + dc:creator + pubDate', () {
      final feed = _parser.parse(_load('sample_rss.xml'));
      expect(feed.title, 'Example Tech Blog');
      expect(feed.link, 'https://example.org/blog');
      expect(feed.items, hasLength(2));

      final first = feed.items.first;
      expect(first.guid, 'https://example.org/blog/hello-rss');
      expect(first.title, 'Hello, RSS');
      expect(first.author, 'Ada Lovelace');
      // content:encoded wins over description when both present.
      expect(first.content, contains('<strong>content</strong>'));
      // pubDate parses despite +0000 timezone suffix.
      expect(first.publishedAt, DateTime.utc(2024, 2, 14, 9, 30));

      final second = feed.items.last;
      // No guid → falls back to link.
      expect(second.guid, 'https://example.org/blog/second');
      expect(second.content, 'Plain description fallback.');
      // pubDate +0100 timezone is normalised to UTC (09:00).
      expect(second.publishedAt, DateTime.utc(2024, 2, 15, 9));
    });
  });

  group('FeedParser — Atom 1.0', () {
    test('parses feed + entries + rel=alternate link + author', () {
      final feed = _parser.parse(_load('sample_atom.xml'));
      expect(feed.title, 'Example Atom Feed');
      // Prefers <link rel="alternate"> over <link rel="self">.
      expect(feed.link, 'https://example.org/atom');
      expect(feed.items, hasLength(2));

      final first = feed.items.first;
      expect(first.guid, 'tag:example.org,2024:entry-1');
      expect(first.link, 'https://example.org/atom/first');
      expect(first.author, 'Grace Hopper');
      expect(first.publishedAt, DateTime.utc(2024, 2, 14, 9, 30));
      expect(first.content, contains('<em>Atom</em>'));

      final second = feed.items.last;
      expect(second.guid, 'tag:example.org,2024:entry-2');
      // Falls back to updated when published is missing.
      expect(second.publishedAt, DateTime.utc(2024, 2, 15, 10));
      // Falls back to summary when content is missing.
      expect(second.content, 'Summary fallback.');
    });
  });

  group('FeedParser — error paths', () {
    test('Throws on unrecognised root', () {
      expect(
        () => _parser.parse('<?xml version="1.0"?><foo/>'),
        throwsA(isA<FormatException>()),
      );
    });

    test('Throws on RSS without channel', () {
      expect(
        () => _parser.parse('<?xml version="1.0"?><rss version="2.0"/>'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
