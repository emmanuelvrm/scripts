#Converte as legendas srt para ass
#Converte o video de mkv para mp4
for arquivo in *.srt; do ffmpeg -i "$arquivo" -scodec ass "${arquivo%.srt}.ass" && rm "$arquivo"; done ; for video in *.mkv; do ffmpeg -i "$video" -c:v libx264 -c:a aac "${video%.mkv}.mp4"; done

