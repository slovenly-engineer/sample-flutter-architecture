#!/bin/bash
set -euo pipefail

# Only run in remote (Claude Code on the web) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

FLUTTER_VERSION="3.27.4"
FLUTTER_DIR="/opt/flutter"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"

# ---- Flutter SDK Installation ----
if [ -x "${FLUTTER_DIR}/bin/flutter" ]; then
  echo "Flutter SDK already installed, skipping download."
else
  echo "Installing Flutter ${FLUTTER_VERSION}..."
  curl -sS -o /tmp/flutter_linux.tar.xz "${FLUTTER_URL}"
  tar xf /tmp/flutter_linux.tar.xz -C /opt/
  rm -f /tmp/flutter_linux.tar.xz
  echo "Flutter SDK installed."
fi

# ---- Git safe.directory ----
git config --global --add safe.directory "${FLUTTER_DIR}" 2>/dev/null || true

# ---- Export PATH via CLAUDE_ENV_FILE ----
echo "export PATH=\"${FLUTTER_DIR}/bin:${FLUTTER_DIR}/bin/cache/dart-sdk/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"

export PATH="${FLUTTER_DIR}/bin:${FLUTTER_DIR}/bin/cache/dart-sdk/bin:${PATH}"

# ---- Install dependencies ----
echo "Running flutter pub get..."
cd "$CLAUDE_PROJECT_DIR"
flutter pub get

# ---- Code generation ----
echo "Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "Session start hook completed successfully."
