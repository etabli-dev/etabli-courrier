// Canned XML bodies for the PROPFIND / REPORT requests audit dim 7 expects.
// Kept as plain strings (no string interpolation of caller-supplied data, to
// keep the surface trivially auditable).

class DavRequests {
  const DavRequests._();

  // ---- PROPFIND bodies ----------------------------------------------------

  /// Walk to the user's principal URL via current-user-principal.
  static const String currentUserPrincipal = '''
<?xml version="1.0" encoding="utf-8"?>
<D:propfind xmlns:D="DAV:">
  <D:prop>
    <D:current-user-principal/>
  </D:prop>
</D:propfind>
''';

  /// On a principal URL, find the user's calendar and address-book home sets.
  static const String homeSets = '''
<?xml version="1.0" encoding="utf-8"?>
<D:propfind xmlns:D="DAV:"
            xmlns:C="urn:ietf:params:xml:ns:caldav"
            xmlns:CR="urn:ietf:params:xml:ns:carddav">
  <D:prop>
    <C:calendar-home-set/>
    <CR:addressbook-home-set/>
  </D:prop>
</D:propfind>
''';

  /// Enumerate collections inside a home set. Pulls every named property the
  /// audit checks for (M2 dim 7 + M1 schema).
  static const String enumerateCollections = '''
<?xml version="1.0" encoding="utf-8"?>
<D:propfind xmlns:D="DAV:"
            xmlns:C="urn:ietf:params:xml:ns:caldav"
            xmlns:CR="urn:ietf:params:xml:ns:carddav"
            xmlns:CS="http://calendarserver.org/ns/"
            xmlns:A="http://apple.com/ns/ical/">
  <D:prop>
    <D:resourcetype/>
    <D:displayname/>
    <D:sync-token/>
    <CS:getctag/>
    <C:supported-calendar-component-set/>
    <A:calendar-color/>
    <A:calendar-order/>
  </D:prop>
</D:propfind>
''';

  // ---- REPORT bodies ------------------------------------------------------

  /// sync-collection REPORT with the caller's sync-token. Empty token → server
  /// must return a full enumeration plus a fresh token (RFC 6578 §3.4).
  static String syncCollection({String? syncToken}) {
    final tokenElement = syncToken != null && syncToken.isNotEmpty
        ? '<D:sync-token>$syncToken</D:sync-token>'
        : '<D:sync-token/>';
    return '''
<?xml version="1.0" encoding="utf-8"?>
<D:sync-collection xmlns:D="DAV:">
  $tokenElement
  <D:sync-level>1</D:sync-level>
  <D:prop>
    <D:getetag/>
  </D:prop>
</D:sync-collection>
''';
  }

  /// calendar-multiget for a list of hrefs. The server returns the matching
  /// VEVENTs/VTODOs along with their etags so the offline store stays
  /// authoritative.
  static String calendarMultiget(Iterable<String> hrefs) {
    final hrefXml = hrefs
        .map((h) => '  <D:href>${_escape(h)}</D:href>')
        .join('\n');
    return '''
<?xml version="1.0" encoding="utf-8"?>
<C:calendar-multiget xmlns:D="DAV:"
                     xmlns:C="urn:ietf:params:xml:ns:caldav">
  <D:prop>
    <D:getetag/>
    <C:calendar-data/>
  </D:prop>
$hrefXml
</C:calendar-multiget>
''';
  }

  static String addressbookMultiget(Iterable<String> hrefs) {
    final hrefXml = hrefs
        .map((h) => '  <D:href>${_escape(h)}</D:href>')
        .join('\n');
    return '''
<?xml version="1.0" encoding="utf-8"?>
<CR:addressbook-multiget xmlns:D="DAV:"
                         xmlns:CR="urn:ietf:params:xml:ns:carddav">
  <D:prop>
    <D:getetag/>
    <CR:address-data/>
  </D:prop>
$hrefXml
</CR:addressbook-multiget>
''';
  }

  static String _escape(String s) {
    return s
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
