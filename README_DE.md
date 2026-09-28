# P5.js: RTMP Stream

[English](readme.md)

Spielt einen Live-Kamerastream auf einer Zeichenfläche von 640×480 ab. Ein
Shell-Skript wandelt den Stream der Kamera mit ffmpeg in HLS-Segmente
(`.m3u8` + `.ts`) im Ordner `streamer/` um, die der Sketch lädt und Bild
für Bild zeichnet. Ein Ausgangspunkt, um Netzwerkkameras zu verwenden, die
kein MJPEG anbieten. Trotz des Namens erwartet das Skript eine RTSP-Quelle
(`rtsp://...`).

## Installation

Voraussetzungen: [ffmpeg](https://ffmpeg.org) (z. B.
`brew install ffmpeg`) und die RTSP-URL einer IP-Kamera.

1. In `streamer/createStream.sh` den Quellstream in der Variable `input`
   eintragen.
2. Das Skript in einem Terminal starten und laufen lassen:
   `bash streamer/createStream.sh`
   Es löscht alte Segmente und schreibt `stream.m3u8` und nummerierte
   `.ts`-Dateien nach `streamer/`.
3. Den Ordner in Visual Studio Code öffnen und Live Server starten (in der
   Statusleiste auf **Go Live** klicken). Der Sketch zeigt "Loading
   video...", bis der Stream abgespielt werden kann.

Die Workspace-Einstellungen sagen Live Server, dass `streamer/**`, `*.ts`
und `*.m3u8` ignoriert werden sollen, damit die ständig wechselnden
Segmente kein Neuladen auslösen. Die erzeugten Dateien sind auch in
`.gitignore` ausgeschlossen.

Bibliotheken (in `libraries/`): p5.js 1.10.0, p5.sound 1.0.1 (eingebunden,
nicht verwendet), hls.js 1.6.9.

## Coding-Hilfe

- **`streamer/createStream.sh`**: startet ffmpeg mit `-rtsp_transport tcp`
  und kopiert das Video ohne Neukodierung (`-vcodec copy`, ohne Ton) in
  HLS-Segmente von 1 Sekunde, wobei nur die letzten 3 in der Playlist
  bleiben (`-hls_time`, `-hls_list_size`). Die ganze Ausgabe von ffmpeg geht
  nach `/dev/null` – `> /dev/null 2>&1` entfernen, um Fehler zu sehen.
- **`sketch.js` → `setup()`**: erstellt ein verstecktes, stummes
  Video-Element. Safari spielt HLS nativ ab, andere Browser laden
  `videoSrc` (`./streamer/stream.m3u8`) mit hls.js. Bei `canplay` wird
  `videoReady` gesetzt und das Video läuft in Schleife.
- **`draw()`**: zeichnet das Video mit `image()` auf die Zeichenfläche oder
  einen Ladetext, solange der Stream nicht bereit ist. Hier die eigene
  Verarbeitung ergänzen.
