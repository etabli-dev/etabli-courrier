import 'ical_component.dart';

// Typed lens over a VCARD (RFC 6350). Multi-value structured properties (N,
// ADR) carry semicolon-separated components in their value — typed splitting
// is the contact module's job at M4; here we just expose raw values so unknown
// X-* properties survive round-trip.

class VCard {
  VCard.from(this.component)
    : assert(component.name == 'VCARD', 'VCard must wrap a VCARD component');

  final IcalComponent component;

  String? get version => component.get('VERSION')?.value;
  String? get uid => component.get('UID')?.value;
  String? get formattedName => component.get('FN')?.value;
  String? get structuredName => component.get('N')?.value;
  String? get organization => component.get('ORG')?.value;

  Iterable<String> get emails => component.getAll('EMAIL').map((p) => p.value);
  Iterable<String> get phones => component.getAll('TEL').map((p) => p.value);
  Iterable<String> get addresses => component.getAll('ADR').map((p) => p.value);
}
