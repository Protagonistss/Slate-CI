#!/usr/bin/env bash
# 本地验证 updater manifest 生成逻辑（含 macOS/Windows/Linux 三平台签名格式）
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p \
  "${TMP_DIR}/bundles/native/target/aarch64-apple-darwin/release/bundle/macos" \
  "${TMP_DIR}/bundles/native/target/release/bundle/nsis" \
  "${TMP_DIR}/bundles/native/target/release/bundle/appimage"

echo "dummy" > "${TMP_DIR}/bundles/native/target/aarch64-apple-darwin/release/bundle/macos/Slate.app.tar.gz"
echo "sig-aarch64" > "${TMP_DIR}/bundles/native/target/aarch64-apple-darwin/release/bundle/macos/Slate.app.tar.gz.sig"
echo "win-exe" > "${TMP_DIR}/bundles/native/target/release/bundle/nsis/Slate_0.0.17_x64-setup.exe"
echo "sig-windows" > "${TMP_DIR}/bundles/native/target/release/bundle/nsis/Slate_0.0.17_x64-setup.exe.sig"
echo "linux-appimage" > "${TMP_DIR}/bundles/native/target/release/bundle/appimage/Slate_0.0.17_amd64.AppImage"
echo "sig-linux" > "${TMP_DIR}/bundles/native/target/release/bundle/appimage/Slate_0.0.17_amd64.AppImage.sig"

VERSION=0.0.17 \
RELEASE_TAG=v0.0.17 \
BUNDLES_DIR="${TMP_DIR}/bundles" \
OUTPUT_DIR="${TMP_DIR}/release-assets" \
bash "${ROOT_DIR}/.github/scripts/prepare-release-assets.sh"

python3 - <<'PY' "${TMP_DIR}/release-assets/latest.json"
import json
import pathlib
import sys

manifest = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
assert manifest["version"] == "0.0.17"
assert "darwin-aarch64" in manifest["platforms"]
assert manifest["platforms"]["darwin-aarch64"]["signature"] == "sig-aarch64"
assert "windows-x86_64" in manifest["platforms"]
assert manifest["platforms"]["windows-x86_64"]["signature"] == "sig-windows"
assert manifest["platforms"]["windows-x86_64"]["url"].endswith("Slate-0.0.17-setup.exe")
assert "linux-x86_64" in manifest["platforms"]
assert manifest["platforms"]["linux-x86_64"]["signature"] == "sig-linux"
assert manifest["platforms"]["linux-x86_64"]["url"].endswith("Slate-0.0.17-x86_64.AppImage")
print("updater manifest smoke test passed")
PY
