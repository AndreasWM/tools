#!/bin/bash

SCAN_DIR="$HOME/scan"

# Schleife von 1 bis 99
for i in {1..99}; do
    # Zweistellige Nummer mit führender Null formatieren (01, 02, ..., 99)
    num=$(printf "%02d" $i)
    filename="${SCAN_DIR}/dokument${num}.pdf"
    
    # Prüfen, ob die Datei noch NICHT existiert
    if [ ! -e "$filename" ]; then
        echo "Starte Skript mit: $filename"
        $HOME/prod/tools/sh/scan.sh "$filename"
        exit 0
    fi
done

echo "Fehler: Es sind bereits alle Dateinamen von dokument01.pdf bis dokument99.pdf vergeben." >&2
exit 1