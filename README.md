# Personalización Blesta

## Script de Automatización

Para facilitar la aplicación de los cambios, se incluye un script de automatización.

### Uso del Script

1. Guarda el script como `aplicar_idioma.sh` en directorio raíz de Blesta.
2. Dale permisos de ejecución: `chmod +x aplicar_idioma.sh`
3. Ejecuta el script: `./aplicar_idioma.sh`

### Comando de Ejemplo

```bash
# Comando todo-en-uno para actualizar idiomas
mkdir -p nuevos-idiomas && \
cd nuevos-idiomas && \
git clone https://github.com/aladuuu/clientes.blackbelt.cl.git && \
chmod +x clientes.blackbelt.cl/aplicar_idioma.sh && \
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
