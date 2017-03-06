
function id =  HPdetect(img,letter_templates)
% clear all;
% load letter_templates
% img_path = './val/';
% img_dir = dir([img_path,'*CP*']);
% img_num = length(img_dir);
% same_count=0;
% for im = 1:img_num
%     img = imread([img_path,img_dir(im).name]);
%     disp(img_dir(im).name)
%img = imread('025_CP102_HP22_SD400_0149_30.jpg');
%img = imread('004_CP126_HP26_SD200_6259_22.png');
if size(img,3)==3 
   gray_img = min(img,[],3);
else
    gray_img = img;
end
gray_img = imresize(gray_img, [1000 2000]);
%imshow(gray_img);
%pause(13)
%bw_img = imbinarize(gray_img);
[x1,y1] = size(gray_img);
%image =gray_img((x1/50:x1/8),(y1/10:y1/1.2));
%image =gray_img((x1/30:x1/8),(y1/3:y1/1.6)); CP
%image =gray_img((x1/2.03:x1/1.5),(y1/2.7:y1/1.6)); 
%image =gray_img((x1/1.875:x1/1.5),(y1/2.7:y1/1.6));
image =gray_img((x1/2.5:x1/1.5),(y1/2.7:y1/1.6)); 
%image =gray_img((x1/1.9:x1/1.7),(y1/2.2:y1/1.8));
%image =gray_img((x1/1.9:x1/1.5),(y1/2.7:y1/1.6));
%  bw = bwareaopen(image,5);
%  se = strel('disk',1);
%  bw = imclose(bw,se);
%  bw = imfill(bw,'holes');
[r_image c_image] = size(image);
for rol= 1:r_image
    for col= 1:c_image
        if image(rol,col)>130
            image(rol,col)=0;
        else
            image(rol,col)=255;
        end
    end
end
%imshow(image);
%pause(5)
%bw = bwareaopen(image,2);
bw = image;
%imshow(bw);
%pause(5)

% to find the correct number after cp in the cropped Image
found_chars =[];
iteration =0;
while 1
    num_chars_here = 0;
    cropped_image_line = getnonzerocomponents(bw);
        % finding the total size of the character size
        line_size = size(cropped_image_line,1);
        for i=1:line_size
            sum_char_line = sum(cropped_image_line(i,:));
            if sum_char_line ==0
                first_line = cropped_image_line(1:i-1,:);
                 first_line1 = getnonzerocomponents(first_line);
                 rest_line = cropped_image_line(i:end,:);
                 rest_line1 = getnonzerocomponents(rest_line);
                 break;
            else
                first_line1=cropped_image_line;rest_line1=[ ];
            end
        end
    cropped_image=first_line1;
    while 1
           num_chars_here= num_chars_here+1;
        % getting the non zero element from the cropped image
        cropped_image = getnonzerocomponents(cropped_image);
        % finding the total size of the character size
        char_size = size(cropped_image,2);
        for i=1:char_size
            sum_char = sum(cropped_image(:,i));
            if sum_char ==0
                first_char = cropped_image(:,1:i-1);
                 first_char1 = getnonzerocomponents(first_char);
                 rest_char = cropped_image(:,i:end);
                 rest_char1 = getnonzerocomponents(rest_char);
                 break;
            else
                first_char1=cropped_image;rest_char1=[ ];
            end
        end
        current_char2 = imresize(first_char1,[42 24]);
        %imshow(current_char2);
        %pause(8)
        cropped_image = rest_char1;
        
         total_tem_char = size(letter_templates,2);
     mat_chars =[];
     for it = 1:total_tem_char
         mat_char = corr2(letter_templates{1,it},current_char2) ;
         mat_chars=[mat_chars mat_char];
     end
     idx = find(mat_chars==max(mat_chars));

      if idx == 1
         character_matched = 'C';
        
         elseif idx == 2
         character_matched = 'C';
         elseif idx == 3
         character_matched = 'C';
          elseif idx == 4
         character_matched = 'H';
         elseif idx == 5
         character_matched = 'P';
         
         elseif idx == 6
         character_matched = 'P';
         
         elseif idx == 7
         character_matched = 'P';
         elseif idx == 8
         character_matched = '/';         
          elseif idx == 9
         character_matched = '1';
         elseif idx == 10
         character_matched = '1';
           elseif idx == 11
         character_matched = '2';
             elseif idx == 12
         character_matched = '2';
             elseif idx == 13
         character_matched = '3';
             elseif idx == 14
         character_matched = '4';
             elseif idx == 15
         character_matched = '4';
             elseif idx == 16
         character_matched = '5';
             elseif idx == 17
         character_matched = '5';
             elseif idx == 18
         character_matched = '6';
         elseif idx == 19
         character_matched = '6';
         
         elseif idx == 20
         character_matched = '7';
         elseif idx == 21
         character_matched = '8';
          elseif idx == 22
         character_matched = '8';
         
          elseif idx == 23
         character_matched = '9';
         
          elseif idx == 24
         character_matched = '9';
         
          elseif idx == 25
         character_matched = '0';
           elseif idx == 26
         character_matched = 'H';
         else
         character_matched = ' ';
       end
    found_chars=[found_chars character_matched];
     if isempty(rest_char1)
            break;
     end
    end
      if (isempty(rest_line1)) || (~isempty(findstr(found_chars,'H')) && ~isempty(findstr(found_chars,'P'))&& ~isempty(findstr(found_chars,'/')))
       
         % if (max(idx_p) == max(idx_h)+1)
            if isempty(strtrim(found_chars)) | ~(~isempty(findstr(found_chars,'H')) && ~isempty(findstr(found_chars,'P'))&& ~isempty(findstr(found_chars,'/')))
                final_str='HP10/HP10';
            else
                final_str = found_chars;            

            end
            break;
         % end
          
          %if iteration>5000
         %     break;
         % end
          
      end
    found_chars=[];
    bw = rest_line1;
    iteration = iteration+1;
end
idx_cp =findstr(final_str,'/');
if ~isempty(findstr(final_str(1:idx_cp(1)-1),'HP'))
    id_now =(final_str(3:idx_cp(1)-1));
else
    id_now =(final_str((idx_cp(1)+1) :end-2));
end

%number= final_str((idx_cp(1)+2) :end)
%id =str2num(final_str((idx_cp(1)+2) :end));


id_numr =[];
for str =1:size(id_now,2)
    if findstr(id_now(1,str),'0987654321')>0
        id_numr = [id_numr id_now(1,str)];
    end
end
if isempty(id_numr)
    id_numr='10';
end
id =str2num((id_numr));

function im = getnonzerocomponents(com)
    [row col] = find(com);
    im = com(min(row):max(row),min(col):max(col));
