%% Reading the time lapsed slices
a = niftiread('patient023_frame01.nii.gz');
a_uint8 = uint8(a);

% a2 = niftiread('patient004_frame01.nii.gz');
% a2_uint8 = uint8(a2);
% 
% a3 = niftiread('patient012_frame01.nii.gz');
% a3_uint8 = uint8(a3);
% 
% a_uint8 = a;
% a_uint8 = a2_uint8;
% a_uint8 = a3_uint8;

cropped_height = 81;
cropped_width = 81;

len = 8;

%% Displaying all 10 slices on single image
% figure
% for i = 1:len
%     subplot(2,len/2,i), imshow(a_uint8(:,:,i))
% end

%% cropped images:

all_cropped = uint8(zeros(cropped_height,cropped_width,len));

% getting all the cropped images
for i = 1:len
   all_cropped(:,:,i) = get_cropped(a_uint8(:,:,i));
end
 
%displaying cropped images
% figure
% for i = 1:len
%    subplot(2,len/2,i), imshow(all_cropped(:,:,i)) 
% end

%% gettiing inner wall
all_inner_wall = uint8(zeros(cropped_height,cropped_width,3,len));

% getting all the inner wall segmentations images
for i = 1:len
   all_inner_wall(:,:,:,i) = get_inner_wall(all_cropped(:,:,i));
end

%displaying inner-wall segmented images
figure
for i = 1:len
   subplot(2,len/2,i), imshow(all_inner_wall(:,:,:,i)) 
end