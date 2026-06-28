import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import 'dav_namespaces.dart';

// Parse a DAV `<multistatus>` response into a structured list of resources +
// their named properties. We expose:
//   * href                                      — the resource URL
//   * status (per-property)                     — HTTP 200/404
//   * a flat map of (namespace, localName) → raw String values
// And typed helpers for the named properties the audit checks for:
//   * displayname, getctag, sync-token, getetag, resourcetype, calendar-color,
//     calendar-order, supported-calendar-component-set, current-user-principal,
//     calendar-home-set, addressbook-home-set.

@immutable
class DavPropertyKey {
  const DavPropertyKey(this.namespace, this.localName);

  final String namespace;
  final String localName;

  @override
  bool operator ==(Object other) =>
      other is DavPropertyKey &&
      other.namespace == namespace &&
      other.localName == localName;

  @override
  int get hashCode => Object.hash(namespace, localName);

  @override
  String toString() => '{$namespace}$localName';
}

@immutable
class DavResource {
  const DavResource({
    required this.href,
    required this.properties,
    required this.resourceTypes,
  });

  final String href;
  final Map<DavPropertyKey, String> properties;

  /// Element names found inside `<resourcetype>` (e.g. `calendar`, `collection`,
  /// `addressbook`). Useful for filtering principal vs collection vs item.
  final Set<DavPropertyKey> resourceTypes;

  String? get displayName =>
      properties[const DavPropertyKey(DavNs.dav, 'displayname')];

  String? get etag => properties[const DavPropertyKey(DavNs.dav, 'getetag')];

  String? get ctag =>
      properties[const DavPropertyKey(
        'http://calendarserver.org/ns/',
        'getctag',
      )];

  String? get syncToken =>
      properties[const DavPropertyKey(DavNs.dav, 'sync-token')];

  String? get calendarColor =>
      properties[const DavPropertyKey(DavNs.appleIcal, 'calendar-color')];

  String? get calendarOrder =>
      properties[const DavPropertyKey(DavNs.appleIcal, 'calendar-order')];

  String? get supportedCalendarComponentSet =>
      properties[const DavPropertyKey(
        DavNs.calDav,
        'supported-calendar-component-set',
      )];

  String? get currentUserPrincipal =>
      properties[const DavPropertyKey(DavNs.dav, 'current-user-principal')];

  String? get calendarHomeSet =>
      properties[const DavPropertyKey(DavNs.calDav, 'calendar-home-set')];

  String? get addressbookHomeSet =>
      properties[const DavPropertyKey(DavNs.cardDav, 'addressbook-home-set')];

  bool get isCalendar => resourceTypes.any(
    (k) => k.namespace == DavNs.calDav && k.localName == 'calendar',
  );

  bool get isAddressbook => resourceTypes.any(
    (k) => k.namespace == DavNs.cardDav && k.localName == 'addressbook',
  );
}

class Multistatus {
  Multistatus(this.resources);

  factory Multistatus.parse(String xml) {
    final document = XmlDocument.parse(xml);
    final root = document.rootElement;
    if (root.localName != 'multistatus') {
      throw FormatException(
        'Expected <multistatus> root, got <${root.qualifiedName}>',
      );
    }
    final resources = <DavResource>[];
    for (final response in root.findElements(
      'response',
      namespace: DavNs.dav,
    )) {
      final hrefElement = response
          .findElements('href', namespace: DavNs.dav)
          .firstOrNull;
      if (hrefElement == null) {
        continue;
      }
      final href = hrefElement.innerText.trim();
      final props = <DavPropertyKey, String>{};
      final resourceTypes = <DavPropertyKey>{};
      for (final propstat in response.findElements(
        'propstat',
        namespace: DavNs.dav,
      )) {
        final status = propstat
            .findElements('status', namespace: DavNs.dav)
            .firstOrNull
            ?.innerText;
        // Only collect successful properties (HTTP/1.1 200 OK).
        if (status == null || !status.contains(' 200 ')) {
          continue;
        }
        for (final prop in propstat.findElements(
          'prop',
          namespace: DavNs.dav,
        )) {
          for (final child in prop.childElements) {
            final key = DavPropertyKey(
              child.namespaceUri ?? '',
              child.localName,
            );
            if (child.localName == 'resourcetype') {
              for (final rt in child.childElements) {
                resourceTypes.add(
                  DavPropertyKey(rt.namespaceUri ?? '', rt.localName),
                );
              }
              continue;
            }
            if (child.localName == 'current-user-principal' ||
                child.localName == 'calendar-home-set' ||
                child.localName == 'addressbook-home-set') {
              final href = child
                  .findElements('href', namespace: DavNs.dav)
                  .firstOrNull
                  ?.innerText
                  .trim();
              if (href != null) {
                props[key] = href;
              }
              continue;
            }
            if (child.localName == 'supported-calendar-component-set') {
              final names = child.childElements
                  .map((e) => e.getAttribute('name') ?? e.localName)
                  .join(',');
              props[key] = names;
              continue;
            }
            // For everything else: collect inner text (handles displayname,
            // getetag, getctag, sync-token, calendar-color, calendar-order, …).
            props[key] = child.innerText;
          }
        }
      }
      resources.add(
        DavResource(
          href: href,
          properties: props,
          resourceTypes: resourceTypes,
        ),
      );
    }
    return Multistatus(resources);
  }

  final List<DavResource> resources;

  /// The top-level `<sync-token>` element of a sync-collection REPORT response.
  /// Distinct from the per-resource sync-token property (which doesn't appear
  /// in sync-collection responses anyway).
  static String? extractSyncToken(String xml) {
    final document = XmlDocument.parse(xml);
    final root = document.rootElement;
    final element = root
        .findElements('sync-token', namespace: DavNs.dav)
        .firstOrNull;
    return element?.innerText.trim();
  }
}
