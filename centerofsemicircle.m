function centers = centerofsemicircle(img)
   %img = imread('001_CP13_HP10_SD200_6259_10.png');
    if size(img,3)==3 
     gray_img = min(img,[],3);
    else
        gray_img = img;
    end
    [x11,y11] = size(gray_img);
    gray_img = imresize(gray_img, [1000 2000]);
    %bw_img1=imbinarize(gray_img((x1/10:x1/2.7),(10:y1)));
    %bw_img2 = imbinarize(gray_img((x1/10:x1/2.7),(10:y1)),'adaptive','ForegroundPolarity','dark','Sensitivity',0.3);
    %  bw = bwareaopen(bw_img,30);
    %  se = strel('disk',1);
    %  bw = imclose(bw,se);
    %  bw = imfill(bw,'holes');
    %bw1 =xor(bw_img1,bw_img2);  
    %imshow(bw1);
    bw1 = gray_img((x11/10:x11/2.7),(10:y11));
    [centers,radii] = imfindcircles(bw1,[4 17]); % using Hough transform for find the circle from range 4 to 17
    if size(centers,2)>0 || size(centers,1)>0
        x= centers(1,1)+10;
        y = centers(1,2)+x11/10;
        % plot((centers(1,1)+10), (centers(1,2)+x1/10), 'bo');
        % pause(3);
    else
        bw_img = imbinarize(gray_img);% binary scale conversion of the image
        bw = bwareaopen(bw_img,30);% removing fewer than 30 pixel component
        se = strel('disk',5); % making a disk like component
        bw = imclose(bw,se); % finding the closest match
        bw = imfill(bw,'holes'); 
        %CC = bwconncomp(bw,8);
        edge_one = edge(bw, 'sobel',0.3); % filtering the edge
        [Gx, Gy] = imgradientxy(edge_one,'prewitt'); % using gradient for removing the vertical and horizondal elements
        edge_one=imgradient(Gx.*Gy, Gy);

        % For getting the largest connected component
        [labeledImage, numberOfBlobs] = bwlabel(edge_one);
        blobMeasurements = regionprops(labeledImage, 'area', 'Centroid');
        allAreas = [blobMeasurements.Area];

        [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
        biggestBlob = ismember(labeledImage, sortIndexes(1:2));
        binaryImage = biggestBlob > 0;
        %imshow(binaryImage);
        [rows,cols] = find(binaryImage==1);
        
        x3 = cols(size(cols,1));
        y3 = rows(size(rows,1));
        x1 = cols(1);
        y1 = rows(1);
        
        x2 = cols(3);
        y2 = rows(3);
        
        
        %slope calculation
        mr = (y2-y1)/(x2-x1);
        mt = (y3-y2)/(x3-x2);
        
        x = (((mr*mt)*(y3-y1)) +(mr*(x2+x3))-(mt*(x1+x2)))/(2*(mr-mt));
        y=-((1/mr)*(x-((x1+x2)/2))) +((y1+y2)/2);

        
        
        
    end
       y_cen = x+10;
       x_cen =y+(x/10);
       if(y_cen>0)
        y_cen = ((y11/1.85) + (y11/1.9))/2;
       end
        if(x_cen>0)
        x_cen = ((x11/3.5) + (x11/3))/2;
       end
       
        
    
    centers=[x_cen y_cen];
    
end