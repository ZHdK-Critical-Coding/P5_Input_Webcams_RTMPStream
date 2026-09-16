// A p5.js sketch that reads an HLS (m3u8) input stream and displays it
// as a p5.js image which can be further processed.
// © uh 2025

// HTMLVideoElement used to hold the HLS stream
let videoElement;
// HLS.js instance for browsers that do not natively support HLS
let hls;
// Path to HLS stream (m3u8)
const videoSrc = './streamer/stream.m3u8';  
let videoReady = false;  // Flag to indicate when video can be drawn
let img;                 // Optional: store video frames as p5.Image

function setup() {
  createCanvas(640, 480);
  background(0);

  // Create p5.js video element (initially empty)
  videoElement = createVideo([]);

  // Listener for when video is ready to play
  videoElement.elt.addEventListener('canplay', () => {
    videoReady = true;       // Video is ready for drawing
    videoElement.volume(0);  // Mute video
    videoElement.hide();     // Hide HTML video element; we draw it manually
    videoElement.loop();     // Loop the video
  });

  // Check if browser supports HLS natively (Safari / iOS)
  if (videoElement.elt.canPlayType('application/vnd.apple.mpegurl')) {
    videoElement.elt.src = videoSrc;
    videoElement.elt.width = width;
    videoElement.elt.height = height;
  } 
  // If not supported natively, use HLS.js library
  else if (Hls.isSupported()) {
    hls = new Hls();
    hls.loadSource(videoSrc);          // Load the HLS stream
    hls.attachMedia(videoElement.elt); // Attach video element
    hls.on(Hls.Events.MANIFEST_PARSED, () => {
      videoElement.elt.play();        // Play when manifest is loaded
      videoElement.elt.width = width;
      videoElement.elt.height = height;
    });
  } 
  // Fallback if neither native nor HLS.js is supported
  else {
    console.error('This browser does not support HLS playback.');
  }
}

function draw() {
  background(0);

  if (videoReady) {
    try {
      // Draw the video element onto the p5.js canvas
      image(videoElement, 0, 0, width, height);
    } catch (e) {
      // Catch any drawing errors to avoid crashing the sketch
      console.warn('Error drawing video frame:', e);
    }
  } else {
    // Show loading text until video is ready
    fill(255);
    textSize(16);
    text('Loading video...', 20, 40);
  }
}