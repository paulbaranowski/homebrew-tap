#!/usr/bin/env bash
# Point a formula in this tap at a released version by rewriting its `url` +
# `sha256` lines in place.
#
# Run AFTER you have pushed the formula's source tag (so GitHub's source tarball
# exists). This fetches that tarball, computes its sha256, and rewrites the
# formula.
#
# Each formula is built from a different source repo and tag scheme:
#   plan-keeper   wild-horses        tag plan-keeper-v<version>
#   crew-config   groundcrew-config  tag v<version>
#
# Usage: ./update-formula.sh <formula> <version>
#   ./update-formula.sh plan-keeper 5.9.2
#   ./update-formula.sh crew-config 1.0.0
set -euo pipefail

FORMULA_NAME="${1:?usage: ./update-formula.sh <formula: plan-keeper|crew-config> <version>}"
VERSION="${2:?usage: ./update-formula.sh <formula: plan-keeper|crew-config> <version>}"

case "$FORMULA_NAME" in
  plan-keeper)
    REPO="paulbaranowski/wild-horses"
    TAG="plan-keeper-v${VERSION}"
    ;;
  crew-config)
    REPO="paulbaranowski/groundcrew-config"
    TAG="v${VERSION}"
    ;;
  *)
    echo "unknown formula: ${FORMULA_NAME} (expected plan-keeper or crew-config)" >&2
    exit 1
    ;;
esac

URL="https://github.com/${REPO}/archive/refs/tags/${TAG}.tar.gz"
FORMULA="$(cd "$(dirname "$0")" && pwd)/Formula/${FORMULA_NAME}.rb"
[ -f "$FORMULA" ] || { echo "no such formula: ${FORMULA}" >&2; exit 1; }

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
echo "Next: git -C \"$(dirname "$FORMULA")/..\" commit -am '${FORMULA_NAME} ${VERSION}' && git push"
