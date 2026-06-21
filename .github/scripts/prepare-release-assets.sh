#!/usr/bin/env bash
# 从构建 artifact 中提取并重命名各平台发布文件
set -euo pipefail

: "${VERSION:?VERSION is required}"

BUNDLES_DIR="${BUNDLES_DIR:-bundles}"
OUTPUT_DIR="${OUTPUT_DIR:-release-assets}"

mkdir -p "$OUTPUT_DIR"

# macOS DMG（Intel + Apple Silicon 分架构发布）
while IFS= read -r -d '' f; do
  case "$f" in
    *aarch64*|*arm64*)
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-aarch64.dmg"
      ;;
    *x64*|*x86_64*)
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-x64.dmg"
      ;;
    *)
      echo "Skip unrecognized macOS dmg: $f"
      ;;
  esac
done < <(find "$BUNDLES_DIR" -type f -iname '*.dmg' -print0)

# Windows NSIS installer
find "$BUNDLES_DIR" -type f -path '*/nsis/*' -iname '*.exe' -print0 \
  | while IFS= read -r -d '' f; do
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-setup.exe"
    done

# Linux .deb
find "$BUNDLES_DIR" -type f -iname '*.deb' -print0 \
  | while IFS= read -r -d '' f; do
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-amd64.deb"
    done

# Linux AppImage
find "$BUNDLES_DIR" -type f -iname '*.AppImage' -print0 \
  | while IFS= read -r -d '' f; do
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-x86_64.AppImage"
    done

echo "Release assets:"
ls -la "$OUTPUT_DIR/"
if [ -z "$(ls -A "$OUTPUT_DIR")" ]; then
  echo "No release assets found in artifacts"
  exit 1
fi
