#!/bin/bash

# Directorio base (directorio actual donde está instalado Blesta)
BASE_DIR="../../"
BACKUP_DIR="$BASE_DIR/language/backup_$(date +%Y%m%d_%H%M%S)"

# Verifica si el directorio de idiomas existe en el sistema
if [ ! -d "$BASE_DIR/language/es_es" ]; then
    echo "Error: Directorio de idiomas no encontrado en la instalación de Blesta"
    exit 1
fi

# Crea backup de los archivos existentes
echo "Creando copia de seguridad..."
mkdir -p "$BACKUP_DIR"
cp -R "$BASE_DIR/language/es_es/"* "$BACKUP_DIR/"
echo "Backup creado en: $BACKUP_DIR"

# Copia los archivos de idioma nuevos
echo "Aplicando cambios de idioma..."
cp -R language/es_es/* "$BASE_DIR/language/es_es/"

# Limpia la caché si existe
if [ -d "$BASE_DIR/cache" ]; then
    echo "Limpiando caché..."
    rm -rf "$BASE_DIR/cache/"*
fi

echo "¡Cambios aplicados exitosamente!"
echo "Si necesitas revertir los cambios, los archivos originales están en: $BACKUP_DIR"