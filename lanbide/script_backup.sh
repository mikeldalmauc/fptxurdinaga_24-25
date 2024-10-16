#!/bin/bash

# Ruta de destino del backup
BACKUP_DIR="/mnt/backup"
LOG_FILE="$BACKUP_DIR/backup.log"

# Comprobar si la partición de backup está montada
if mountpoint -q "$BACKUP_DIR"; then
    # Ejecutar rsync para hacer el backup del sistema
    rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / "$BACKUP_DIR" > "$LOG_FILE" 2>&1
else
    echo "Error: El directorio de backup no está montado." >> "$LOG_FILE"
fi
