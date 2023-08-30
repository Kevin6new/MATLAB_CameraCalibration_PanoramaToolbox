% Display images to be stitched.
direc = ["calibration"];
scene = imageDatastore(direc(1));
montage(scene.Files)
% Create a set of calibration images.
images = imageDatastore(fullfile(toolboxdir("vision"), "visiondata", ...
    "calibration", "mono"));
imageFileNames = images.Files;
% Detect calibration pattern.
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
% Generate world coordinates of the corners of the squares.
squareSize = 29; % millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
% Calibrate the camera.
I = readimage(images, 1); 
imageSize = [size(I, 1), size(I, 2)];
[params, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
                                     ImageSize=imageSize);
figure; 
showReprojectionErrors(params,'ScatterPlot');