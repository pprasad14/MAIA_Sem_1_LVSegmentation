%% Reading the time lapsed slices
a = niftiread('patient001_frame01.nii.gz');
a2 = niftiread('patient002_frame01.nii.gz');

a_uint8 = uint8(a);
a2_uint8 = uint8(a2);

% figure
% imshow(a_uint8(:,:,5))
% figure 
% imshow(a_uint8(:,:,3))


%% Displaying all the 10 slices individually
for i = 1:10
    figure
imshow(a(:,:,i),[])
pause(0.5)
end

for i = 1:10
imshow(a2_uint8(:,:,i),[])
pause(0.5)
end

%% Displaying all 10 slices on single image
for i = 1:10
    subplot(2,5,i), imshow(a(:,:,i),[])
end

for i = 1:10
    subplot(2,5,i), imshow(a_uint8(:,:,i),[])
end

for i = 1:10
    subplot(2,5,i), imshow(a2_uint8(:,:,i),[]); 
end

% for i = 1:10
%     mark = insertMarker(a2_uint8(:,:,i), [lv_center_x lv_center_y ],'o','color', 'green', 'size',5);
%     subplot(2,5,i),imshow(mark);
% end


%% Find region of left ventricle to reduce the computation
% using window size ( 60 , 60 ) and finding point around which maximum sum is
% found

slice = a_uint8(:,:,5);

window_x = 40;
window_y = 40;

lv_center_x = 0;
lv_center_y = 0;
max_sum = 0;
iter = 0;
% kernel = ones(60);

for i = window_y + 1 : size(slice,1) - window_y - 2
    for j = window_x + 1 : size(slice,2) - window_x - 2
        %60,60 window to find the sum
        temp_matrix = slice(i - window_y/2 : i + window_y/2 - 1 , j - window_x/2 : j + window_x/2 - 1);
        if sum(sum(temp_matrix)) > max_sum
            max_sum = sum(sum(temp_matrix));
            lv_center_x = j;
            lv_center_y = i;
        end
    end
    iter = iter + 1;
end

% cropped = imcrop(slice, [lv_center_x - 1.5*window_x  lv_center_y - 1.5*window_y  window_x*2.5  window_y*2.5] );
cropped = imcrop(slice, [lv_center_x - window_x  lv_center_y - window_y  window_x*2  window_y*2] );
figure
subplot(1,2,1), imshow(mark), title('LV center marker');
mark = insertMarker(slice, [lv_center_x lv_center_y ]);
subplot(1,2,2), imshow(cropped),title('Cropped Image');

%% Applying Image Smoothening
for i = 1:4
    cropped_smooth = imgaussfilt(cropped,i);
    subplot(2,2,i),
    imshow(cropped_smooth), title(strcat('Gausian Filter: k =  ', string(i)));
end

%% Applying multiple threshold levels in cropped image

% 4 Theshold levels
cropped_copy_thresh_4 = uint8(zeros(size(cropped_smooth,1),size(cropped_smooth,2)));
for i = 1:size(cropped_copy_thresh_4,1)
    for j = 1: size(cropped_copy_thresh_4,2)
        if cropped_smooth(i,j) < 50
            cropped_copy_thresh_4(i,j) = 0;
        elseif cropped_smooth(i,j) < 125
            cropped_copy_thresh_4(i,j) = 75;
        elseif cropped_smooth(i,j) < 200
            cropped_copy_thresh_4(i,j) = 150;
        else
            cropped_copy_thresh_4(i,j) = 255;
        end
    end
end

% 3 Threshold levels
cropped_copy_thresh_3 = uint8(zeros(size(cropped_smooth,1),size(cropped_smooth,2)));
for i = 1:size(cropped_copy_thresh_3,1)
    for j = 1: size(cropped_copy_thresh_4,2)
        if cropped_smooth(i,j) < 50
            cropped_copy_thresh_3(i,j) = 0;
        elseif cropped_smooth(i,j) < 150
            cropped_copy_thresh_3(i,j) = 100;
        else
            cropped_copy_thresh_3(i,j) = 200;
        end
    end
end
figure
subplot(2,2,1), imshow(cropped), title('Cropped');
subplot(2,2,2), imshow(cropped_smooth), title('Cropped Smooth');
subplot(2,2,3), imshow(cropped_copy_thresh_3), title('3 Threshold levels');
subplot(2,2,4), imshow(cropped_copy_thresh_4), title('4 Threshold levels');

%% 

ed_thresh3 = edge(cropped_copy_thresh_3,'Canny');
ed_thresh4 = edge(cropped_copy_thresh_4,'Canny');

figure
subplot(2,2,1), imshow(cropped_copy_thresh_3), title('3 Threshold Levels');
subplot(2,2,2), imshow(ed_thresh3), title('Edges of 3 Threshold Levels');
subplot(2,2,3), imshow(cropped_copy_thresh_4), title('4 Threshold Levels');
subplot(2,2,4), imshow(ed_thresh4), title('Edges of 4 Threshold Levels');
            
%% Finding Areas of different Objects and later remove ones with smaller area

area_thresh_3 = bwareaopen(ed_thresh3,100);
area_thresh_4 = bwareaopen(ed_thresh4,100);

            
            
            
            
            
            
            
            
            
            
            
            