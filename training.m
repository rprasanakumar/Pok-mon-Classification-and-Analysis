clear all; clc; close all;


image_path = './train/';
image_dir = dir([image_path,'*HP*']);
image_size = length(image_dir);
ID_label = zeros(image_size,1);
image_vector=[];
letter_templates= load('letter_templates.mat')
for i = 1:image_size
    
    name = image_dir(i).name;
    idx = findstr(name,'_'); 
    ID_label(i) = str2double(name(1:idx(1)-1));
    img1 = imread([image_path,image_dir(i).name]);
    [x,y]=size(img1);
    %img2 = img1(x/10:x/2.4,1:y/3,:);
    img2 = img1(x/10:x/2.25,(y/15:y/4),:);
    img2 = imresize(img2,[600 600]);
      if size(img2,3)==3
        img2 = rgb2gray(img2);   
      end
     [r c] = size(img2);
    I = reshape(img2, [r*c, 1]);
    % Trying to extract features from Image and use for forming the image vector
%        name_detect = 'MetricThreshold';
%        value_detect = 100;
%        name_SURF = 'SURFSize';
%        value_SURF = 128;
%        strong_pts= 50;
%        interestingPoints= detectSURFFeatures(img2,name_detect,value_detect);
%        [feature,points] = extractFeatures(img2,interestingPoints.selectStrongest(strong_pts),name_SURF,value_SURF);
%        
%         disp(i);
%         disp(size(feature));
        image_vector=[image_vector I];
    
end
    fprintf('Done! ---> With image vector');
%%%%%%%%%%%%%%%%%%%%%%%%%%% Generate%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% the first %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% principle %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% component%%%%%%%%%%%%%%%

%Mean of all the images
image_mean = mean(image_vector,2);
fprintf('Done! ---> With image mean');
% Calculating the standard deviation of each image from the mean
[x,y] = size(image_vector);
image_sd = ones(x,y);

for i=1:image_size
    vector= double(image_vector(:,i));
    image_sd(:,i) = vector- image_mean;
end

image_cv = cov(image_sd);
[eigen_vector, eigen_value] = eig(image_cv);

% forming the Eigenvector face vector
eigenvectorfeature =[];
eigenvector = eigen_vector' * image_sd';

for i=1:image_size
        temp = eigenvector * image_sd(:,i);
        eigenvectorfeature = [eigenvectorfeature temp];
end
save('model.mat','eigenvectorfeature','eigenvector','image_mean','ID_label','letter_templates','-v7.3');
