import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/compose/reply_forward.dart';
import 'package:flutter_test/flutter_test.dart';

MailMessage _msg({
  required String subject,
  required String fromAddress,
  String? messageIdHeader,
  String? referencesHeader,
  String? toAddresses,
  String? ccAddresses,
}) => MailMessage(
  id: 1,
  folderId: 1,
  uid: 1,
  subject: subject,
  fromAddress: fromAddress,
  messageIdHeader: messageIdHeader,
  referencesHeader: referencesHeader,
  toAddresses: toAddresses,
  ccAddresses: ccAddresses,
  seen: false,
  flagged: false,
  answered: false,
  hasAttachments: false,
  bodyDownloaded: true,
  remoteContentAllowed: false,
  trashed: false,
  receivedAt: DateTime.utc(2026, 6, 28, 10),
);

void main() {
  final seeder = ReplyForwardSeeder();

  group('ReplyForwardSeeder.reply', () {
    test('Sets In-Reply-To + References + Re: prefix + quoted body', () {
      final original = _msg(
        subject: 'planning',
        fromAddress: 'alice@example.org',
        messageIdHeader: '<msg-1@example.org>',
      );
      final draft = seeder.reply(
        fromAddress: 'me@example.org',
        original: original,
        preferredText: 'Hi all,\n\nLet\'s ship.',
      );
      expect(draft.subject, 'Re: planning');
      expect(draft.toAddresses, ['alice@example.org']);
      expect(draft.inReplyTo, '<msg-1@example.org>');
      expect(draft.references, '<msg-1@example.org>');
      expect(draft.bodyText, contains('> Hi all,'));
      expect(draft.bodyText, contains('> Let'));
      expect(draft.bodyText, contains('wrote:'));
    });

    test('Does NOT double-prefix when subject already starts with Re:', () {
      final original = _msg(
        subject: 'Re: planning',
        fromAddress: 'alice@example.org',
      );
      final draft = seeder.reply(
        fromAddress: 'me@example.org',
        original: original,
        preferredText: 'ok',
      );
      expect(draft.subject, 'Re: planning');
    });

    test('reply-all carries Cc through', () {
      final original = _msg(
        subject: 'planning',
        fromAddress: 'alice@example.org',
        ccAddresses: 'bob@example.org, carol@example.org',
      );
      final draft = seeder.reply(
        fromAddress: 'me@example.org',
        original: original,
        preferredText: 'thanks',
        replyAll: true,
      );
      expect(draft.ccAddresses, ['bob@example.org', 'carol@example.org']);
    });

    test('Existing References header is extended with the new message-id', () {
      final original = _msg(
        subject: 'planning',
        fromAddress: 'alice@example.org',
        messageIdHeader: '<msg-2@example.org>',
        referencesHeader: '<msg-1@example.org>',
      );
      final draft = seeder.reply(
        fromAddress: 'me@example.org',
        original: original,
        preferredText: 'ok',
      );
      expect(draft.references, '<msg-1@example.org> <msg-2@example.org>');
    });
  });

  group('ReplyForwardSeeder.forward', () {
    test('emits "---------- Forwarded message ----------" header + body', () {
      final original = _msg(
        subject: 'planning',
        fromAddress: 'alice@example.org',
        toAddresses: 'me@example.org',
      );
      final draft = seeder.forward(
        fromAddress: 'me@example.org',
        original: original,
        preferredText: 'Body text.',
      );
      expect(draft.subject, 'Fwd: planning');
      expect(draft.toAddresses, isEmpty);
      expect(draft.bodyText, contains('Forwarded message'));
      expect(draft.bodyText, contains('From: alice@example.org'));
      expect(draft.bodyText, contains('Subject: planning'));
      expect(draft.bodyText, contains('Body text.'));
    });
  });
}
