import 'dart:typed_data';

import 'package:meta/meta.dart';

// Editor-side payload for a message being composed. Plain data only.

@immutable
class ComposeAttachment {
  const ComposeAttachment({
    required this.filename,
    required this.mimeType,
    required this.bytes,
  });
  final String filename;
  final String mimeType;
  final Uint8List bytes;
}

@immutable
class ComposeDraft {
  const ComposeDraft({
    required this.fromAddress,
    required this.toAddresses,
    this.ccAddresses = const <String>[],
    this.bccAddresses = const <String>[],
    this.subject,
    this.bodyText,
    this.bodyHtml,
    this.attachments = const <ComposeAttachment>[],
    this.inReplyTo,
    this.references,
  });

  final String fromAddress;
  final List<String> toAddresses;
  final List<String> ccAddresses;
  final List<String> bccAddresses;
  final String? subject;
  final String? bodyText;
  final String? bodyHtml;
  final List<ComposeAttachment> attachments;

  /// Set when this is a reply — propagates onto In-Reply-To.
  final String? inReplyTo;

  /// Set on replies and forwards — propagates onto References.
  final String? references;

  bool get isReply => inReplyTo != null;

  ComposeDraft copyWith({
    List<String>? toAddresses,
    List<String>? ccAddresses,
    List<String>? bccAddresses,
    String? subject,
    String? bodyText,
    String? bodyHtml,
    List<ComposeAttachment>? attachments,
  }) => ComposeDraft(
    fromAddress: fromAddress,
    toAddresses: toAddresses ?? this.toAddresses,
    ccAddresses: ccAddresses ?? this.ccAddresses,
    bccAddresses: bccAddresses ?? this.bccAddresses,
    subject: subject ?? this.subject,
    bodyText: bodyText ?? this.bodyText,
    bodyHtml: bodyHtml ?? this.bodyHtml,
    attachments: attachments ?? this.attachments,
    inReplyTo: inReplyTo,
    references: references,
  );
}
