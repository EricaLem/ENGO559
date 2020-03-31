% Kelly Harke, Erica Lemieux
% ENGO 559 - Digital Imaging
% Object detection using point feature matching

clear;
clc;


%% read object
objectImage = rgb2gray(imread('object.png'));
figure; % display object
imshow(objectImage);
title('Image of a Object');

% read scene image
sceneImage = rgb2gray(imread('image.jpg'));
figure; % display scene image
imshow(sceneImage);
title('Full Image');

%% Detect feature points
objectPoints = detectSURFFeatures(objectImage);
scenePoints = detectSURFFeatures(sceneImage);

figure; % display feature points from object image
imshow(objectImage);
title('100 Strongest Feature Points from Object Image');
hold on;
plot(selectStrongest(objectPoints, 100));

figure; % display feature points from scene image
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));

%% Extract feature descriptions
[objectFeatures, objectPoints] = extractFeatures(objectImage, objectPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%% Find putative point matches
objectPairs = matchFeatures(objectFeatures, sceneFeatures);

matchedObjectPoints = objectPoints(objectPairs(:, 1), :);
matchedScenePoints = scenePoints(objectPairs(:, 2), :);
figure; % display matched features
showMatchedFeatures(objectImage, sceneImage, matchedObjectPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

%% Locate the object in the scene with matches
[tform, inlierObjectPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedObjectPoints, matchedScenePoints, 'affine');
figure; % display matched points without outliers
showMatchedFeatures(objectImage, sceneImage, inlierObjectPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

% polygon around reference image
objectPolygon = [1, 1;...                           % top-left
        size(objectImage, 2), 1;...                 % top-right
        size(objectImage, 2), size(objectImage, 1);... % bottom-right
        1, size(objectImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

newObjectPolygon = transformPointsForward(tform, objectPolygon);

figure; % show detected object
imshow(sceneImage);
hold on;
line(newObjectPolygon(:, 1), newObjectPolygon(:, 2), 'Color', 'y');
title('Detected Object');
