import 'package:courrier/modules/mail/backend/mail_backend.dart';
import 'package:courrier/modules/mail/render/mime_render_plan.dart';
import 'package:flutter_test/flutter_test.dart';

const _renderer = MimeRenderer();

void main() {
  group('MimeRenderer', () {
    test('text-preferred path: html with remote img still flags it', () {
      const payload = MailBodyPayload(
        textPart: 'plain hello',
        htmlPart:
            '<html><body>'
            '<img src="https://tracker.example.org/pixel.gif"/>'
            '</body></html>',
      );
      final plan = _renderer.plan(payload);
      expect(plan.preferredText, 'plain hello');
      expect(plan.hasHtml, isTrue);
      expect(plan.containedRemoteContent, isTrue);
    });

    test(
      'HTML-only: strips scripts + neutralises remote img to placeholder',
      () {
        const payload = MailBodyPayload(
          htmlPart:
              '<html><body>'
              '<h1>Hello</h1>'
              '<p>This is body text.</p>'
              '<img src="https://tracker.example.org/pixel.gif" alt="t"/>'
              '<script>alert(1)</script>'
              '<a href="https://example.org/a">Read</a>'
              '</body></html>',
        );
        final plan = _renderer.plan(payload);
        expect(plan.preferredText, contains('Hello'));
        expect(plan.preferredText, contains('This is body text.'));
        expect(plan.preferredText, contains('[image blocked]'));
        expect(plan.preferredText, isNot(contains('alert')));
        expect(plan.containedRemoteContent, isTrue);
        expect(plan.hasHtml, isTrue);
      },
    );

    test('inline data: URI image is NOT considered remote', () {
      const payload = MailBodyPayload(
        htmlPart:
            '<html><body>'
            '<img src="data:image/png;base64,AAA"/>'
            '<img src="cid:embedded@msg"/>'
            '</body></html>',
      );
      final plan = _renderer.plan(payload);
      expect(plan.containedRemoteContent, isFalse);
    });

    test('javascript: URI is stripped from anchors', () {
      const payload = MailBodyPayload(
        htmlPart:
            '<html><body>'
            '<a href="javascript:alert(1)">click</a>'
            '<a href="https://example.org">safe</a>'
            '</body></html>',
      );
      final plan = _renderer.plan(payload);
      expect(plan.preferredText, isNot(contains('javascript:')));
    });

    test('Empty body returns an empty plan with no remote-content flag', () {
      const payload = MailBodyPayload();
      final plan = _renderer.plan(payload);
      expect(plan.preferredText, '');
      expect(plan.hasHtml, isFalse);
      expect(plan.containedRemoteContent, isFalse);
    });
  });
}
