#!/usr/bin/env bash
# Point Formula/plan-keeper.rb at a released version of wild-horses.
#
# Run AFTER you have pushed the `plan-keeper-v<version>` tag to the wild-horses
# repo (so GitHub's source tarball exists). This fetches that tarball, computes
# its sha256, and rewrites the formula's `url` + `sha256` lines in place.
#
# Usage: ./update-formula.sh 0.1.0
set -euo pipefail

VERSION="${1:?usage: ./update-formula.sh <version, e.g. 0.1.0>}"
TAG="plan-keeper-v${VERSION}"
URL="https://github.com/paulbaranowski/wild-horses/archive/refs/tags/${TAG}.tar.gz"
FORMULA="$(cd "$(dirname "$0")" && pwd)/Formula/plan-keeper.rb"

echo "Fetching ${URL}"
SHA="$(curl -fsSL "$URL" | shasum -a 256 | awk '{print $1}')"
[ -n "$SHA" ] || { echo "failed to compute sha256 (tag pushed yet?)" >&2; exit 1; }
echo "sha256 = ${SHA}"

# BSD sed (macOS) in-place edit.
sed -i '' -E \
  -e "s|^(  url ).*|\1\"${URL}\"|" \
  -e "s|^(  sha256 ).*|\1\"${SHA}\"|" \
  "$FORMULA"

echo "Updated ${FORMULA}"
echo "Next: git -C \"$(dirname "$FORMULA")/..\" commit -am 'plan-keeper ${VERSION}' && git push"
