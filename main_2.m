%% Reading the time lapsed slices
all_slices_diastole = niftiread('training/patient013/patient013_frame01.nii.gz');
a_uint8_all_slices_diastole = uint8(all_slices_diastole);

all_slices_systole = niftiread('training/patient013/patient013_frame12.nii.gz');
a_uint8_all_slices_systole = uint8(all_slices_systole);

cropped_height = 81;
cropped_width = 81;

len = 8;

% Displaying all 10 slices on single image: diastole
% figure
% for i = 1:len
%     subplot(2,len/2,i), imshow(a_uint8_all_slices(:,:,i))
% end

% Displaying all 10 slices on single image: systole
% figure
% for i = 1:len
%     subplot(2,len/2,i), imshow(a_uint8_all_slices_systole(:,:,i))
% end

%% cropped images:

all_cropped_diastole = uint8(zeros(cropped_height,cropped_width,len));
all_cropped_systole = uint8(zeros(cropped_height,cropped_width,len));

% diastole: getting all the cropped images
for i = 1:len
   all_cropped_diastole(:,:,i) = get_cropped(a_uint8_all_slices_diastole(:,:,i));
end

% systole: getting all the cropped images
for i = 1:len
   all_cropped_systole(:,:,i) = get_cropped(a_uint8_all_slices_systole(:,:,i));
end


% distole: displaying cropped images
% figure
% for i = 1:len
%    subplot(2,len/2,i), imshow(all_cropped_diastole(:,:,i)) 
% end

% systole: displaying cropped images
% figure
% for i = 1:len
%    subplot(2,len/2,i), imshow(all_cropped_systole(:,:,i)) 
% end

%% gettiing inner wall
all_inner_wall_diastole = uint8(zeros(cropped_height,cropped_width,3,len));
all_inner_wall_systole = uint8(zeros(cropped_height,cropped_width,3,len));

% diasole: getting all the inner wall segmentations images
for i = 1:len
   [all_inner_wall_diastole(:,:,:,i),~] = get_inner_wall(all_cropped_diastole(:,:,i));
end

% systole: getting all the inner wall segmentations images
for i = 1:len
   [all_inner_wall_systole(:,:,:,i),~] = get_inner_wall(all_cropped_systole(:,:,i));
end

%diastole: displaying inner-wall segmented images
figure
for i = 1:len
   subplot(2,len/2,i), imshow(all_inner_wall_diastole(:,:,:,i)),title(strcat("Slice",string(i+1))) 
end
suptitle('Diastole')

%systole: displaying inner-wall segmented images
figure
for i = 1:len
   subplot(2,len/2,i), imshow(all_inner_wall_systole(:,:,:,i)),title(strcat("Slice",string(i+1)))
end
suptitle('Systole')
