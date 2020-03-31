% Kelly Harke, Erica Lemieux
% ENGO 559 - Digital Imaging
% Final Project
% Normalized 2D cross-correlation (NCC)

% Definition:
% normxcorr2()computes the normalized cross-correlation of an 
% input image, A, and a template matrix. The resulting matrix C 
% contains the correlation coefficients.

clear all
close all
clc

% C = normxcorr2(template, A)
% C = matrix of correlation coefficients
% A = input image

%% I. EXAMPLE I - Use Cross-Correlation to find template in image

% 1. Choose 2 images, one which is the sub-set of the other

orange   = rgb2gray(imread('orange2.jpg')); % read images and convert to grayscale
fruit = rgb2gray(imread('fruit.jpg'));

imshowpair(fruit, orange, 'montage')

% 2. Perform cross-correlation, and display the result as a surface

c = normxcorr2(orange, fruit);
figure
surf(c)
shading flat

% 3. Find the peak in cross-correlation

[ypeak, xpeak] = find(c==max(c(:)));

% 4. Account for the padding that normxcorr2 adds

yoffSet = ypeak-size(orange,1);
xoffSet = xpeak-size(orange,2);

% 5. Display the matched area

figure
imshow(fruit);
imrect(gca, [xoffSet+1, yoffSet+1, size(orange,2), size(orange,1)]);

