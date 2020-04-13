# ENGO559 Final Project
This repository contains the Final Project for "ENGO559 - Digital Imaging" at the Schulich School of Engineering, Winter 2020.
The project examines existing open-source facial regognition algorithms and suggests improvements.

## Contributors
Kelly Harke and Erica Lemieux

## Due date
April 14, 2020

# Description - Facial Recognition in Images
## Overview

Facial recognition is the technological process of using software to uniquely identify a person by comparing facial characteristics in images of a database. It recognizes patterns based on a person's facial texture, shape, and spatial relationships between features. 

Since image-capturing conditions change, it can be difficult to achieve robust and accurate facial recognition algorithms. Conditions such as lighting changes, image quality, or view-angle variations can impede on the performance of the software tools.  

## Normalized cross-correlation
The project examines face recognition in images using known methods, including a literature review of provided materials. Specifically, the focus is on normalized cross-correlation (NCC) techniques in MATLAB. The function *normxcorr2* uses NCC of two matrices – (1) a known template of an object and (2) the input image - to compute the correlation coefficients. Finding the peak in the correlation coefficients with padding, matched areas between photos can be identified. The built-in NCC function in MATLAB works on images that are identical with no view-angle rotation or distortions.  

## Feature-matching
The project addresses rotation and scale differences between the two images to align the rotation of the faces as close as possible. The image rotation and scale can be estimated using an automated feature matching algorithm with the functions *detectSURFFeatures* and *estimateGeometricTransform*. The estimated scale and rotation is applied to the image, followed by a distortion correction. Finally, NCC is used to complete facial recognition and performance criteria is analyzed. 
