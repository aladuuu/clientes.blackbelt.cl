#!/usr/bin/env bash
set -euo pipefail
umask 022

# Defaults
LANG_CODE="es_es"
CONFIRM_YES=0
DRY_RUN=0
NO_CACHE=0
VERBOSE=0
ROLLBACK_DIR=""
BASE_DIR=""

usage() {
  cat <<'EOF'
Uso: update_blesta_lang.sh [opciones]

Opciones:
  --lang CODE         Código de idioma (por defecto: es_es)
  --base DIR          Directorio base de Blesta (por defecto: script/../..)
  --yes, -y           No pedir confirmación
  --dry-run           Mostrar qué haría sin aplicar cambios
  --no-cache          No limpiar la caché
  --rollback DIR      Restaurar desde un backup existente (no aplica nuevos archivos)
  --verbose, -v       Salida detallada
  -h, --help          Mostrar esta ayuda

Ejemplos:
  ./update_blesta_lang.sh --lang es_es --yes
  ./update_blesta_lang.sh --dry-run
  ./update_blesta_lang.sh --rollback /ruta/a/language/backup_es_es_20240101_120000
EOF
}

log() { echo "[$(date '+%F %T')] $*"; }
vecho() { [ "${VERBOSE:-0}" -eq 1 ] && log "$@"; }
error() { echo "Error: $*" >&2; exit 1; }

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --lang=*) LANG_CODE="${1#*=}";;
    --lang) shift; [[ $# -gt 0 ]] || { echo "Falta valor para --lang" >&2; usage; exit 2; }; LANG_CODE="$1";;
    --base=*) BASE_DIR="${1#*=}";;
    --base) shift; [[ $# -gt 0 ]] || { echo "Falta valor para --base" >&2; usage; exit 2; }; BASE_DIR="$1";;
    --yes|-y) CONFIRM_YES=1;;
    --dry-run) DRY_RUN=1;;
    --no-cache) NO_CACHE=1;;
    --rollback=*) ROLLBACK_DIR="${1#*=}";;
    --rollback) shift; [[ $# -gt 0 ]] || { echo "Falta valor para --rollback" >&2; usage; exit 2; }; ROLLBACK_DIR="$1";;
    --verbose|-v) VERBOSE=1;;
    -h|--help) usage; exit 0;;
    *) echo "Opción no reconocida: $1" >&2; usage; exit 2;;
  esac
  shift
done

# Resolve paths
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if [[ -z "${BASE_DIR}" ]]; then
  BASE_DIR=$(cd -- "$SCRIPT_DIR/../.." && pwd)
else
  BASE_DIR=$(cd -- "$BASE_DIR" && pwd)
fi

TS=$(date +%Y%m%d_%H%M%S)
LANG_DIR="$BASE_DIR/language/$LANG_CODE"
NEW_LANG_DIR="$SCRIPT_DIR/language/$LANG_CODE"
CACHE_DIR="$BASE_DIR/cache"
BACKUP_DIR="$BASE_DIR/language/backup_${LANG_CODE}_$TS"
LOCK_DIR="$BASE_DIR/.lang_update_${LANG_CODE}.lock"

# Acquire lock
if ! mkdir "$LOCK_DIR" 2>/dev/null; then
  error "Ya existe un lock en $LOCK_DIR (¿otro proceso en ejecución?)."
fi
cleanup_lock() { rmdir "$LOCK_DIR" 2>/dev/null || true; }
trap cleanup_lock EXIT INT TERM

(( VERBOSE )) && set -x

# Safety checks
[[ -n "$BASE_DIR" && "$BASE_DIR" != "/" ]] || error "BASE_DIR resuelto a '/' o vacío; abortando."
[[ -f "$BASE_DIR/config/blesta.php" ]] || error "No se detecta una instalación de Blesta en '$BASE_DIR'."
[[ -d "$LANG_DIR" ]] || error "Directorio de idioma destino no encontrado: '$LANG_DIR'."

