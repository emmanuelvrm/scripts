#!/bin/bash

# Este script separa as perguntas em arquivos diferentes para sintetização de voz
# O arquivo de entrada deve se chamar input.txt


# Nome do arquivo de entrada
input_file="input.txt"
# Nome do arquivo de saída
output_file="input2.txt"

# Executa a substituição com awk para adicionar "proxima_pergunta" e quebra de linha no início de cada linha
awk '{print "proxima_pergunta"; print $0}' "$input_file" |
  # Executa outra substituição com awk para adicionar "{{Pause=2}}" após as perguntas (?)
  awk '{gsub(/\?/, "& {{Pause=2}}")} 1' |
  # Adiciona "{{Pause=1}}" no final de cada linha
  awk '{print $0 " {{Pause=1}}"}' > "$output_file"

# Defina o nome do arquivo de entrada
INPUT_FILE="input2.txt"

# Verifique se o arquivo de entrada existe
if [ ! -f "$INPUT_FILE" ]; then
  echo "Arquivo de entrada $INPUT_FILE não encontrado."
  exit 1
fi

# Defina o nome base dos arquivos de saída
OUTPUT_BASE="parte"

# Defina o contador para o nome dos arquivos de saída
OUTPUT_COUNT=1

# Defina o nome do arquivo de saída atual e o arquivo de saída anterior
CURRENT_OUTPUT=""
PREVIOUS_OUTPUT=""

# Leia o arquivo de entrada linha por linha
while read -r line; do
  # Verifique se a linha é um separador de perguntas
  if [[ "$line" == "proxima_pergunta"* ]]; then
    # Defina o nome do arquivo de saída atual
    CURRENT_OUTPUT="$OUTPUT_BASE$OUTPUT_COUNT.txt"

    # Incrementa o contador de nomes dos arquivos de saída
    OUTPUT_COUNT=$((OUTPUT_COUNT+1))

    # Crie o novo arquivo de saída
    touch "$CURRENT_OUTPUT"

    # Se o arquivo de saída anterior já foi definido, feche-o
    if [ -n "$PREVIOUS_OUTPUT" ]; then
      exec 1>&3-
    fi

    # Redirecione a saída para o novo arquivo de saída
    exec 3>&1
    exec >>"$CURRENT_OUTPUT"

    # Defina o arquivo de saída anterior como o arquivo de saída atual
    PREVIOUS_OUTPUT="$CURRENT_OUTPUT"
  else
    # Escreva a linha atual no arquivo de saída
    echo "$line"
  fi
done < "$INPUT_FILE"

# Feche o arquivo de saída final
if [ -n "$PREVIOUS_OUTPUT" ]; then
  exec 1>&3-
fi
