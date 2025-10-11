#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
BASE_DIR=$(cd -- "$SCRIPT_DIR/../.." && pwd)
LANG_DIR="$BASE_DIR/language/es_es"
NEW_LANG_DIR="$SCRIPT_DIR/language/es_es"
CACHE_DIR="$BASE_DIR/cache"
BACKUP_DIR="$BASE_DIR/language/backup_$(date +%Y%m%d_%H%M%S)"

if [[ ! -f "$BASE_DIR/config/blesta.php" ]]; then
    echo "Error: No se detecta una instalación de Blesta en '$BASE_DIR'" >&2
    exit 1
fi

if [[ ! -d "$LANG_DIR" ]]; then
    echo "Error: Directorio de idiomas no encontrado en '$LANG_DIR'" >&2
    exit 1
fi

if [[ ! -d "$NEW_LANG_DIR" ]]; then
    echo "Error: Directorio de nuevos archivos de idioma no encontrado en '$NEW_LANG_DIR'" >&2
    exit 1
fi

echo "Base de instalación: $BASE_DIR"
echo "Creando copia de seguridad en '$BACKUP_DIR'..."
mkdir -p "$BACKUP_DIR"
cp -a "$LANG_DIR/." "$BACKUP_DIR/"
echo "Backup creado."

echo "Aplicando cambios de idioma..."
cp -a "$NEW_LANG_DIR/." "$LANG_DIR/"
echo "Archivos de idioma actualizados."

if [[ -d "$CACHE_DIR" ]]; then
    echo "Limpiando caché en '$CACHE_DIR'..."
    find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    echo "Caché limpia."
else
    echo "Directorio de caché no encontrado; se omite la limpieza."
fi

echo "¡Cambios aplicados exitosamente!"
echo "Si necesitas revertir los cambios, los archivos originales están en: $BACKUP_DIR"
