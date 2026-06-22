#!/usr/bin/env bash
# 本地验证 updater manifest 生成逻辑
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "${TMP_DIR}/bundles/native/target/aarch64-apple-darwin/release/bundle/macos"

echo "dummy" > "${TMP_DIR}/bundles/native/target/aarch64-apple-darwin/release/bundle/macos/Slate.app.tar.gz"
echo "sig-aarch64" > "${TMP_DIR}/bundles/native/target/aarch64-apple-darwin/release/bundle/macos/Slate.app.tar.gz.sig"

VERSION=0.0.11 \
RELEASE_TAG=v0.0.11 \
BUNDLES_DIR="${TMP_DIR}/bundles" \
OUTPUT_DIR="${TMP_DIR}/release-assets" \
bash "${ROOT_DIR}/.github/scripts/prepare-release-assets.sh"

python3 - <<'PY' "${TMP_DIR}/release-assets/latest.json"
import json
import pathlib
import sys

manifest = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
assert manifest["version"] == "0.0.11"
assert "darwin-aarch64" in manifest["platforms"]
assert manifest["platforms"]["darwin-aarch64"]["signature"] == "sig-aarch64"
print("updater manifest smoke test passed")
PY
