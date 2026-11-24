import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/widgets/date_locale.dart';
import '../../../l10n/l10n.dart';
import 'compose_draft.dart';

// Reply / forward seeders. Take an existing message (and the user's identity)
// and return a ComposeDraft with the right Subject prefix, In-Reply-To /
// References chain, and quoted body. Reuses the M2 mail rendering output for
// the quote so HTML messages still produce a readable quoted body.

class ReplyForwardSeeder {
  ReplyForwardSeeder({this.dateFormat});

  /// Overrides the current app language's quote-date format.
  final DateFormat? dateFormat;

  String _formatDate(DateTime value) {
    final l10n = L10n.current;
    return (dateFormat ??
            DateFormat(l10n.mailQuoteDatePattern, l10n.dateLocale))
        .format(value);
  }

  ComposeDraft reply({
    required String fromAddress,
    required MailMessage original,
    required String preferredText,
    bool replyAll = false,
  }) {
    final subject = _withPrefix(original.subject, 'Re:');
    final references = _composeReferences(original);
    final quotedBody = _quoteBody(
      preferredText: preferredText,
      original: original,
    );
    final to = [original.fromAddress ?? ''].where((s) => s.isNotEmpty).toList();
    final cc = replyAll
        ? (original.ccAddresses ?? '')
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList()
        : const <String>[];
    return ComposeDraft(
      fromAddress: fromAddress,
      toAddresses: to,
      ccAddresses: cc,
      subject: subject,
      bodyText: quotedBody,
      inReplyTo: original.messageIdHeader,
      references: references,
    );
  }

  ComposeDraft forward({
    required String fromAddress,
    required MailMessage original,
    required String preferredText,
  }) {
    final subject = _withPrefix(original.subject, 'Fwd:');
    final l10n = L10n.current;
    final body = StringBuffer()
      ..writeln(l10n.mailForwardHeader)
      ..writeln(l10n.mailForwardFrom(original.fromAddress ?? ''))
      ..writeln(l10n.mailForwardDate(_formatDate(original.receivedAt)))
      ..writeln(l10n.mailForwardSubject(original.subject ?? ''))
      ..writeln(l10n.mailForwardTo(original.toAddresses ?? ''))
      ..writeln()
      ..writeln(preferredText);
    return ComposeDraft(
      fromAddress: fromAddress,
      toAddresses: const <String>[],
      subject: subject,
      bodyText: body.toString(),
      references: _composeReferences(original),
    );
  }

  String _quoteBody({
    required String preferredText,
    required MailMessage original,
  }) {
    final l10n = L10n.current;
    final intro = l10n.mailReplyIntro(
      _formatDate(original.receivedAt),
      original.fromAddress ?? l10n.mailReplySomeone,
    );
    final quoted = preferredText
        .split('\n')
        .map((line) => '> $line')
        .join('\n');
    return '\n\n$intro\n$quoted\n';
  }

  String _withPrefix(String? subject, String prefix) {
    if (subject == null || subject.isEmpty) {
      return prefix;
    }
    final lowered = subject.toLowerCase();
    if (lowered.startsWith(prefix.toLowerCase())) {
      return subject;
    }
    return '$prefix $subject';
  }

  String _composeReferences(MailMessage original) {
    final existing = original.referencesHeader ?? '';
    final messageId = original.messageIdHeader ?? '';
    if (existing.isEmpty) {
      return messageId;
    }
    if (messageId.isEmpty) {
      return existing;
    }
    return '$existing $messageId';
  }
}
