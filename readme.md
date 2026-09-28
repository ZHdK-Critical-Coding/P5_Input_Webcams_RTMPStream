# P5.js: RTMP Stream

[Deutsch](README_DE.md)

Plays a live camera stream in a 640×480 canvas. A shell script uses ffmpeg
to convert the camera's stream into HLS segments (`.m3u8` + `.ts`) in the
`streamer/` folder, which the sketch then loads and draws frame by frame.
A starting point for using network cameras that don't offer MJPEG. Despite
the name, the script expects an RTSP source (`rtsp://...`).

## Installation

Requirements: [ffmpeg](https://ffmpeg.org) (e.g. `brew install ffmpeg`)
and the RTSP URL of an IP camera.

Replace the placeholder `rtsp://USER:PASS@CAMERA-IP:554/stream` in the
`input` variable of `streamer/createStream.sh` with the RTSP address of
your own camera. As long as the placeholder is there, the script stops
with a hint.

Libraries (in `libraries/`): p5.js 1.10.0, p5.sound 1.0.1 (included, not
used), hls.js 1.6.9.

## How to Run

1. Run the script in a terminal and keep it running:
   `bash streamer/createStream.sh`
   It deletes old segments and writes `stream.m3u8` and numbered `.ts`
   files into `streamer/`.
2. Open the folder in Visual Studio Code and start Live Server (click
   **Go Live** in the status bar). The sketch shows "Loading video..."
   until the stream can be played.

The workspace settings tell Live Server to ignore `streamer/**`, `*.ts` and
`*.m3u8`, so the constantly changing segments do not trigger reloads. The
generated files are also excluded in `.gitignore`.

## Coding Help

- **`streamer/createStream.sh`**: runs ffmpeg with `-rtsp_transport tcp`
  and copies the video without re-encoding (`-vcodec copy`, no audio) into
  HLS segments of 1 second, keeping only the last 3 in the playlist
  (`-hls_time`, `-hls_list_size`). All ffmpeg output goes to `/dev/null` –
  remove `> /dev/null 2>&1` to see errors.
- **`sketch.js` → `setup()`**: creates a hidden, muted video element. Safari
  plays HLS natively; other browsers use hls.js to load `videoSrc`
  (`./streamer/stream.m3u8`). On `canplay`, `videoReady` is set and the
  video loops.
- **`draw()`**: draws the video with `image()` onto the canvas, or a
  loading text while the stream isn't ready. Add your own processing here.
