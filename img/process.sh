#!/bin/bash

# Image processing script
# Requirements:
#   sudo apt install imagemagick webp jpegoptim optipng

# Usage:
#   ./process_images.sh /path/to/image

INPUT=$1
if [ -z "$INPUT" ]; then
  echo "Usage: $0 <image file path>"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "❌ Error: '$INPUT' is not a file"
  exit 1
fi

# Extract name and extension
BASENAME=$(basename "$INPUT")
NAME="${BASENAME%.*}"
EXT="${BASENAME##*.}"
EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

# Validate format
case "$EXT" in
  jpg|jpeg|png)
    ;;
  *)
    echo "❌ Unsupported format: .$EXT"
    echo "Allowed formats: jpg, jpeg, png"
    exit 1
    ;;
esac

# Output directories
OUT_PNG="o/png"
OUT_WEBP="o/webp"
mkdir -p "$OUT_PNG" "$OUT_WEBP"

# Target sizes
SIZES=("64x64" "128x128" "256x256" "512x512" "1024x1024")

echo "🔧 Processing: $NAME"

for SIZE in "${SIZES[@]}"; do
  OUT_PNG_PATH="${OUT_PNG}/${NAME}_${SIZE}.png"
  OUT_WEBP_PATH="${OUT_WEBP}/${NAME}_${SIZE}.webp"

  # 1️⃣ Resize
  echo $INPUT, $SIZE, $OUT_PNG_PATH
  convert "$INPUT" -resize "$SIZE" -strip "$OUT_PNG_PATH"

  # 2️⃣ Optimize PNG
  optipng -o7 -quiet "$OUT_PNG_PATH"
  
  # 3️⃣ Convert to WebP
  cwebp -q 80 "$OUT_PNG_PATH" -o "$OUT_WEBP_PATH" >/dev/null 2>&1
done

echo "✅ Done!"
echo "Optimized PNGs: $OUT_PNG"
echo "Optimized WebPs: $OUT_WEBP"
