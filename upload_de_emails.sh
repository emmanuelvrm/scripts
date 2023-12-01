# Define a pasta raiz onde a busca por arquivos .zip será realizada
root_folder="/mnt/7AA8219E1D539ADD/Documentos/antigos"

# Define o caminho da pasta onde os arquivos .zip serão movidos e renomeados
target_folder="/mnt/7AA8219E1D539ADD/Documentos/antigos/enviar"

# Inicializa a variável de contagem de arquivos
count=1

# Busca por arquivos .zip em todas as subpastas a partir da pasta raiz
find "$root_folder" -type f -name "*.zip" | while read file_path
do
    # Define o novo nome do arquivo, adicionando um número de ordem à frente do nome original
    new_name="$count-$(basename "$file_path")"
    
    # Move o arquivo para a pasta alvo e renomeia-o
    mv "$file_path" "$target_folder/$new_name"
    
    # Incrementa a variável de contagem de arquivos
    ((count++))
done
