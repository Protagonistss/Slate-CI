#!/usr/bin/env bash
# 从构建 artifact 中提取并重命名各平台发布文件与 updater 包
set -euo pipefail

: "${VERSION:?VERSION is required}"

BUNDLES_DIR="${BUNDLES_DIR:-bundles}"
OUTPUT_DIR="${OUTPUT_DIR:-release-assets}"
RELEASE_TAG="${RELEASE_TAG:-v${VERSION}}"
RELEASE_REPO="${RELEASE_REPO:-Protagonistss/Slate-CI}"
RELEASE_BASE_URL="https://github.com/${RELEASE_REPO}/releases/download/${RELEASE_TAG}"

mkdir -p "$OUTPUT_DIR"

copy_updater_artifact() {
  local source="$1"
  local target_name="$2"
  cp "$source" "${OUTPUT_DIR}/${target_name}"
}

read_signature() {
  local sig_file="$1"
  tr -d '\n' < "$sig_file"
}

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

# macOS updater 包
while IFS= read -r -d '' archive; do
  case "$archive" in
    *aarch64*|*arm64*)
      target_name="Slate-${VERSION}-update-darwin-aarch64.tar.gz"
      ;;
    *x86_64*|*x64*)
      target_name="Slate-${VERSION}-update-darwin-x86_64.tar.gz"
      ;;
    *)
      echo "Skip unrecognized macOS updater archive: $archive"
      continue
      ;;
  esac

  copy_updater_artifact "$archive" "$target_name"
  sig_file="${archive}.sig"
  if [ -f "$sig_file" ]; then
    copy_updater_artifact "$sig_file" "${target_name}.sig"
  fi
done < <(find "$BUNDLES_DIR" -type f \( -iname '*.app.tar.gz' -o -iname '*.tar.gz' \) ! -iname '*.sig' -print0)

# Windows NSIS installer
find "$BUNDLES_DIR" -type f -path '*/nsis/*' -iname '*.exe' -print0 \
  | while IFS= read -r -d '' f; do
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-setup.exe"
    done

# Windows updater 包
find "$BUNDLES_DIR" -type f -path '*/nsis/*' -iname '*.nsis.zip' ! -iname '*.sig' -print0 \
  | while IFS= read -r -d '' archive; do
      target_name="Slate-${VERSION}-update-windows-x86_64.nsis.zip"
      copy_updater_artifact "$archive" "$target_name"
      sig_file="${archive}.sig"
      if [ -f "$sig_file" ]; then
        copy_updater_artifact "$sig_file" "${target_name}.sig"
      fi
    done

# Linux .deb
find "$BUNDLES_DIR" -type f -iname '*.deb' -print0 \
  | while IFS= read -r -d '' f; do
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-amd64.deb"
    done

# Linux AppImage
find "$BUNDLES_DIR" -type f -iname '*.AppImage' ! -iname '*.tar.gz' -print0 \
  | while IFS= read -r -d '' f; do
      cp "$f" "${OUTPUT_DIR}/Slate-${VERSION}-x86_64.AppImage"
    done

# Linux AppImage updater 包
find "$BUNDLES_DIR" -type f -iname '*.AppImage.tar.gz' ! -iname '*.sig' -print0 \
  | while IFS= read -r -d '' archive; do
      target_name="Slate-${VERSION}-update-linux-x86_64.AppImage.tar.gz"
      copy_updater_artifact "$archive" "$target_name"
      sig_file="${archive}.sig"
      if [ -f "$sig_file" ]; then
        copy_updater_artifact "$sig_file" "${target_name}.sig"
      fi
    done

echo "Release assets:"
ls -la "$OUTPUT_DIR/"
if [ -z "$(ls -A "$OUTPUT_DIR")" ]; then
  echo "No release assets found in artifacts"
  exit 1
fi

# 生成 Tauri updater manifest
MANIFEST_PATH="${OUTPUT_DIR}/latest.json"
NOTES="${RELEASE_NOTES:-Slate ${VERSION}}"
PUB_DATE="${RELEASE_PUB_DATE:-$(date -u +"%Y-%m-%dT%H:%M:%SZ")}"

python3 - "$MANIFEST_PATH" "$VERSION" "$NOTES" "$PUB_DATE" "$RELEASE_BASE_URL" "$OUTPUT_DIR" <<'PY'
import json
import pathlib
import sys

manifest_path, version, notes, pub_date, release_base_url, output_dir = sys.argv[1:7]
output = pathlib.Path(output_dir)
platforms = {}

mapping = {
    "Slate-{}-update-darwin-aarch64.tar.gz": "darwin-aarch64",
    "Slate-{}-update-darwin-x86_64.tar.gz": "darwin-x86_64",
    "Slate-{}-update-windows-x86_64.nsis.zip": "windows-x86_64",
    "Slate-{}-update-linux-x86_64.AppImage.tar.gz": "linux-x86_64",
}

for pattern, platform in mapping.items():
    archive_name = pattern.format(version)
    archive_path = output / archive_name
    sig_path = pathlib.Path(str(archive_path) + ".sig")
    if not archive_path.exists() or not sig_path.exists():
        continue
    platforms[platform] = {
        "url": f"{release_base_url}/{archive_name}",
        "signature": sig_path.read_text(encoding="utf-8").strip(),
    }

if not platforms:
    print("No updater artifacts found; skip latest.json generation")
    sys.exit(0)

payload = {
    "version": version,
    "notes": notes,
    "pub_date": pub_date,
    "platforms": platforms,
}
manifest_path_obj = pathlib.Path(manifest_path)
manifest_path_obj.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
print(f"Generated updater manifest: {manifest_path_obj}")
PY
