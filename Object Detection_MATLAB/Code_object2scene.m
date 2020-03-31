% Kelly Harke, Erica Lemieux
% ENGO 559 - Digital Imaging
% Object detection using point feature matching

clear all
clc
close all


%% 1. READ IMAGES

% 1.a. read object
object = rgb2gray(imread('object.png'));
figure   % display object
imshow(object);
title('Figure 1.a. Image of an object - original');

% 1.b. read scene image
scene = rgb2gray(imread('image.jpg'));
figure; % display scene image
imshow(scene);
title('Figure 1.b. Image of a scene');


%% 2. DETECT MATCHING FEATURE POINTS

% Detect features in both images
objPTs = detectSURFFeatures(object);
scenePTs = detectSURFFeatures(scene);

figure; % display feature points from object image
imshow(object);
title('Figure 2.a. 100 Strongest Feature Points from Object Image');
hold on;
plot(selectStrongest(objPTs, 100));

figure; % display feature points from scene image
imshow(scene);
title('Figure 2.b. 300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePTs, 300));

%% 3. EXTRACT FEATURE DESCRIPTORS

% Extract feature descriptors
[objFeats, objPTs] = extractFeatures(object, objPTs);
[sceneFeats, scenePTs] = extractFeatures(scene, scenePTs);

% Match features using their descriptors
indexPairs = matchFeatures(objFeats, sceneFeats); % Find putative point matches - INCLUDING OUTLIERS

% Retrieve locations of corresponding points for each image.
matchedObjPTs = objPTs(indexPairs(:, 1));
matchedScenePTs = scenePTs(indexPairs(:, 2));

% Show putative point matches - Original to scene
figure; % display matched features
showMatchedFeatures(object, scene, matchedObjPTs, matchedScenePTs, 'montage');
title({'Figure 3.a. Putatively matched points (w/ outliers)',...
            '- original object to scene'});

% Locate the object in the scene - EXCLUDING OUTLIERS
[tform, inlierObjectPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedObjPTs, matchedScenePTs, 'affine');
figure; % display matched points without outliers
showMatchedFeatures(object, scene, inlierObjectPoints, ...
    inlierScenePoints, 'montage');
title('Figure 3.b. Matched Points (Inliers Only)');

%% 4. LOCATE OBJECT IN SCENE

% polygon around reference image
objectPolygon = [1, 1;...                           % top-left
        size(object, 2), 1;...                 % top-right
        size(object, 2), size(object, 1);... % bottom-right
        1, size(object, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

newObjectPolygon = transformPointsForward(tform, objectPolygon);

figure; % show detected object
imshow(scene);
hold on;
line(newObjectPolygon(:, 1), newObjectPolygon(:, 2), 'Color', 'y');
title('Figure 4. Detected Object');
