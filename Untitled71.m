% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Read a video frame and run the detector.
videoFileReader = vision.VideoFileReader('test.avi');
videoFrame      = step(videoFileReader);
bbox            = step(faceDetector, videoFrame);

