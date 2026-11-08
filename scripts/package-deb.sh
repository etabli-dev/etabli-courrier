#!/usr/bin/env bash
# Packages the Linux release bundle as a Debian package for Ubuntu/Debian (amd64).
#
#   flutter build linux --release
#   scripts/package-deb.sh        # -> build/deb/etabli-courrier_<version>_amd64.deb
#
# Layout: bundle in /opt/etabli-courrier, launcher /usr/bin/etabli-courrier,
# desktop entry and hicolor icons named after the application ID
# dev.etabli.courrier, license and notices in /usr/share/doc/etabli-courrier.
# The version is taken from pubspec.yaml (build number dropped) unless VERSION
# is set. Runtime library dependencies are computed with dpkg-shlibdeps.
# Requires dpkg-deb and dpkg-shlibdeps (package dpkg-dev).
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
bundle="$root/build/linux/x64/release/bundle"
pkg=etabli-courrier
app_id=dev.etabli.courrier
arch=amd64
maintainer=${MAINTAINER:-'R. Heller <58561665+r-heller@users.noreply.github.com>'}
version=${VERSION:-$(sed -n 's/^version:[[:space:]]*\([0-9][0-9.]*\).*/\1/p' "$root/pubspec.yaml")}

if [[ ! -x "$bundle/courrier" ]]; then
  echo "Missing $bundle/courrier; run 'flutter build linux --release' first." >&2
  exit 1
fi
if [[ -z "$version" ]]; then
  echo 'Could not read the version from pubspec.yaml.' >&2
  exit 1
fi

out="$root/build/deb"
stage="$out/${pkg}_${version}_${arch}"
deb="$out/${pkg}_${version}_${arch}.deb"
rm -rf "$stage" "$deb"
mkdir -p "$stage/DEBIAN" "$stage/opt" "$stage/usr/bin" \
  "$stage/usr/share/applications" \
  "$stage/usr/share/icons/hicolor/512x512/apps" \
  "$stage/usr/share/icons/hicolor/scalable/apps" \
  "$stage/usr/share/doc/$pkg"

cp -a "$bundle" "$stage/opt/$pkg"
# The transitive `jni` plugin (used only by Android implementations) is built
# whenever a JDK is present and links libjvm.so; nothing loads it on Linux.
rm -f "$stage/opt/$pkg/lib/libdartjni.so"
ln -s "/opt/$pkg/courrier" "$stage/usr/bin/$pkg"
install -m 0644 "$root/linux/packaging/$app_id.desktop" "$stage/usr/share/applications/$app_id.desktop"
install -m 0644 "$root/linux/packaging/$app_id.png" "$stage/usr/share/icons/hicolor/512x512/apps/$app_id.png"
install -m 0644 "$root/docs/_icons/icon-courrier.svg" "$stage/usr/share/icons/hicolor/scalable/apps/$app_id.svg"

doc="$stage/usr/share/doc/$pkg"
{
  printf 'Établi Courrier\nCopyright 2026 R. Heller\nLicense: Apache-2.0\n'
  printf 'Source: https://github.com/etabli-dev/etabli-courrier\n\n'
  printf 'Dependencies keep their own licenses; see NOTICE and THIRD_PARTY_LICENSES.md.gz\n'
  printf 'in this directory. MPL-2.0 source is available from the package links listed there.\n\n'
  cat "$root/LICENSE"
} > "$doc/copyright"
install -m 0644 "$root/NOTICE" "$doc/NOTICE"
gzip -9n -c "$root/THIRD_PARTY_LICENSES.md" > "$doc/THIRD_PARTY_LICENSES.md.gz"

# Normalise permissions independent of the caller's umask.
find "$stage" -type d -exec chmod 0755 {} +
find "$stage" -type f -exec chmod 0644 {} +
chmod 0755 "$stage/opt/$pkg/courrier"

# Shared-library dependencies of every ELF file in the bundle.
shlib_dir=$(mktemp -d)
trap 'rm -rf "$shlib_dir"' EXIT
mkdir -p "$shlib_dir/debian"
printf 'Source: %s\n\nPackage: %s\nArchitecture: %s\n' "$pkg" "$pkg" "$arch" > "$shlib_dir/debian/control"
mapfile -t elves < <(find "$stage/opt/$pkg" -type f \( -name courrier -o -name '*.so' \))
depends=$(cd "$shlib_dir" && dpkg-shlibdeps -O --ignore-missing-info \
  -l"$stage/opt/$pkg/lib" "${elves[@]}" 2>/dev/null | sed -n 's/^shlibs:Depends=//p')
if [[ -z "$depends" ]]; then
  echo 'dpkg-shlibdeps returned no dependencies.' >&2
  exit 1
fi

installed_size=$(du -sk --exclude=DEBIAN "$stage" | cut -f1)
cat > "$stage/DEBIAN/control" <<EOF
Package: $pkg
Version: $version
Architecture: $arch
Maintainer: $maintainer
Installed-Size: $installed_size
Depends: $depends
Recommends: gnome-keyring
Section: mail
Priority: optional
Homepage: https://github.com/etabli-dev/etabli-courrier
Description: Offline communication workspace (Établi Suite)
 Mail (IMAP), calendar and contacts (Nextcloud DAV), tasks, reminders, notes
 and feeds with explicit, manual synchronisation and an offline local store.
 .
 Account passwords are kept in the desktop keyring through the Secret Service
 API (GNOME Keyring or another provider). App lock and reminder notifications
 are not available in the Linux build yet.
EOF
(cd "$stage" && find . -type f ! -path './DEBIAN/*' -printf '%P\0' | sort -z | xargs -0 md5sum) > "$stage/DEBIAN/md5sums"
chmod 0644 "$stage/DEBIAN/control" "$stage/DEBIAN/md5sums"

dpkg-deb --build --root-owner-group -Zxz "$stage" "$deb" >/dev/null
rm -rf "$stage"
echo "$deb"
