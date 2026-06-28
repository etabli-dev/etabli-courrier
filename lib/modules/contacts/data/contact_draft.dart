import 'package:meta/meta.dart';

// Editor-side payload — pure data, no IO.
//
// Photo handling: small inline photos land in `photoBase64` (the writer emits
// `PHOTO;ENCODING=b;TYPE=PNG:<base64>` or RFC 6350 4.0 `PHOTO:data:image/png;base64,<…>`).
// Larger photos can land in `photoUri` (file:// path or HTTPS URL); the editor
// surfaces whichever is set. M4 doesn't crop/scale — that's M11 polish.

@immutable
class ContactEmail {
  const ContactEmail({required this.value, this.type});
  final String value;
  final String? type;
}

@immutable
class ContactPhone {
  const ContactPhone({required this.value, this.type});
  final String value;
  final String? type;
}

@immutable
class ContactAddress {
  const ContactAddress({
    this.poBox = '',
    this.extended = '',
    this.street = '',
    this.locality = '',
    this.region = '',
    this.postalCode = '',
    this.country = '',
    this.type,
  });

  final String poBox;
  final String extended;
  final String street;
  final String locality;
  final String region;
  final String postalCode;
  final String country;
  final String? type;

  /// RFC 6350 §6.3.1 ADR value: semicolon-delimited 7-tuple.
  String toVcardValue() =>
      '$poBox;$extended;$street;$locality;$region;$postalCode;$country';
}

@immutable
class ContactDraft {
  const ContactDraft({
    required this.collectionId,
    required this.formattedName,
    this.uid,
    this.givenName,
    this.familyName,
    this.organization,
    this.emails = const <ContactEmail>[],
    this.phones = const <ContactPhone>[],
    this.addresses = const <ContactAddress>[],
    this.note,
    this.photoBase64,
    this.photoMimeType,
    this.photoUri,
    this.groupIds = const <int>[],
  });

  final int collectionId;
  final String? uid;
  final String formattedName;
  final String? givenName;
  final String? familyName;
  final String? organization;
  final List<ContactEmail> emails;
  final List<ContactPhone> phones;
  final List<ContactAddress> addresses;
  final String? note;
  final String? photoBase64;
  final String? photoMimeType;
  final String? photoUri;
  final List<int> groupIds;

  String? get primaryEmail => emails.isEmpty ? null : emails.first.value;
  String? get primaryPhone => phones.isEmpty ? null : phones.first.value;

  ContactDraft copyWith({
    String? formattedName,
    String? givenName,
    String? familyName,
    String? organization,
    List<ContactEmail>? emails,
    List<ContactPhone>? phones,
    List<ContactAddress>? addresses,
    String? note,
    String? photoBase64,
    String? photoMimeType,
    String? photoUri,
    List<int>? groupIds,
  }) => ContactDraft(
    collectionId: collectionId,
    uid: uid,
    formattedName: formattedName ?? this.formattedName,
    givenName: givenName ?? this.givenName,
    familyName: familyName ?? this.familyName,
    organization: organization ?? this.organization,
    emails: emails ?? this.emails,
    phones: phones ?? this.phones,
    addresses: addresses ?? this.addresses,
    note: note ?? this.note,
    photoBase64: photoBase64 ?? this.photoBase64,
    photoMimeType: photoMimeType ?? this.photoMimeType,
    photoUri: photoUri ?? this.photoUri,
    groupIds: groupIds ?? this.groupIds,
  );
}
