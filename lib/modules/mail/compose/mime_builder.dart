import 'package:enough_mail/enough_mail.dart';

import 'compose_draft.dart';

// Build RFC 5322 bytes from a ComposeDraft. Uses enough_mail's MessageBuilder
// so MIME headers, encoding, and multipart layout are RFC-correct.

class MimeBuilder {
  const MimeBuilder();

  String buildRfc822(ComposeDraft draft) {
    final builder =
        MessageBuilder.prepareMessageWithMediaType(MediaSubtype.textPlain)
          ..from = [
            MailAddress(_extractName(draft.fromAddress), draft.fromAddress),
          ]
          ..to = draft.toAddresses
              .map((s) => MailAddress(_extractName(s), _extractEmail(s)))
              .toList(growable: false)
          ..cc = draft.ccAddresses
              .map((s) => MailAddress(_extractName(s), _extractEmail(s)))
              .toList(growable: false)
          ..bcc = draft.bccAddresses
              .map((s) => MailAddress(_extractName(s), _extractEmail(s)))
              .toList(growable: false)
          ..subject = draft.subject ?? '(no subject)';

    if (draft.inReplyTo != null) {
      builder.addHeader('In-Reply-To', draft.inReplyTo!);
    }
    if (draft.references != null) {
      builder.addHeader('References', draft.references!);
    }

    builder.text = draft.bodyText ?? '';

    if (draft.bodyHtml != null && draft.bodyHtml!.isNotEmpty) {
      builder.addTextHtml(draft.bodyHtml!);
    }

    for (final attachment in draft.attachments) {
      builder.addBinary(
        attachment.bytes,
        MediaType.fromText(attachment.mimeType),
        filename: attachment.filename,
      );
    }

    final mime = builder.buildMimeMessage();
    return mime.renderMessage();
  }

  String _extractName(String addressLine) {
    final match = RegExp(r'^"?([^<"]*)"?\s*<').firstMatch(addressLine);
    return match?.group(1)?.trim() ?? '';
  }

  String _extractEmail(String addressLine) {
    final match = RegExp(r'<([^>]+)>').firstMatch(addressLine);
    if (match != null) {
      return match.group(1)!.trim();
    }
    return addressLine.trim();
  }
}
