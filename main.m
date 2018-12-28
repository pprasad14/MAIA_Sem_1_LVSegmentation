%% Reading the time lapsed slices
a = niftiread('patient001_frame01.nii.gz');
a_uint8 = uint8(a);

for k = 3:6
    % selecting slice
    slice = a_uint8(:,:,k);

    % setting window size
    window_x = 40;
    window_y = 40;

    % coordinates of center of LV
    lv_center_x = 0;
    lv_center_y = 0;

    % to hold the max sum
    max_sum = 0;
    iter = 0;

    %% finding the coordinates of center of LV
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
    mark = insertMarker(slice, [lv_center_x lv_center_y ]);

    figure
    subplot(1,2,1), imshow(mark), title('LV center marker');
    subplot(1,2,2), imshow(cropped),title('Cropped Image');

%% Gradient

[Gmag, Gdir] = imgradient(cropped,'prewitt');
figure
imshow(Gmag, []);

Gmag_edge = edge(Gmag,'Canny');
figure
imshow(Gmag_edge);

% [Gx,Gy] = imgradientxy(cropped);
% imshowpair(Gx,Gy,'montage')
% title('Directional Gradients Gx and Gy, Using Sobel Method')


%% Otsu's thresholding:

% [counts,x] = imhist(cropped,16);
% stem(x,counts);
% T = otsuthresh(counts);
% BW = imbinarize(cropped,T);
% figure
% imshow(BW)

%% Laplce Filtering
% 
% sigma = 1.5;
% alpha = 1.5;
% 
% img_laplace = locallapfilt(cropped, sigma, alpha);
% figure
% subplot(1,2,1), imshow(cropped), title('Original');
% subplot(1,2,2),imshow(img_laplace), title('Laplacian');
%     


    %% Applying Image Smoothening
    cropped_smooth = imgaussfilt(cropped,2);
    figure
    imshow(cropped_smooth), title('Gaussian');
    
    [Gmag_gauss, Gdir_gauss] = imgradient(cropped_smooth,'prewitt');
    figure
    imshow(Gmag_gauss, []);
    
    cropped_smooth = Gmag_gauss;


    %% Applying multiple threshold levels in cropped image
    % 4 Theshold levels
    cropped_copy_thresh_4 = uint8(zeros(size(cropped_smooth,1),size(cropped_smooth,2)));
    for i = 1:size(cropped_copy_thresh_4,1)
        for j = 1: size(cropped_copy_thresh_4,2)
            if cropped_smooth(i,j) < 50
                cropped_copy_thresh_4(i,j) = 0;
            elseif cropped_smooth(i,j) < 90
                cropped_copy_thresh_4(i,j) = 100;
            elseif cropped_smooth(i,j) < 170
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
    
    cropped_copy_thresh_4_area = bwareaopen(cropped_copy_thresh_4,1950);

    
    
    figure
    subplot(2,2,1), imshow(cropped), title('Cropped');
    subplot(2,2,2), imshow(cropped_smooth,[]), title('Cropped Smooth');
    subplot(2,2,3), imshow(cropped_copy_thresh_3), title('3 Threshold levels');
    subplot(2,2,4), imshow(cropped_copy_thresh_4_area), title('4 Threshold levels');
    
    SE = strel('disk',50);
    cropped_copy_thresh_4_area_open = imopen(cropped_copy_thresh_4_area, SE);  
    imshow(cropped_copy_thresh_4_area_open);
    
%     cc = bwconncomp(cropped_copy_thresh_4_area);

    

    %% Applying Canny Edge detection

    ed_thresh3 = edge(cropped_copy_thresh_3,'Canny');
    ed_thresh4 = edge(cropped_copy_thresh_4,'Canny');

    % figure
    % subplot(2,2,1), imshow(cropped_copy_thresh_3), title('3 Threshold Levels');
    % subplot(2,2,2), imshow(ed_thresh3), title('Edges of 3 Threshold Levels');
    % subplot(2,2,3), imshow(cropped_copy_thresh_4), title('4 Threshold Levels');
    % subplot(2,2,4), imshow(ed_thresh4), title('Edges of 4 Threshold Levels');

    %% Finding Areas of different Objects and later remove ones with smaller area(<100 pixels)

    area_thresh_3 = bwareaopen(ed_thresh3,100);
    area_thresh_4 = bwareaopen(ed_thresh4,100);

    % figure
    % subplot(2,2,1), imshow(cropped_copy_thresh_3), title('3 Threshold Levels');
    % subplot(2,2,2), imshow(area_thresh_3), title('3 Threshold Levels');
    % subplot(2,2,3), imshow(cropped_copy_thresh_4), title('4 Threshold Levels');
    % subplot(2,2,4), imshow(area_thresh_4), title('4 Threshold Levels');

    %%
    %Inner wall:
    % subplot(1,3,1);
    % imshow(cropped);
    % subplot(1,3,2);
    % imshow(area_thresh_4);
    redAndBlueChannel = 255 * uint8(area_thresh_4);
    greenChannel = 255 * zeros(size(area_thresh_4), 'uint8'); % Green Everywhere.
    rgbImage_inner_outer = cat(3, redAndBlueChannel, greenChannel, redAndBlueChannel);
    % subplot(1,3,3);
    % imshow(rgbImage_inner_outer);   


    %% Displaying all info
    figure
    subplot(2,5,1), imshow(mark), title('LV center marker');
    subplot(2,5,2), imshow(cropped),title('Cropped Image');
    subplot(2,5,3), imshow(cropped_smooth), title('Cropped Smooth');
    subplot(2,5,4), imshow(cropped_copy_thresh_3), title('3 Threshold levels');
    subplot(2,5,5), imshow(cropped_copy_thresh_4), title('4 Threshold levels');
    subplot(2,5,6), imshow(ed_thresh3), title('Edges of 3 Threshold Levels');
    subplot(2,5,7), imshow(ed_thresh4), title('Edges of 4 Threshold Levels');
    subplot(2,5,8), imshow(area_thresh_3), title('3 Threshold Levels');
    subplot(2,5,9), imshow(area_thresh_4), title('4 Threshold Levels');
    subplot(2,5,10), imshow(rgbImage_inner_outer), title('Colored outline');  
end
