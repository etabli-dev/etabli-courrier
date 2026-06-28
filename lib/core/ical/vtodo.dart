import 'ical_component.dart';

// Typed lens over a VTODO. Subtasks are surfaced via RELATED-TO;RELTYPE=PARENT
// per BUILD_PROMPT M5 — the parentUid getter resolves that conventionally.

class VTodo {
  VTodo.from(this.component)
    : assert(component.name == 'VTODO', 'VTodo must wrap a VTODO component');

  final IcalComponent component;

  String? get uid => component.get('UID')?.value;
  String? get summary => component.get('SUMMARY')?.value;
  String? get description => component.get('DESCRIPTION')?.value;
  String? get due => component.get('DUE')?.value;
  String? get completed => component.get('COMPLETED')?.value;
  String? get percentComplete => component.get('PERCENT-COMPLETE')?.value;
  String? get priority => component.get('PRIORITY')?.value;
  String? get rrule => component.get('RRULE')?.value;

  // RELATED-TO with RELTYPE=PARENT (or no RELTYPE, which defaults to PARENT
  // per RFC 5545 §3.8.4.5).
  String? get parentUid {
    for (final p in component.getAll('RELATED-TO')) {
      final relType = p.param('RELTYPE');
      if (relType == null || relType.toUpperCase() == 'PARENT') {
        return p.value;
      }
    }
    return null;
  }
}
