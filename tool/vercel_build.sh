#!/bin/bash
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_dir"

export FLUTTER_HOME="$HOME/flutter"
if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
  echo "Installing Flutter 3.47.2 (stable)..."
  mkdir -p "$FLUTTER_HOME"
  curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.2-stable.tar.xz" \
    -o /tmp/flutter.tar.xz
  tar -xJf /tmp/flutter.tar.xz -C /tmp
  mv /tmp/flutter/* "$FLUTTER_HOME/"
  rm -rf /tmp/flutter /tmp/flutter.tar.xz
fi
export PATH="$FLUTTER_HOME/bin:$PATH"

flutter config --no-analytics
flutter pub get
sh tool/update_drift_web_assets.sh
flutter build web --wasm --release
cp build/web/index.html build/web/404.html