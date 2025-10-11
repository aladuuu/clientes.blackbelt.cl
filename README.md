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
#!/bin/bash

# Directorio de idiomas de Blesta
LANG_DIR="/language/es_es"

# Verifica si el directorio existe
if [ ! -d "$LANG_DIR" ]; then
    echo "Error: Directorio de idiomas no encontrado"
    exit 1
fi

# Copia los archivos de idioma
echo "Aplicando cambios de idioma..."
cp -R ./language/es_es/* /ruta/a/blesta/language/es_es/

# Limpia la caché
echo "Limpiando caché..."
rm -rf /ruta/a/blesta/cache/*

echo "¡Cambios aplicados exitosamente!"
```

### Uso del Script

1. Guarda el script como `aplicar_idioma.sh`
2. Dale permisos de ejecución: `chmod +x aplicar_idioma.sh`
3. Ejecuta el script: `./aplicar_idioma.sh`

### Comando de Ejemplo

```bash
sudo ./aplicar_idioma.sh --path=/var/www/html/blesta --backup=true --verbose
```

Este comando:

- Ejecuta el script con privilegios de administrador
- Especifica la ruta de instalación de Blesta
- Crea una copia de seguridad antes de aplicar los cambios
- Muestra información detallada durante la ejecución

Nota: Asegúrate de modificar las rutas según tu instalación de Blesta.
