#!/bin/bash
set -euo pipefail

# Only run in remote (Claude Code on the web) environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

# Read Flutter version from .fvmrc
FVMRC_PATH="${CLAUDE_PROJECT_DIR}/.fvmrc"
if [ -f "$FVMRC_PATH" ]; then
  FLUTTER_VERSION=$(grep -o '"flutter": *"[^"]*"' "$FVMRC_PATH" | grep -o '"[^"]*"$' | tr -d '"')
else
  echo "Error: .fvmrc not found at $FVMRC_PATH"
  exit 1
fi

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

# ---- Dart MCP server check ----
DART_VERSION=$(dart --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
DART_MAJOR=$(echo "$DART_VERSION" | cut -d. -f1)
DART_MINOR=$(echo "$DART_VERSION" | cut -d. -f2)
if [ "$DART_MAJOR" -gt 3 ] || { [ "$DART_MAJOR" -eq 3 ] && [ "$DART_MINOR" -ge 9 ]; }; then
  echo "Dart ${DART_VERSION} supports MCP server."
else
  echo "Warning: Dart ${DART_VERSION} < 3.9 — 'dart mcp-server' may not be available."
fi

# ---- Node.js / npx (required for context7 MCP) ----
if command -v npx &>/dev/null; then
  echo "Node.js $(node --version) / npx found."
else
  echo "npx not found. Installing Node.js 22 via NodeSource..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - >/dev/null 2>&1
  apt-get install -y nodejs >/dev/null 2>&1
  if command -v npx &>/dev/null; then
    echo "Node.js $(node --version) installed successfully."
  else
    echo "Warning: Failed to install Node.js. context7 MCP server will not work."
  fi
fi

# ---- Install dependencies ----
echo "Running flutter pub get..."
cd "$CLAUDE_PROJECT_DIR"
flutter pub get

# ---- Code generation ----
echo "Running build_runner..."
dart run build_runner build --delete-conflicting-outputs

echo "Session start hook completed successfully."
