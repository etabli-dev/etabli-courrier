import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:meta/meta.dart';

import '../backend/mail_backend.dart';

// Produces a sanitised render plan from a MailBodyPayload.
//
// AUDIT_LOOP dim 4 invariant: **no remote content is ever fetched at render
// time.** When the user explicitly reveals remote images, the renderer
// surfaces them — until then, every off-site `<img src="…">` and `<link>` is
// rewritten to a placeholder. Scripts and event handlers are always stripped.

@immutable
class MimeRenderPlan {
  const MimeRenderPlan({
    required this.preferredText,
    required this.attachments,
    required this.hasHtml,
    required this.containedRemoteContent,
  });

  /// Lossy plain-text representation of the chosen body. Empty when there is
  /// no text part and the HTML couldn't be reduced to anything meaningful.
  final String preferredText;
  final List<MailAttachmentInfo> attachments;
  final bool hasHtml;

  /// True when the original body contained a `<img>` with a non-data URI, or
  /// a `<link>`, `<iframe>`, etc. The UI surfaces "Show images" when this is
  /// true and the user hasn't yet allowed remote content.
  final bool containedRemoteContent;

  bool get hasAttachments => attachments.isNotEmpty;
}

class MimeRenderer {
  const MimeRenderer();

  MimeRenderPlan plan(MailBodyPayload payload) {
    final textPart = payload.textPart;
    if (textPart != null && textPart.trim().isNotEmpty) {
      // Plain-text preferred — short-circuit. If an HTML alternative exists
      // we still surface the remote-content flag so the UI's "Show images"
      // toggle is consistent with what the user would see if they switched.
      final htmlPart = payload.htmlPart;
      final containedRemote =
          htmlPart != null && _detectRemoteContent(htmlPart);
      return MimeRenderPlan(
        preferredText: textPart,
        attachments: payload.attachments,
        hasHtml: htmlPart != null && htmlPart.isNotEmpty,
        containedRemoteContent: containedRemote,
      );
    }
    final htmlPart = payload.htmlPart;
    if (htmlPart == null || htmlPart.isEmpty) {
      return MimeRenderPlan(
        preferredText: '',
        attachments: payload.attachments,
        hasHtml: false,
        containedRemoteContent: false,
      );
    }
    final containedRemote = _detectRemoteContent(htmlPart);
    final text = sanitiseHtmlToText(htmlPart);
    return MimeRenderPlan(
      preferredText: text,
      attachments: payload.attachments,
      hasHtml: true,
      containedRemoteContent: containedRemote,
    );
  }

  /// Parse the HTML, drop scripts/styles/embeds, replace remote `<img>` /
  /// `<link>` with placeholders, and return plain text. The output is what
  /// the M6 read path surfaces in the message viewer — no widget tree means
  /// nothing can issue a network call at render time.
  String sanitiseHtmlToText(String htmlSource) {
    final document = html_parser.parse(htmlSource);
    _stripUnsafeElements(document);
    _neutraliseRemoteContent(document);
    final body = document.body ?? document.documentElement;
    if (body == null) {
      return '';
    }
    final buffer = StringBuffer();
    _walkText(body, buffer);
    return buffer.toString().trim();
  }

  bool _detectRemoteContent(String htmlSource) {
    final document = html_parser.parse(htmlSource);
    for (final element in document.querySelectorAll('img')) {
      final src = element.attributes['src'];
      if (src != null && _isRemoteUri(src)) {
        return true;
      }
    }
    for (final element in document.querySelectorAll('link')) {
      final href = element.attributes['href'];
      if (href != null && _isRemoteUri(href)) {
        return true;
      }
    }
    if (document.querySelectorAll('iframe').isNotEmpty) {
      return true;
    }
    return false;
  }

  void _stripUnsafeElements(dom.Document document) {
    const tagsToRemove = {
      'script',
      'style',
      'iframe',
      'object',
      'embed',
      'form',
      'input',
      'button',
    };
    for (final element in document.querySelectorAll('*').toList()) {
      if (tagsToRemove.contains(element.localName)) {
        element.remove();
        continue;
      }
      // Strip on* event handlers + javascript: URIs from any surviving tag.
      final attrs = Map<Object, String>.from(element.attributes);
      attrs.forEach((key, value) {
        final name = key.toString().toLowerCase();
        if (name.startsWith('on')) {
          element.attributes.remove(key);
        } else if (name == 'href' || name == 'src') {
          if (value.trimLeft().toLowerCase().startsWith('javascript:')) {
            element.attributes.remove(key);
          }
        }
      });
    }
  }

  void _neutraliseRemoteContent(dom.Document document) {
    for (final element in document.querySelectorAll('img').toList()) {
      final src = element.attributes['src'];
      if (src == null || _isRemoteUri(src)) {
        final placeholder = dom.Text('[image blocked]');
        element.replaceWith(placeholder);
      }
    }
    for (final element in document.querySelectorAll('link').toList()) {
      element.remove();
    }
  }

  void _walkText(dom.Node node, StringBuffer buffer) {
    if (node is dom.Text) {
      buffer.write(node.text);
      return;
    }
    if (node is dom.Element) {
      if (const {
        'p',
        'br',
        'div',
        'h1',
        'h2',
        'h3',
        'li',
      }.contains(node.localName)) {
        if (buffer.isNotEmpty && !buffer.toString().endsWith('\n')) {
          buffer.write('\n');
        }
      }
      for (final child in node.nodes) {
        _walkText(child, buffer);
      }
      if (const {'p', 'div', 'h1', 'h2', 'h3', 'li'}.contains(node.localName)) {
        buffer.write('\n');
      }
    }
  }

  bool _isRemoteUri(String uri) {
    final trimmed = uri.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return false;
    }
    if (trimmed.startsWith('data:') ||
        trimmed.startsWith('cid:') ||
        trimmed.startsWith('#')) {
      return false;
    }
    return trimmed.startsWith('http:') ||
        trimmed.startsWith('https:') ||
        trimmed.startsWith('//');
  }
}
