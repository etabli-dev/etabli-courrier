import 'package:courrier/modules/mail/compose/compose_draft.dart';
import 'package:courrier/modules/mail/compose/mime_builder.dart';
import 'package:flutter_test/flutter_test.dart';

const _builder = MimeBuilder();

void main() {
  group('MimeBuilder', () {
    test('emits RFC 5322 headers + body for a simple plain message', () {
      const draft = ComposeDraft(
        fromAddress: 'me@example.org',
        toAddresses: ['alice@example.org'],
        subject: 'Hello',
        bodyText: 'World',
      );
      final bytes = _builder.buildRfc822(draft);
      expect(bytes, contains('From: '));
      expect(bytes, contains('To: '));
      expect(bytes, contains('Subject: Hello'));
      expect(bytes, contains('World'));
    });

    test('reply: emits In-Reply-To + References + Re: subject', () {
      const draft = ComposeDraft(
        fromAddress: 'me@example.org',
        toAddresses: ['alice@example.org'],
        subject: 'Re: planning',
        bodyText: 'Sounds good.',
        inReplyTo: '<msg-1@example.org>',
        references: '<msg-1@example.org>',
      );
      final bytes = _builder.buildRfc822(draft);
      expect(bytes, contains('In-Reply-To: <msg-1@example.org>'));
      expect(bytes, contains('References: <msg-1@example.org>'));
      expect(bytes, contains('Subject: Re: planning'));
    });

    test('emits Cc + Bcc when provided', () {
      const draft = ComposeDraft(
        fromAddress: 'me@example.org',
        toAddresses: ['alice@example.org'],
        ccAddresses: ['bob@example.org'],
        bccAddresses: ['carol@example.org'],
        subject: 'Multi',
        bodyText: 'Body.',
      );
      final bytes = _builder.buildRfc822(draft);
      expect(bytes, contains('Cc: '));
      expect(bytes, contains('Bcc: '));
    });
  });
}
