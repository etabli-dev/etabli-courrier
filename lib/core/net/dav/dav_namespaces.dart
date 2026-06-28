// DAV / CalDAV / CardDAV / Apple iCal XML namespaces.

class DavNs {
  const DavNs._();

  static const String dav = 'DAV:';
  static const String calDav = 'urn:ietf:params:xml:ns:caldav';
  static const String cardDav = 'urn:ietf:params:xml:ns:carddav';
  // Apple's iCal extension namespace — `calendar-order`, `calendar-color`
  // etc. show up here on Nextcloud (which mirrors Apple's wire format).
  static const String appleIcal = 'http://apple.com/ns/ical/';
}
