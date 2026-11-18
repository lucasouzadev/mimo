#!/usr/bin/env bash
# Instala o app no simulador e captura cada tela.
# Uso: screenshots.sh <caminho/Mimo.app> <pasta de saída>
set -euo pipefail

APP="$1"
OUT="$2"
BUNDLE_ID="dev.lucasouza.mimo"
SCREENS=(profile wishes archive gallery)
mkdir -p "$OUT"

# Escolhe um iPhone (de preferência um Pro, não Max) no runtime mais novo de cada versão principal.
pick_device() {
  xcrun simctl list -j devices available | python3 -c '
import json, sys
major = sys.argv[1]
data = json.load(sys.stdin)["devices"]
runtimes = sorted(rt for rt in data if f".iOS-{major}-" in rt + "-")
for rt in reversed(runtimes):
    phones = [d for d in data[rt] if d["name"].startswith("iPhone")]
    preferred = [d for d in phones if "Pro" in d["name"] and "Max" not in d["name"]]
    for d in preferred or phones:
        print(d["udid"], d["name"], rt.split(".")[-1], sep="|")
        sys.exit(0)
' "$1"
}

for major in 26 18; do
  line=$(pick_device "$major" || true)
  if [ -z "$line" ]; then
    echo "::warning::Nenhum simulador iOS $major disponível neste runner; pulando."
    continue
  fi
  IFS='|' read -r UDID NAME RUNTIME <<< "$line"
  echo "::group::iOS $major — $NAME ($RUNTIME)"

  xcrun simctl boot "$UDID" || true
  xcrun simctl bootstatus "$UDID" -b
  xcrun simctl ui "$UDID" appearance light
  xcrun simctl status_bar "$UDID" override \
    --time "9:41" --batteryState charged --batteryLevel 100 \
    --cellularMode active --cellularBars 4 --wifiBars 3 || true
  xcrun simctl install "$UDID" "$APP"

  for screen in "${SCREENS[@]}"; do
    xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE_ID" \
      -screen "$screen" -AppleLanguages "(pt-BR)" -AppleLocale pt_BR
    sleep 8
    xcrun simctl io "$UDID" screenshot "$OUT/ios$major-$screen.png"
    echo "captured ios$major-$screen.png"
  done

  # Registros de travamento, se houver, para diagnóstico.
  cp ~/Library/Logs/DiagnosticReports/Mimo* "$OUT/" 2>/dev/null || true

  xcrun simctl shutdown "$UDID" || true
  echo "::endgroup::"
done

ls -la "$OUT"
