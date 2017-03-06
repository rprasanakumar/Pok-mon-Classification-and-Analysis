function level=Leveldetect(img)

    %img = imread('001_CP13_HP10_SD200_6259_10.png');
    if size(img,3)==3 
     gray_img = min(img,[],3);
    else
        gray_img = img;
    end
    [x1,y1] = size(gray_img);
    %bw_img1=imbinarize(gray_img((x1/10:x1/2.7),(10:y1)));
    %bw_img2 = imbinarize(gray_img((x1/10:x1/2.7),(10:y1)),'adaptive','ForegroundPolarity','dark','Sensitivity',0.3);
    %  bw = bwareaopen(bw_img,30);
    %  se = strel('disk',1);
    %  bw = imclose(bw,se);
    %  bw = imfill(bw,'holes');
    %bw1 =xor(bw_img1,bw_img2);  
    %imshow(bw1);
    bw1 = gray_img((x1/10:x1/2.7),(10:y1));
    [centers,radii] = imfindcircles(bw1,[4 17]); % using Hough transform for find the circle from range 4 to 17
    if size(centers,2)>0 || size(centers,1)>0
        x= centers(1,1)+10;
        y = centers(1,2)+x1/10;
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
        x = cols(size(cols,1));
        y = rows(size(rows,1));
    end
    level = [x y];
    %viscircles(centers, radii,'EdgeColor','b');
    %horiH = integralKernel([1 1 4 3; 1 4 4 3],[-1, 1]);
     %avgH = integralKernel([1 1 7 7], 1/49);
    %horiResponse = integralFilter(edge_one,avgH);
    end
