#!/bin/bash

# Define o diretório principal e o tamanho máximo para os arquivos zip em megabytes
MAIN_DIR="/mnt/7AA8219E1D539ADD/Documentos/saida"
MAX_SIZE=240

# Cria uma pasta temporária para armazenar os arquivos compactados
TEMP_DIR="/mnt/7AA8219E1D539ADD/Documentos/saida/temp"

# Copia os arquivos para a pasta temporária, agrupando-os em pastas de no máximo 240MB
cd "$MAIN_DIR"
find . -maxdepth 1 -type f -print0 | xargs -0 -n1 -I{} du --apparent-size --block-size=1M {} | awk -v MAX_SIZE="$MAX_SIZE" '{ sum += $1; if (sum > MAX_SIZE) { i++; sum = $1 }; printf "%s\0%s%03d\n", $2, ENVIRON["TEMP_DIR"], i }' | xargs -0 -n2 -I{} sh -c 'mkdir -p "$1" && cp -f "$2" "$1"' --

# Compacta cada pasta em um arquivo zip separado
cd "$TEMP_DIR"
find . -mindepth 1 -type d -print0 | xargs -0 -n1 -I{} zip -r9 {}.zip "{}"

# Move os arquivos zip para a pasta principal
mv *.zip "$MAIN_DIR"

# Remove a pasta temporária e seu conteúdo
rm -rf "$TEMP_DIR"

