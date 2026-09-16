#!/bin/bash

input="rtsp://5.149.25.177:554/11"

#https://www.shodan.io/host/91.232.238.202 (https://www.shodan.io/search?query=has_screenshot%3Atrue+country%3Aua)

output="stream.m3u8"
echo "🚀 RTMP -> M3U8 Stream Converter"
echo "Transcodes $input -> $output"


cd "$(dirname "$0")" || exit 1

rm *.ts
rm *.m3u8

echo "Running..."

ffmpeg -fflags nobuffer \
 -loglevel debug \
 -rtsp_transport tcp \
 -i $input \
 -vsync 0 \
 -copyts \
 -vcodec copy \
 -movflags frag_keyframe+empty_moov \
 -an \
 -hls_flags delete_segments+append_list \
 -f hls \
 -hls_time 1 \
 -hls_list_size 3 \
 -hls_segment_type mpegts \
 -hls_segment_filename './%d.ts' \
$output > /dev/null 2>&1

echo "Stopped..."
