function [ID, CP, HP, stardust, level, cir_center] = pokemon_stats (img, model)
% Please DO NOT change the interface
% INPUT: image; model(a struct that contains your classification model, detector, template, etc.)
% OUTPUT: ID(pokemon id, 1-201); level(the position(x,y) of the white dot in the semi circle); cir_center(the position(x,y) of the center of the semi circle)
% Replace these with your code
img1 = img;
   [x,y]=size(img1);
    %img2 = img1(x/10:x/2.4,1:y/3,:);
    img2 = img1(x/10:x/2.25,(y/15:y/4),:);
    img2 = imresize(img2,[600 600]);
      if size(img2,3)==3    
        img2 = rgb2gray(img2);   
      end
     [r c] = size(img2);
    I = reshape(img2, [r*c, 1]);

test_image_difference = double(I)-model.image_mean;

fisherImage = model.eigenvector * test_image_difference;
index =0;
min_dist = inf;

[len, y] = size(model.eigenvectorfeature);

for i=1:len
    
    eigenface = model.eigenvectorfeature(:,i);
    eigenface = eigenface-fisherImage;
    eigenface = eigenface.*eigenface;
    eigenface =sqrt(sum(eigenface));
    if(eigenface~=0 && min_dist>eigenface)
        min_dist=eigenface;
        index = i;
    end
    
end
 letter_template= model.letter_templates;
%[i,j] = Hough4circle(img);
ID = model.ID_label(index);
CP = CPdetect(img,letter_template);
HP = HPdetect(img,letter_template);
stardust = STAdetect(img,letter_template);

level = Leveldetect(img);
cir_center = centerofsemicircle(img);

end
