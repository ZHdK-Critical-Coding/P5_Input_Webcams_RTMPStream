#!/bin/bash

# RTSP-Adresse deiner eigenen IP-Kamera eintragen (Benutzer, Passwort, IP und Pfad siehe Handbuch der Kamera)
input="rtsp://USER:PASS@CAMERA-IP:554/stream"

if [[ "$input" == *"CAMERA-IP"* ]]; then
  echo "Bitte zuerst in streamer/createStream.sh die Variable input auf die RTSP-Adresse deiner Kamera setzen,"
  echo "z.B. input=\"rtsp://admin:geheim@192.168.1.50:554/stream\"."
  echo "Please set the variable input in streamer/createStream.sh to the RTSP address of your camera first."
  exit 1
fi

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
 -i "$input" \
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
