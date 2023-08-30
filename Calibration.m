% Auto-generated by cameraCalibrator app on 02-Dec-2022
%-------------------------------------------------------


% Define images to process
imageFileNames = {'C:\Users\kevin\Documents\MATLAB\calibration\check1.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check2.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check4.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check5.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check7.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check8.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check12.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check17.jpg',...
    'C:\Users\kevin\Documents\MATLAB\calibration\check20.jpg',...
    };
% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 25;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, cameraParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
