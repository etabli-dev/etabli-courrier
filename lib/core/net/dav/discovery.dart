import 'package:meta/meta.dart';

import 'dav_client.dart';
import 'multistatus.dart';
import 'requests.dart';

// DAV discovery — follow the chain that every CalDAV/CardDAV server agrees on:
//
//   1. Caller passes a base URL (e.g. https://cloud.example.org).
//   2. We hit `<base>/.well-known/caldav` (or carddav) — the server should
//      308/301 redirect to the actual DAV root. `http` follows redirects by
//      default, so PROPFIND lands on the right host.
//   3. PROPFIND the current-user-principal to get the principal URL.
//   4. PROPFIND the principal for calendar-home-set and addressbook-home-set.
//   5. PROPFIND Depth:1 on each home to enumerate collections.

@immutable
class DavDiscoveryResult {
  const DavDiscoveryResult({
    required this.principalHref,
    required this.calendarHomeHref,
    required this.addressbookHomeHref,
    required this.calendarCollections,
    required this.addressbookCollections,
  });

  final String? principalHref;
  final String? calendarHomeHref;
  final String? addressbookHomeHref;
  final List<DavResource> calendarCollections;
  final List<DavResource> addressbookCollections;
}

class DavDiscovery {
  DavDiscovery({required this.client, required this.baseUrl});

  final DavClient client;
  final Uri baseUrl;

  Future<DavDiscoveryResult> discover() async {
    final principalHref = await _discoverPrincipal();
    String? calendarHome;
    String? addressbookHome;
    if (principalHref != null) {
      final homes = await _discoverHomes(_resolve(principalHref));
      calendarHome = homes.calendarHome;
      addressbookHome = homes.addressbookHome;
    }
    final calendars = calendarHome == null
        ? <DavResource>[]
        : await _enumerate(_resolve(calendarHome));
    final addressbooks = addressbookHome == null
        ? <DavResource>[]
        : await _enumerate(_resolve(addressbookHome));
    return DavDiscoveryResult(
      principalHref: principalHref,
      calendarHomeHref: calendarHome,
      addressbookHomeHref: addressbookHome,
      calendarCollections: calendars
          .where((r) => r.isCalendar)
          .toList(growable: false),
      addressbookCollections: addressbooks
          .where((r) => r.isAddressbook)
          .toList(growable: false),
    );
  }

  Future<String?> _discoverPrincipal() async {
    final candidate = _resolve('/.well-known/caldav');
    final multistatus = await client.propfind(
      url: candidate,
      body: DavRequests.currentUserPrincipal,
    );
    if (multistatus.resources.isEmpty) {
      return null;
    }
    return multistatus.resources.first.currentUserPrincipal;
  }

  Future<_HomeSets> _discoverHomes(Uri principalUrl) async {
    final multistatus = await client.propfind(
      url: principalUrl,
      body: DavRequests.homeSets,
    );
    if (multistatus.resources.isEmpty) {
      return const _HomeSets();
    }
    final resource = multistatus.resources.first;
    return _HomeSets(
      calendarHome: resource.calendarHomeSet,
      addressbookHome: resource.addressbookHomeSet,
    );
  }

  Future<List<DavResource>> _enumerate(Uri homeUrl) async {
    final multistatus = await client.propfind(
      url: homeUrl,
      body: DavRequests.enumerateCollections,
      depth: '1',
    );
    return multistatus.resources;
  }

  Uri _resolve(String hrefOrPath) {
    if (hrefOrPath.startsWith('http')) {
      return Uri.parse(hrefOrPath);
    }
    return baseUrl.resolve(hrefOrPath);
  }
}

@immutable
class _HomeSets {
  const _HomeSets({this.calendarHome, this.addressbookHome});

  final String? calendarHome;
  final String? addressbookHome;
}
