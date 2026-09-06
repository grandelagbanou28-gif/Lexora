#!/bin/bash
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$project_dir"

export FLUTTER_HOME="$HOME/flutter"
if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
  echo "Installing Flutter stable..."
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_HOME"
fi
export PATH="$FLUTTER_HOME/bin:$PATH"

flutter config --no-analytics
flutter pub get
sh tool/update_drift_web_assets.sh
flutter build web --wasm --release
cp build/web/index.html build/web/404.html