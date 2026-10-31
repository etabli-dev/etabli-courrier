# Licensing and distribution

Courrier application code is Apache-2.0. Dependencies retain their own licenses. The license gate is a project policy and inventory check; it does not certify acceptance by an app store or F-Droid.

## Dependency policy and reproducible checks

Run `flutter pub get --enforce-lockfile`, then `python3 tool/check_licenses.py`. The gate compares every resolved Dart/Flutter package version and license-file SHA-256 against `tool/license_manifest.json`. It fails on additions, missing notices, changed license bytes, unreviewed versions and licenses outside the allow-list. Review the actual source/license before changing that inventory; update `THIRD_PARTY_LICENSES.md` at the same time. The earlier unpinned very_good_cli command is superseded by this executable check.

The existing project allow-list is Apache-2.0, MIT, BSD-2-Clause, BSD-3-Clause, ISC, Zlib, Unlicense, CC0-1.0, MPL-2.0, EPL-2.0 and CDDL-1.x. Other licenses, including GPL/AGPL/LGPL and unlicensed code, remain outside this project's current dependency policy. This is a conservative distribution choice, not a claim that every such license is incompatible in every context.

`msal_auth` remains excluded by project policy; OAuth currently uses AppAuth. The earlier statement that Microsoft's native MSAL libraries are proprietary was incorrect: the official [Android](https://github.com/AzureAD/microsoft-authentication-library-for-android/blob/dev/LICENSE) and [Apple](https://github.com/AzureAD/microsoft-authentication-library-for-objc/blob/dev/LICENSE) repositories carry MIT licenses. This correction does not add MSAL or enable Microsoft 365. A future provider change requires review of the exact wrapper, native dependency graph, build reproducibility and distribution requirements.

## Notices, source and local modifications

- Retain `LICENSE`, `NOTICE`, `THIRD_PARTY_LICENSES.md` and `THIRD_PARTY_REFERENCES.md` with source distributions. The resolved license texts include package/version source links. The in-app Settings license page exposes Flutter's packaged dependency licenses.
- Resolved MPL-2.0 packages are `enough_mail`, `enough_convert` and desktop-only `dbus`. Preserve their covered source and notices and tell binary recipients how to obtain the corresponding version. Modified covered files retain MPL obligations. [MPL 2.0 section 3](https://www.mozilla.org/en-US/MPL/2.0/) requires source availability for distributed covered executables; merely noting a dependency name is insufficient.
- `third_party/flutter_local_notifications` contains published 22.3.3 source plus a small Android permission-handling patch. Its BSD-3-Clause license, archive checksum, changed behavior and replacement criteria are recorded in `UPSTREAM.md`. Dart analyzer exclusions cover this external dependency's unchanged Dart source; its Android patch has separate native tests and application/dependency lint. Do not modify the shared Pub cache.
- Keep abstract behavioral references separate from copied/adapted code. `THIRD_PARTY_REFERENCES.md` records the original project's provenance policy. DavMail is an external companion, never bundled. Any future copied or adapted code needs its actual license and attribution preserved.
- Contributions follow `CONTRIBUTING.md` (Apache-2.0 inbound terms and DCO). Third-party attribution is retained separately from application authorship.

## Before distributing a binary

The current inventory covers 140 resolved packages, including SDK/development/desktop packages. This is broader than the Android shipped Dart set, but does not enumerate every Maven, CocoaPods or system component. Review the final platform dependency notices and archive the corresponding source versions, including local patches, with the chosen release.

Run the pinned CI/license checks, inspect the actual packaged license page and source links on an installed build, review native notices and platform/store requirements, and retain the source/build instructions for that version. Microsoft 365 remains disabled pending project-owned registration and device validation. No F-Droid or store acceptance is established by a permissive application license or a passing inventory check.
