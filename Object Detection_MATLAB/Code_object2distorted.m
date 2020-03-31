% Kelly Harke, Erica Lemieux
% ENGO 559 - Digital Imaging
% Object detection using point feature matching

clear all
clc
close all


%% 1. READ IMAGES

% 1.a. read object
object = rgb2gray(imread('object.png'));

%% 2. RESIZE AND ROTATE IMAGE

scale = 0.3;
theta = 300;
J = imresize(object, scale); % Try varying the scale factor.
distorted = imrotate(J, theta); % Try varying the angle, theta.

% Display
figure   % original
imshow(object);
title('Figure 2.a. Image of an object - original');

figure
imshow(distorted);
title('Figure 2.b. Image of an object - distorted');


%% 3. DETECT MATCHING FEATURE POINTS

% Detect features in both images
objPTs = detectSURFFeatures(object);
objPTs_distorted = detectSURFFeatures(distorted);

figure % display feature points from original
imshow(object);
title('Figure 3.a. 100 strongest features from original');
hold on
plot(selectStrongest(objPTs, 100));

figure % display feature points from distorted
imshow(distorted);
title('Figure 3.a. 100 strongest features from distorted');
hold on
plot(selectStrongest(objPTs_distorted, 100));

%% 4. EXTRACT FEATURE DESCRIPTORS

% Extract feature descriptors
[objFeats, objPTs] = extractFeatures(object, objPTs);
[objFeats_distorted, objPTs_distorted] = extractFeatures(distorted, objPTs_distorted);

% Match features using their descriptors
indexPairs = matchFeatures(objFeats, objFeats_distorted);

% Retrieve locations of corresponding points for each image.
matchedObjPTs = objPTs(indexPairs(:, 1));
matchedObjPTs_distorted = objPTs_distorted(indexPairs(:, 2));

%% 5. Show putative point matches

% Original to distorted
figure; % display matched features
showMatchedFeatures(object, distorted, matchedObjPTs, matchedObjPTs_distorted, 'montage');
title({'Figure 5.b. Putatively matched points (w/ outliers)',...
            '- original object to distortion'});

%% 6. ESTIMATE TRANSFORMATION
% Find a transformation corresponding to the matching point pairs using the 
% statistically robust M-estimator SAmple Consensus (MSAC) algorithm (a 
% variant of RANSAC). It removes outliers while computing the transformation 
% matrix. 

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedObjPTs_distorted, matchedObjPTs, 'similarity');

% Display matching point pairs used in the computation of the transformation.

figure
showMatchedFeatures(object, distorted, inlierOriginal, inlierDistorted);
title('Figure 6. Matching points (inliers only)');
legend('ptsOriginal','ptsDistorted');

%% 7. SOLVE FOR SCALE AND ANGLE
% Use the geometric transform, tform, to recover the scale and angle. 
% Since the transformation is computed from distorted -> original image, 
% the inverse must be calculated to recover the distortion.

%Let sc = s*cos(theta)
%Let ss = s*sin(theta)
% Then, Tinv = [sc -ss  0;
%               ss  sc  0;
%               tx  ty  1]
% where tx and ty are x and y translations, respectively.
Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss + sc*sc)
thetaRecovered = atan2(ss,sc)*180/pi

