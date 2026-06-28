import 'package:xml/xml.dart';

import 'parsed_feed.dart';

// Standalone RSS 2.0 + Atom 1.0 parser. Used as the bundled fallback when a
// feed sits outside the user's Nextcloud News install.
//
// Handles the common real-world variants:
//   * RSS 2.0 `<item>` with `<description>` or `<content:encoded>`
//   * Atom 1.0 `<entry>` with `<content>` or `<summary>`
//   * Atom 1.0 `<link rel="alternate">` (preferred) vs `<link>` text body
//   * `<pubDate>` / `<dc:date>` / `<published>` / `<updated>`
//   * `<guid>` / `<id>` — falls back to the link when neither is present

class FeedParser {
  const FeedParser();

  ParsedFeed parse(String xmlSource) {
    final document = XmlDocument.parse(xmlSource);
    final root = document.rootElement;
    final localName = root.localName.toLowerCase();
    if (localName == 'rss') {
      return _parseRss(root);
    }
    if (localName == 'feed') {
      return _parseAtom(root);
    }
    throw FormatException('Unrecognised feed root: $localName');
  }

  ParsedFeed _parseRss(XmlElement rss) {
    final channel = rss.findElements('channel').firstOrNull;
    if (channel == null) {
      throw const FormatException('RSS missing <channel>');
    }
    final items = channel
        .findElements('item')
        .map(_parseRssItem)
        .whereType<ParsedFeedItem>()
        .toList(growable: false);
    return ParsedFeed(
      title: _text(channel, 'title') ?? '',
      link: _text(channel, 'link'),
      description: _text(channel, 'description'),
      items: items,
    );
  }

  ParsedFeedItem? _parseRssItem(XmlElement item) {
    final title = _text(item, 'title') ?? '';
    final link = _text(item, 'link');
    final guid = _text(item, 'guid') ?? link;
    if (guid == null || guid.isEmpty) {
      return null;
    }
    final encoded = item
        .findElements(
          'encoded',
          namespace: 'http://purl.org/rss/1.0/modules/content/',
        )
        .firstOrNull
        ?.innerText;
    final content = encoded ?? _text(item, 'description');
    final author =
        _text(item, 'author') ??
        item
            .findElements(
              'creator',
              namespace: 'http://purl.org/dc/elements/1.1/',
            )
            .firstOrNull
            ?.innerText;
    final pubDate =
        _text(item, 'pubDate') ??
        item
            .findElements('date', namespace: 'http://purl.org/dc/elements/1.1/')
            .firstOrNull
            ?.innerText;
    return ParsedFeedItem(
      guid: guid,
      title: title,
      link: link,
      author: author,
      content: content,
      publishedAt: _parseDate(pubDate),
    );
  }

  ParsedFeed _parseAtom(XmlElement feed) {
    final items = feed
        .findElements('entry')
        .map(_parseAtomItem)
        .whereType<ParsedFeedItem>()
        .toList(growable: false);
    return ParsedFeed(
      title: _text(feed, 'title') ?? '',
      link: _atomLink(feed),
      description: _text(feed, 'subtitle'),
      items: items,
    );
  }

  ParsedFeedItem? _parseAtomItem(XmlElement entry) {
    final id = _text(entry, 'id');
    final link = _atomLink(entry);
    final guid = id ?? link;
    if (guid == null || guid.isEmpty) {
      return null;
    }
    final title = _text(entry, 'title') ?? '';
    final content = _text(entry, 'content') ?? _text(entry, 'summary');
    final author = entry
        .findElements('author')
        .firstOrNull
        ?.findElements('name')
        .firstOrNull
        ?.innerText;
    final published = _text(entry, 'published') ?? _text(entry, 'updated');
    return ParsedFeedItem(
      guid: guid,
      title: title,
      link: link,
      author: author,
      content: content,
      publishedAt: _parseDate(published),
    );
  }

  String? _text(XmlElement parent, String name) {
    final element = parent.findElements(name).firstOrNull;
    return element?.innerText.trim().isEmpty == true
        ? null
        : element?.innerText.trim();
  }

  /// Atom prefers `<link rel="alternate">`; falls back to the first link.
  String? _atomLink(XmlElement element) {
    final links = element.findElements('link').toList();
    final alternate = links.firstWhere(
      (l) => (l.getAttribute('rel') ?? 'alternate') == 'alternate',
      orElse: () => links.isEmpty ? XmlElement(XmlName('link')) : links.first,
    );
    final href = alternate.getAttribute('href');
    if (href != null && href.isNotEmpty) {
      return href;
    }
    final inner = alternate.innerText.trim();
    return inner.isEmpty ? null : inner;
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null) {
      return null;
    }
    final trimmed = raw.trim();
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return iso;
    }
    return _parseRfc822(trimmed);
  }

  /// Parses `Wed, 14 Feb 2024 12:34:56 +0000` style RSS pubDate values.
  /// Handles the most common timezone suffixes (GMT, UTC, ±HHMM) and the
  /// three-letter US zones browsers still emit (EST, PST, …).
  DateTime? _parseRfc822(String value) {
    final pattern = RegExp(
      r'^(?:[A-Za-z]{3},\s*)?(\d{1,2})\s+([A-Za-z]{3})\s+(\d{2,4})\s+'
      r'(\d{2}):(\d{2})(?::(\d{2}))?\s*([+-]\d{4}|[A-Z]{2,3})?$',
    );
    final match = pattern.firstMatch(value.trim());
    if (match == null) {
      return null;
    }
    final day = int.tryParse(match.group(1)!);
    final monthAbbr = match.group(2)!;
    final yearRaw = match.group(3)!;
    final year = yearRaw.length == 2
        ? 2000 + int.parse(yearRaw)
        : int.parse(yearRaw);
    final hour = int.tryParse(match.group(4)!);
    final minute = int.tryParse(match.group(5)!);
    final second = match.group(6) == null ? 0 : int.parse(match.group(6)!);
    final tz = match.group(7) ?? '+0000';
    if (day == null || hour == null || minute == null) {
      return null;
    }
    final month = _monthFromAbbr(monthAbbr);
    if (month == null) {
      return null;
    }
    var offsetMinutes = 0;
    if (tz.startsWith('+') || tz.startsWith('-')) {
      final sign = tz.startsWith('-') ? -1 : 1;
      final hh = int.tryParse(tz.substring(1, 3)) ?? 0;
      final mm = int.tryParse(tz.substring(3, 5)) ?? 0;
      offsetMinutes = sign * (hh * 60 + mm);
    } else if (tz == 'UT' || tz == 'GMT' || tz == 'UTC' || tz == 'Z') {
      offsetMinutes = 0;
    } else if (tz == 'EST') {
      offsetMinutes = -5 * 60;
    } else if (tz == 'EDT') {
      offsetMinutes = -4 * 60;
    } else if (tz == 'CST') {
      offsetMinutes = -6 * 60;
    } else if (tz == 'PST') {
      offsetMinutes = -8 * 60;
    } else if (tz == 'PDT') {
      offsetMinutes = -7 * 60;
    }
    final utc = DateTime.utc(
      year,
      month,
      day,
      hour,
      minute,
      second,
    ).subtract(Duration(minutes: offsetMinutes));
    return utc;
  }

  int? _monthFromAbbr(String abbr) {
    const months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    final idx = months.indexOf(abbr.toLowerCase());
    return idx < 0 ? null : idx + 1;
  }
}
