#!/usr/bin/env bash
set -euo pipefail

# Este script siempre vive en BASE_DIR/nuevos-idiomas
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
BASE_DIR=$(cd -- "$SCRIPT_DIR/.." && pwd)
REPO_URL="https://github.com/aladuuu/clientes.blackbelt.cl.git"
STAGE="$SCRIPT_DIR/.origen"

# Validaciones mínimas
[[ -f "$BASE_DIR/config/blesta.php" ]] || { echo "Error: BASE_DIR no parece una instalación de Blesta ($BASE_DIR)." >&2; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Error: git no está instalado." >&2; exit 1; }

# Clonar repo espejo dentro de 'nuevos-idiomas' (subcarpeta oculta)
rm -rf "$STAGE"
git clone --depth 1 "$REPO_URL" "$STAGE"

# Prechequeo: NO crear directorios nuevos; si falta alguno, abortar
while IFS= read -r -d '' src; do
  rel="${src#"$STAGE/"}"
  dest_dir="$(dirname -- "$BASE_DIR/$rel")"
  if [[ ! -d "$dest_dir" ]]; then
    echo "Cambio en la estructura, revisa archivos." >&2
    exit 1
  fi
done < <(find "$STAGE" -type f -not -path '*/.git/*' -print0)

# Copiar UNO A UNO, sobrescribiendo si existe; crear el archivo si no existe (sin crear directorios)
while IFS= read -r -d '' src; do
  rel="${src#"$STAGE/"}"
  dest="$BASE_DIR/$rel"
  cp -p "$src" "$dest"
done < <(find "$STAGE" -type f -not -path '*/.git/*' -print0)

echo "Aplicación completada desde '$STAGE' a '$BASE_DIR'."