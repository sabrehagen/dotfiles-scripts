INPUT_PATH=${1-$(ls $HOME/videos | grep -E ^recording- | sort -rn | head -n1)}
OUTPUT_PATH=$INPUT_PATH-compressed.mp4

ffmpeg \
  -i $INPUT_PATH \
  -c:v libx264 \
  -crf 23 \
  -preset medium \
  -c:a aac \
  -b:a 128k \
  $OUTPUT_PATH \
  2>/dev/null

echo $OUTPUT_PATH
