#!/bin/bash

# Automatisch die aktuelle Bus-ID des Canon LiDE 210 (VID:PID 04a9:190a) ermitteln und an WSL koppeln
BUSID=$(powershell.exe -Command "usbipd list" 2>/dev/null | grep "04a9:190a" | awk '{print $1}')

if [ -n "$BUSID" ]; then
    powershell.exe -Command "usbipd attach --wsl --busid $BUSID" >/dev/null 2>&1
fi

# Name der Ausgabedatei (Standard: dokument.pdf oder als Parameter übergeben)
OUTPUT_PDF="${1:-dokument.pdf}"
TMP_DIR=$(mktemp -d)
PAGE=1
PAGES_SCANNED=0

echo "=== Mehrseiten-Scan gestartet ==="
echo "Ergebnis wird gespeichert als: $OUTPUT_PDF"
echo ""

while true; do
  echo "----------------------------------------"
  echo "Lege Seite $PAGE auf den Scanner."
  read -p "Drücke [ENTER] zum Scannen (oder 'n' zum Beenden): " input

  # Wenn der Benutzer 'n' oder 'N' eingibt, Schleife abbrechen
  if [[ "$input" =~ ^[nN]$ ]]; then
    break
  fi

  TMP_FILE="$TMP_DIR/page_$(printf "%03d" $PAGE).png"
  echo "Scanne Seite $PAGE..."

  # Scan-Befehl ausführen
  scanimage --mode Gray --resolution 300 -x 210 -y 297 --format=png > "$TMP_FILE"

  if [ $? -eq 0 ]; then
    echo "Seite $PAGE erfolgreich gescannt."
    PAGE=$((PAGE + 1))
    PAGES_SCANNED=$((PAGES_SCANNED + 1))
  else
    echo "Fehler beim Scannen von Seite $PAGE! Bitte erneut versuchen."
    rm -f "$TMP_FILE"
  fi
  echo ""
done

# Wenn mindestens eine Seite gescannt wurde, PDF erstellen
if [ $PAGES_SCANNED -gt 0 ]; then
  echo ""
  echo "Erstelle PDF aus $PAGES_SCANNED Seite(n)..."
  img2pdf "$TMP_DIR"/page_*.png -o "$OUTPUT_PDF"
  
  if [ $? -eq 0 ]; then
    echo "Fertig! Datei gespeichert unter: $OUTPUT_PDF"
  else
    echo "Fehler beim Erstellen der PDF-Datei."
  fi
else
  echo "Keine Seiten gescannt. Vorgang abgebrochen."
fi

# Temporäre Dateien aufräumen
rm -rf "$TMP_DIR"