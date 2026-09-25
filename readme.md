# P5 -> RTMP Stream

A p5.js sketch that plays an HLS (`.m3u8`) video stream in a 640x480 canvas.
A shell script uses ffmpeg to convert a live camera stream (RTSP) into HLS
segments in the `streamer/` folder, which the sketch then loads.

## How to Use

1. Install [ffmpeg](https://ffmpeg.org) (e.g. `brew install ffmpeg`).
2. Set the source stream in the `input` variable of
   `streamer/createStream.sh` (an `rtsp://...` URL of an IP camera).
3. Run the script in a terminal and keep it running:
   `bash streamer/createStream.sh`
   It deletes old segments and writes `stream.m3u8` and numbered `.ts`
   files into `streamer/`.
4. Start Live Server (click **Go Live** in the VS Code status bar). The
   sketch shows "Loading video..." until the stream can be played.

## How it Works

- ffmpeg copies the video without re-encoding (`-vcodec copy`, no audio) into
  HLS segments of 1 second, keeping only the last 3 in the playlist.
- The sketch creates a hidden, muted video element. Safari plays HLS
  natively; other browsers use hls.js to load `./streamer/stream.m3u8`.
- Each frame is drawn with `image()` onto the canvas.
- The workspace settings tell Live Server to ignore `streamer/**`, `*.ts`
  and `*.m3u8`, so the constantly changing segments do not trigger reloads.
  The generated files are also excluded in `.gitignore`.

## Libraries

- p5.js 1.10.0
- p5.sound 1.0.1 (loaded, not used)
- hls.js 1.6.9
