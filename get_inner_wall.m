function [SegoutRGB] = get_inner_wall(I)
% link: https://www.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html

% Given a cropped gray image of the LV, returns the outline of inner wall
% overlapped with original cropped image

    %% finding the right threshold value using Sobel Edge operator
    [~, threshold] = edge(I, 'sobel');

    fudgeFactor = 0.5;
    BWs = edge(I,'sobel', threshold * fudgeFactor);
%     figure, imshow(BWs), title('binary gradient mask');
    
%     subplot(1,2,1), imshow(cropped), title('Cropped Image of LV');
%     subplot(1,2,2), imshow(BWs), title('Binary Gradient Mask');

    %% making our structuring elements
    se90 = strel('line', 3, 90); % for vertical line structuring element
    se0 = strel('line', 3, 0); % for horizontal line structuring element

    %% dialating the image
    BWsdil = imdilate(BWs, [se90 se0]);
%     figure, imshow(BWsdil), title('dilated gradient mask');

%     subplot(1,2,1), imshow(BWs), title('Binary Gradient Mask');
%     subplot(1,2,2), imshow(BWsdil), title('dilated gradient mask');
    
%% fill holes in image
    BWdfill = imfill(BWsdil, 'holes');
%     figure, imshow(BWdfill);
%     title('binary image with filled holes');
% 
%     subplot(1,2,1), imshow(BWsdil), title('dilated gradient mask');
%     subplot(1,2,2), imshow(BWdfill), title('binary image with filled holes');
    
    %% remove objects touching the border
    BWnobord = imclearborder(BWdfill, 4);
%     figure, imshow(BWnobord), title('cleared border image');
%     
%     subplot(1,2,1), imshow(BWdfill), title('binary image with filled holes');
%     subplot(1,2,2), imshow(BWnobord), title('cleared border image');
% 

    % BWnobord = BWdfill;
    %% structuring element diamond
    seD = strel('diamond',1);
    BWfinal = imerode(BWnobord,seD);
    BWfinal = imerode(BWfinal,seD);
%     figure, imshow(BWfinal), title('segmented image');

%     subplot(1,2,1), imshow(BWnobord), title('cleared border objects image');
%     subplot(1,2,2), imshow(BWfinal), title('segmented image');

%% remove small objects

    BWfinal_no_small = bwareaopen(BWfinal, 50);
%     figure, imshow(BWfinal_no_small), title('segmented image');
    
%     subplot(1,2,1), imshow(BWfinal), title('with small objects');
%     subplot(1,2,2), imshow(BWfinal_no_small), title('with no small objects');


%% Overlapping inner wall with original image
    BWoutline = bwperim(BWfinal_no_small);
    SegoutR = I;
    SegoutG = I;
    SegoutB = I;
    %now set yellow, [255 255 0]
    SegoutR(BWoutline) = 255;
    SegoutG(BWoutline) = 0;
    SegoutB(BWoutline) = 255;
    SegoutRGB = cat(3, SegoutR, SegoutG, SegoutB);
    
%     Segout = I; 
%     SegoutRGB(BWoutline) = 0; 
%     figure, imshow(SegoutRGB), title('outlined original image');
    
%     subplot(2,2,1), imshow(BWfinal_no_small), title('segmented image with no small objects');
%     subplot(2,2,2),  imshow(BWoutline), title('Outlined Inner Wall');
%     subplot(2,2,3),  imshow(cropped), title('original cropped image');  
%     subplot(2,2,4), imshow(SegoutRGB), title('outlined original image');

end