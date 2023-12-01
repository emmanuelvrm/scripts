#!/bin/bash

#readpst -M rute.pst -o "/mnt/7AA8219E1D539ADD/Documentos/Rute"

# Define a pasta principal que contém os arquivos que você deseja processar
main_folder="/mnt/7AA8219E1D539ADD/Documentos/saida"

# Define o tamanho máximo das pastas
max_folder_size=$((240 * 1000000))

# Função para separar os arquivos em pastas menores
separate_files() {
    # Navegue até a pasta
    cd "$1"

    # Obtenha o tamanho total dos arquivos na pasta
    total_size=$(du -sb . | awk '{ print $1 }')

    # Divida o tamanho total pelo tamanho máximo das pastas para obter o número total de pastas que serão criadas.
    total_folders=$((($total_size / $max_folder_size) + 1))

    # Crie o número total de pastas necessárias
    for (( i=1; i<=$total_folders; i++ ))
    do
      mkdir "pasta_$i"
    done

    # Liste os arquivos na pasta e divida-os em pastas menores
    total_size=0
    folder=1
    find . -maxdepth 1 -type f -print0 | while read -d '' -r file
    do
      size=$(du -b "$file" | cut -f1)
      total_size=$((total_size + size))

      if [ "$total_size" -gt $max_folder_size ]
      then
        folder=$((folder + 1))
        total_size=$size
      fi

      mv "$file" "pasta_$folder/"
    done

    # Compacte cada pasta menor individualmente
    for dir in pasta_*; do
      zip -r "${dir}.zip" "$dir"
      rm -r "$dir"
    done
}

# Chama a função separate_files() na pasta principal
separate_files "$main_folder"

# Define o caminho da pasta onde os arquivos .zip serão movidos e renomeados
target_folder="/mnt/7AA8219E1D539ADD/Documentos/saida/temp"

# Inicializa a variável de contagem de arquivos
count=1

# Busca por arquivos .zip na pasta principal
find "$main_folder" -type f -name "*.zip" | while read file_path
do
    # Define o novo nome do arquivo, adicionando um número de ordem à frente do nome original
    new_name="$count-$(basename "$file_path")"
    
    # Move o arquivo para a pasta alvo e renomeia-o
    mv "$file_path" "$target_folder/$new_name"
    
    # Incrementa a variável de contagem de arquivos
    ((count++))
done

