#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
BASE_DIR=$(cd -- "$SCRIPT_DIR/../.." && pwd)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LANG_DIR="$BASE_DIR/language/es_es"
NEW_LANG_DIR="$SCRIPT_DIR/language/es_es"
LANG_BACKUP_DIR="$BASE_DIR/language/backup_$TIMESTAMP"
COMPONENTS_DIR="$BASE_DIR/components"
NEW_COMPONENTS_DIR="$SCRIPT_DIR/components"
COMPONENTS_BACKUP_DIR="$BASE_DIR/components/backup_$TIMESTAMP"
APP_DIR="$BASE_DIR/app"
NEW_APP_DIR="$SCRIPT_DIR/app"
APP_BACKUP_DIR="$BASE_DIR/app/backup_$TIMESTAMP"
CACHE_DIR="$BASE_DIR/cache"

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

if [[ ! -d "$COMPONENTS_DIR" ]]; then
    echo "Error: Directorio de componentes no encontrado en '$COMPONENTS_DIR'" >&2
    exit 1
fi

if [[ ! -d "$NEW_COMPONENTS_DIR" ]]; then
    echo "Error: Directorio de nuevos componentes no encontrado en '$NEW_COMPONENTS_DIR'" >&2
    exit 1
fi

if [[ ! -d "$APP_DIR" ]]; then
    echo "Error: Directorio de app no encontrado en '$APP_DIR'" >&2
    exit 1
fi

if [[ ! -d "$NEW_APP_DIR" ]]; then
    echo "Error: Directorio de nueva app no encontrado en '$NEW_APP_DIR'" >&2
    exit 1
fi

echo "Base de instalación: $BASE_DIR"
echo "Creando copia de seguridad de idiomas en '$LANG_BACKUP_DIR'..."
mkdir -p "$LANG_BACKUP_DIR"
cp -a "$LANG_DIR/." "$LANG_BACKUP_DIR/"
echo "Backup de idiomas creado."

echo "Aplicando cambios de idioma..."
cp -a "$NEW_LANG_DIR/." "$LANG_DIR/"
echo "Archivos de idioma actualizados."

echo "Creando copia de seguridad de componentes en '$COMPONENTS_BACKUP_DIR'..."
mkdir -p "$COMPONENTS_BACKUP_DIR"
cp -a "$COMPONENTS_DIR/." "$COMPONENTS_BACKUP_DIR/"
echo "Backup de componentes creado."

echo "Actualizando componentes..."
cp -a "$NEW_COMPONENTS_DIR/." "$COMPONENTS_DIR/"
echo "Componentes actualizados."

echo "Creando copia de seguridad de app en '$APP_BACKUP_DIR'..."
mkdir -p "$APP_BACKUP_DIR"
cp -a "$APP_DIR/." "$APP_BACKUP_DIR/"
echo "Backup de app creado."

echo "Actualizando app..."
cp -a "$NEW_APP_DIR/." "$APP_DIR/"
echo "App actualizada."

if [[ -d "$CACHE_DIR" ]]; then
    echo "Limpiando caché en '$CACHE_DIR'..."
    find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    echo "Caché limpia."
else
    echo "Directorio de caché no encontrado; se omite la limpieza."
fi

echo "¡Cambios aplicados exitosamente!"
echo "Si necesitas revertir los cambios, revisa los respaldos en: $LANG_BACKUP_DIR, $COMPONENTS_BACKUP_DIR, $APP_BACKUP_DIR"
