# Personalización de Idioma Español en Blesta

## Estructura de Archivos

La personalización del idioma español en Blesta se encuentra principalmente en el directorio `/language/es_es/`. Los archivos están organizados de la siguiente manera:

### Archivos Principales

1. `_404.php` - Mensajes de error 404
2. `_custom.php` - Personalizaciones específicas
3. `accounts.php` - Textos relacionados con cuentas
4. `actions.php` - Textos de acciones del sistema

### Administración

1. `admin_billing.php` - Facturación
2. `admin_clients_service.php` - Servicios de clientes
3. `admin_clients.php` - Gestión de clientes
4. `admin_company_*.php` - Configuraciones de empresa
   - Automatización
   - Facturación
   - Opciones de cliente
   - Monedas
   - Correos electrónicos
   - Y más...

### Portal del Cliente

1. `client_accounts.php` - Cuentas de cliente
2. `client_contacts.php` - Contactos
3. `client_invoices.php` - Facturas
4. `client_services.php` - Servicios
5. `client_transactions.php` - Transacciones

### Configuración del Sistema

1. `admin_system_*.php` - Archivos de configuración del sistema
   - API
   - Automatización
   - Copias de seguridad
   - Configuración general
   - Actualizaciones

### Otros Archivos

1. `currencies.php` - Configuración de monedas
2. `emails.php` - Plantillas de correo
3. `invoices.php` - Sistema de facturación
4. `languages.php` - Configuración de idiomas

## Notas Importantes

- Todos los archivos están en formato PHP
- Se organizan por funcionalidad y área del sistema
- Cada archivo contiene arrays asociativos con las traducciones
- Se mantiene una estructura jerárquica clara para fácil mantenimiento

## Script de Automatización

Para facilitar la aplicación de los cambios de idioma, se incluye un script de automatización:

```bash
```bash
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
echo "Si necesitas revertir los cambios, los archivos originales están en: $BACKUP_DIR"```
```

### Uso del Script

1. Guarda el script como `aplicar_idioma.sh`
2. Dale permisos de ejecución: `chmod +x aplicar_idioma.sh`
3. Ejecuta el script: `./aplicar_idioma.sh`

### Comando de Ejemplo

```bash
# Comando todo-en-uno para actualizar idiomas
mkdir -p nuevos-idiomas && \
cd nuevos-idiomas && \
git clone https://github.com/aladuuu/clientes.blackbelt.cl.git && \
cd .. && \
./nuevos-idiomas/clientes.blackbelt.cl/aplicar_idioma.sh
```

Este comando ejecuta la siguiente secuencia:

1. Crea una carpeta temporal `nuevos-idiomas`
2. Entra a la carpeta temporal
3. Clona el repositorio dentro de ella
4. Vuelve al directorio raíz
5. Ejecuta el script que realizará:
   - Backup de archivos existentes
   - Reemplazo directo de archivos de idioma
   - Limpieza de caché

El script detectará automáticamente:

- La ubicación del directorio raíz
- La estructura de carpetas necesaria
- Los archivos a reemplazar
- La ubicación correcta para el backup

Estructura de directorios:

```plaintext
/directorio-raiz/           # Directorio actual
├── language/              # Carpetas originales
│   └── es_es/
├── nuevos-idiomas/       # Carpeta temporal
│   └── clientes.blackbelt.cl/
│       └── language/
│           └── es_es/
└── cache/                # Caché de Blesta
```

Nota: Asegúrate de modificar las rutas según tu instalación de Blesta.