if [[ -n "$ROLLBACK_DIR" ]]; then
  [[ -d "$ROLLBACK_DIR" ]] || error "Directorio de backup para rollback no existe: '$ROLLBACK_DIR'."
else
  [[ -d "$NEW_LANG_DIR" ]] || error "Directorio con nuevos archivos de idioma no encontrado: '$NEW_LANG_DIR'."
  # Evitar que src y dst sean el mismo directorio
  [[ "$NEW_LANG_DIR" != "$LANG_DIR" ]] || error "El origen y destino de idioma son el mismo directorio."
fi

# Tools
have_rsync=0
if command -v rsync >/dev/null 2>&1; then
  have_rsync=1
fi

copy_tree() {
  local src="$1"
  local dst="$2"
  local desc="$3"

  if (( DRY_RUN )); then
    log "(dry-run) $desc: $src -> $dst"
    if (( have_rsync )); then
      rsync -a -n --itemize-changes "$src"/ "$dst"/ || true
    else
      local count
      count=$(find "$src" -type f | wc -l | tr -d '[:space:]')
      log "(dry-run) rsync no disponible; se usaría 'cp -a'. Archivos aprox: $count"
    fi
    return 0
  fi

  mkdir -p "$dst"
  if (( have_rsync )); then
    local opts=(-a)
    (( VERBOSE )) && opts+=(--info=STATS,NAME,SKIP)
    rsync "${opts[@]}" "$src"/ "$dst"/
  else
    cp -a "$src/." "$dst/"
  fi
}

# Pre-flight summary
log "Base:        $BASE_DIR"
log "Idioma:      $LANG_CODE"
log "Destino:     $LANG_DIR"
if [[ -n "$ROLLBACK_DIR" ]]; then
  log "Rollback:    desde $ROLLBACK_DIR"
else
  log "Origen:      $NEW_LANG_DIR"
fi
log "Backup:      $BACKUP_DIR"
log "Cache:       ${CACHE_DIR:-<no existe>}"
log "Modo:        $({ ((DRY_RUN)) && echo 'dry-run'; } || echo 'ejecución real')"
(( NO_CACHE )) && log "Nota:        Limpieza de caché deshabilitada"

# Confirmation
if (( ! CONFIRM_YES )); then
  read -r -p "¿Continuar? [y/N] " ans
  case "$ans" in
    [Yy]*|[Ss]*) ;;
    *) echo "Cancelado."; exit 0;;
  esac
fi

# Backup actual
log "Creando backup en '$BACKUP_DIR'..."
copy_tree "$LANG_DIR" "$BACKUP_DIR" "Backup"
(( ! DRY_RUN )) && log "Backup creado."

if [[ -n "$ROLLBACK_DIR" ]]; then
  # Restore from backup
  log "Restaurando idioma desde '$ROLLBACK_DIR'..."
  copy_tree "$ROLLBACK_DIR" "$LANG_DIR" "Rollback"
  (( ! DRY_RUN )) && log "Rollback completado."
else
  # Apply new files
  log "Aplicando nuevos archivos de idioma..."
  copy_tree "$NEW_LANG_DIR" "$LANG_DIR" "Actualización de idioma"
  (( ! DRY_RUN )) && log "Archivos de idioma actualizados."
fi

# Cache clean
if (( NO_CACHE )); then
  log "Limpieza de caché omitida por --no-cache."
elif [[ -d "$CACHE_DIR" ]]; then
  if (( DRY_RUN )); then
    log "(dry-run) Limpiaría caché en '$CACHE_DIR' (solo contenido)."
    find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -print
  else
    log "Limpiando caché en '$CACHE_DIR'..."
    find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
    log "Caché limpiada."
  fi
else
  log "Directorio de caché no encontrado; se omite la limpieza."
fi

log "¡Listo! Punto de restauración: $BACKUP_DIR"
