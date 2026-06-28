import '../../../core/ical/ical_component.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_writer.dart';
import 'contact_draft.dart';

// Serialise a ContactDraft into RFC 6350 VCARD 4.0 text.
// The repository only uses this on fresh creates; updates surgically patch
// the existing component tree so unknown X-* properties survive.

class ContactSerializer {
  const ContactSerializer();

  static const IcalWriter _writer = IcalWriter();

  String render(ContactDraft draft, {required String uid}) {
    final card = IcalComponent('VCARD')
      ..properties.addAll([
        IcalProperty(name: 'VERSION', value: '4.0'),
        IcalProperty(name: 'UID', value: uid),
        IcalProperty(name: 'FN', value: draft.formattedName),
        if (draft.givenName != null || draft.familyName != null)
          IcalProperty(
            name: 'N',
            value: '${draft.familyName ?? ''};${draft.givenName ?? ''};;;',
          ),
        if (draft.organization != null)
          IcalProperty(name: 'ORG', value: draft.organization!),
        for (final email in draft.emails)
          IcalProperty(
            name: 'EMAIL',
            parameters: email.type == null
                ? const <String, List<String>>{}
                : <String, List<String>>{
                    'TYPE': [email.type!],
                  },
            value: email.value,
          ),
        for (final phone in draft.phones)
          IcalProperty(
            name: 'TEL',
            parameters: phone.type == null
                ? const <String, List<String>>{}
                : <String, List<String>>{
                    'TYPE': [phone.type!],
                  },
            value: phone.value,
          ),
        for (final address in draft.addresses)
          IcalProperty(
            name: 'ADR',
            parameters: address.type == null
                ? const <String, List<String>>{}
                : <String, List<String>>{
                    'TYPE': [address.type!],
                  },
            value: address.toVcardValue(),
          ),
        if (draft.note != null) IcalProperty(name: 'NOTE', value: draft.note!),
        if (draft.photoBase64 != null)
          IcalProperty(
            name: 'PHOTO',
            value:
                'data:${draft.photoMimeType ?? 'image/png'};base64,'
                '${draft.photoBase64}',
          )
        else if (draft.photoUri != null)
          IcalProperty(name: 'PHOTO', value: draft.photoUri!),
      ]);

    return _writer.render(card);
  }
}
