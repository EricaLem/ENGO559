% Kelly Harke, Erica Lemieux
% ENGO 559 - Digital Imaging
% Image Rotation and Scale Using Automated Feature Matching

% Automatically align two images
% that differ by rotation and scale

clear;
clc;

original_image = rgb2gray(imread('Jezersko.jpg')); % read image and convert to grayscale

resized_image = imresize(original_image, 0.7); % resize image
rotated_image = imrotate(resized_image, 30); % rotate image

points_original = detectSURFFeatures(original_image); % detect features in both images
points_rotated = detectSURFFeatures(rotated_image);

%% Find matching features
[features_original, validPoints_original] = extractFeatures(original_image, points_original); % extract feature descriptors
[features_rotated, validPoints_rotated] = extractFeatures(rotated_image, points_rotated);

index_pairs = matchFeatures(features_original, features_rotated); % match features with descriptors

matched_original = validPoints_original(index_pairs(:,1)); % retrieve locations of points for each image
matched_rotated = validPoints_rotated(index_pairs(:,2));

% figure; % show matched points
% showMatchedFeatures(original_image, rotated_image, matched_original, matched_rotated);
% title('Putatively Matched Points (Including Outliers)');

%% Estimate transformation

[tform, inlier_rotated, inlier_original] = estimateGeometricTransform(matched_rotated, matched_original, 'similarity');

% figure; % show matching pair points used in transformation
% showMatchedFeatures(original_image, rotated_image, inlier_original, inlier_rotated);
% title('Matching Points (Inliers Only)');
% legend('Original Points','Rotated Points');

%% Solve for scale and angle

Tinv  = tform.invert.T;

ss = Tinv(2,1);
sc = Tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc);
theta_recovered = atan2(ss,sc)*180/pi;

%% Recover original image

output = imref2d(size(original_image));
recovered_image = imwarp(rotated_image, tform, 'OutputView', output);

figure;
montage({original_image, recovered_image});


