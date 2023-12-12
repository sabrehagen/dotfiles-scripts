INPUT_FILE=${1-$(ls ~/videos | grep -E ^recording- | sort -rn | head -n1)}
OUTPUT_FILE=$(echo $INPUT_FILE | sed 's/.mp4//')-compressed.mp4

ffmpeg \
  -i $INPUT_FILE \
  -c:v libx264 \
  -crf 23 \
  -preset medium \
  -c:a aac \
  -b:a 128k \
  $OUTPUT_FILE

echo $OUTPUT_FILE
