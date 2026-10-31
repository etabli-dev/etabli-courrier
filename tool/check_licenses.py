#!/usr/bin/env python3
"""Verify reviewed license bytes for the exact resolved Dart/Flutter packages."""
import hashlib
import json
from pathlib import Path
import re
import sys
from urllib.parse import urljoin, urlparse

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {'Apache-2.0', 'MIT', 'BSD-2-Clause', 'BSD-3-Clause', 'ISC', 'Zlib', 'Unlicense', 'CC0-1.0', 'MPL-2.0', 'EPL-2.0', 'CDDL-1.0', 'CDDL-1.1'}


def inventory():
    config = ROOT / '.dart_tool/package_config.json'
    result = {}
    for package in json.loads(config.read_text())['packages']:
        if package['name'] == 'courrier':
            continue
        root = Path(urlparse(urljoin(config.as_uri(), package['rootUri'])).path)
        choices = [root / name for name in ('LICENSE', 'LICENSE.md', 'LICENSE.txt', 'COPYING')]
        license_path = next((p for p in choices if p.is_file()), None)
        if license_path is None and root.parent.name == 'packages' and (root.parent.parent / 'LICENSE').is_file():
            license_path = root.parent.parent / 'LICENSE'
        if license_path is None:
            raise ValueError(f"Missing license: {package['name']}")
        version = re.search(r'^version:\s*[\'\"]?([^\s\'\"]+)', (root / 'pubspec.yaml').read_text(), re.M)
        result[package['name']] = {
            'version': version.group(1) if version else 'sdk',
            'sha256': hashlib.sha256(license_path.read_bytes()).hexdigest(),
            'text': license_path.read_text(),
        }
    return result


def main():
    expected = json.loads((ROOT / 'tool/license_manifest.json').read_text())['packages']
    actual = inventory()
    if actual.keys() != expected.keys():
        raise ValueError(f'Unreviewed dependency set: added={actual.keys()-expected.keys()}, removed={expected.keys()-actual.keys()}')
    for name, data in actual.items():
        review = expected[name]
        if name == 'msal_auth' or review['license'] not in ALLOWED:
            raise ValueError(f'Forbidden license/package: {name}')
        for key in ('version', 'sha256'):
            if data[key] != review[key]:
                raise ValueError(f'{name}: {key} changed; review source/license and update the manifest explicitly')
    for name in ('NOTICE', 'LICENSE', 'THIRD_PARTY_REFERENCES.md', 'THIRD_PARTY_LICENSES.md'):
        if not (ROOT / name).is_file():
            raise ValueError(f'Missing distribution notice: {name}')
    print(f'License gate passed for {len(actual)} resolved packages (including SDK and development tools).')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, KeyError, OSError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
