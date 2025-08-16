#!/usr/bin/env bash

# copr from https://github.com/notdanna/hypr.dots/blob/main/dots/hypr/scripts/swww.sh

WALLPAPER_DIR="/mnt/data/wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper"

# Verifica si el directorio existe
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "El directorio $WALLPAPER_DIR no existe. Por favor, crea la carpeta y pon ahí tus fondos." # spanish???
  exit 1
fi

WALLPAPERS=($(find "$WALLPAPER_DIR" \( -type f -o -type l \) \( -iname "*.jpg" -o -iname "*.gif" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.bmp" \)))

if [ -f "$CACHE_FILE" ]; then
  CURRENT_WALLPAPER=$(cat "$CACHE_FILE")
else
  CURRENT_WALLPAPER=""
fi

NEW_WALLPAPERS=()
for wp in "${WALLPAPERS[@]}"; do
  if [ "$wp" != "$CURRENT_WALLPAPER" ]; then
    NEW_WALLPAPERS+=("$wp")
  fi
done

if [ ${#NEW_WALLPAPERS[@]} -eq 0 ]; then
  NEW_WALLPAPERS=("${WALLPAPERS[@]}")
fi

# Obtiene una imagen aleatoria (considerando extensiones comunes)
RANDOM_WALLPAPER=$(printf "%s\n" "${NEW_WALLPAPERS[@]}" | shuf -n 1)

# Verifica que se haya encontrado al menos un archivo
if [ -z "$RANDOM_WALLPAPER" ]; then
  echo "No se encontraron imágenes en $WALLPAPER_DIR."
  exit 1
fi

POS1=$(awk -v seed=$RANDOM 'BEGIN { srand(seed); printf("%.3f", rand()) }')
POS2=$(awk -v seed=$RANDOM 'BEGIN { srand(seed); printf("%.3f", rand()) }')
TRANSITION_POS="$POS1,$POS2"
# Establece el fondo con una animación bonita
# Puedes ajustar los parámetros --transition-type, --transition-duration y --transition-step
swww img "$RANDOM_WALLPAPER" \
  --transition-type grow \
  --transition-pos "$TRANSITION_POS" \
  --transition-step 200 \
  --transition-duration 2 \
  --transition-fps 120

echo "Fondo de pantalla cambiado a: $RANDOM_WALLPAPER"

echo "$RANDOM_WALLPAPER" > "$CACHE_FILE"

matugen image $RANDOM_WALLPAPER
