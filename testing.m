%% Reading the time lapsed slices
a = niftiread('patient001_frame01.nii.gz');
a2 = niftiread('patient002_frame01.nii.gz');

a_uint8 = uint8(a);
a2_uint8 = uint8(a2);

imshow(a_uint8(:,:,5))
figure 
imshow(a_uint8(:,:,3))


%% Displaying all the 10 slices individually
for i = 1:10
    figure
imshow(a(:,:,i),[])
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

for i = 1:10
    mark = insertMarker(a2_uint8(:,:,i), [lv_center_x lv_center_y ],'o','color', 'green', 'size',5);
    subplot(2,5,i),imshow(mark);
end


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

cropped = imcrop(slice, [lv_center_x - window_x  lv_center_y - window_y  window_x*2  window_y*2] );
figure
imshow(cropped),title('Cropped Image');
mark = insertMarker(slice, [lv_center_x lv_center_y ]);
figure
imshow(mark), title('LV center marker');

% 
% %sample image:
% im = a(:,:,5);
% ed = edge(im,'Canny');
% 
% subplot(1,2,1), imshow(im,[]);
% subplot(1,2,2), imshow(ed);