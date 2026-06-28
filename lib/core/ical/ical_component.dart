import 'ical_property.dart';

// A BEGIN:NAME ... END:NAME block. iCalendar (RFC 5545) calls these
// "components" (VCALENDAR, VEVENT, VTODO, VALARM, ...). vCard (RFC 6350)
// only has the top-level BEGIN:VCARD ... END:VCARD with no nesting, but we
// reuse the same tree to keep one reader/writer.
//
// We preserve property *order* and child-component *order* so a round-trip
// produces byte-identical text (after canonicalising to CRLF).

class IcalComponent {
  IcalComponent(String name) : name = name.toUpperCase();

  final String name;
  final List<IcalProperty> properties = <IcalProperty>[];
  final List<IcalComponent> children = <IcalComponent>[];

  // ---- Property accessors -------------------------------------------------

  /// Every property with [name] (case-insensitive). Preserves source order.
  Iterable<IcalProperty> getAll(String name) {
    final upper = name.toUpperCase();
    return properties.where((p) => p.name == upper);
  }

  /// First property with [name], or null. Use this for single-cardinality
  /// fields (DTSTART, SUMMARY, …).
  IcalProperty? get(String name) {
    final upper = name.toUpperCase();
    for (final p in properties) {
      if (p.name == upper) {
        return p;
      }
    }
    return null;
  }

  /// Replace OR insert. Cardinality-1 setter.
  void setSingle(IcalProperty property) {
    final idx = properties.indexWhere((p) => p.name == property.name);
    if (idx >= 0) {
      properties[idx] = property;
    } else {
      properties.add(property);
    }
  }

  /// Remove every property with [name]. Returns the count removed.
  int removeAll(String name) {
    final upper = name.toUpperCase();
    final before = properties.length;
    properties.removeWhere((p) => p.name == upper);
    return before - properties.length;
  }

  // ---- Child component accessors ------------------------------------------

  Iterable<IcalComponent> childrenOf(String name) {
    final upper = name.toUpperCase();
    return children.where((c) => c.name == upper);
  }

  IcalComponent? firstChild(String name) {
    final upper = name.toUpperCase();
    for (final c in children) {
      if (c.name == upper) {
        return c;
      }
    }
    return null;
  }
}
