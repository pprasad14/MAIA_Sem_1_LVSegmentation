all_slices_gt = niftiread('training/patient013/patient013_frame12_gt.nii.gz');
% a_uint8_all_slices = uint8(all_slices_gt);
all_slices_found = niftiread('training/patient013/patient013_frame12.nii.gz');
a_uint8_all_slices_found = uint8(all_slices_found);

len = 8;
cropped_height = 81;
cropped_width = 81;

% displaying the ground truth slices
figure
for i = 2: len
    subplot(2,len/2,i-1), imshow(all_slices_gt(:,:,i),[]);
end

%% getting the cropped of the Ground Truth

all_cropped_gt = (zeros(cropped_height,cropped_width,len));

for i = 2:len
    sample_gt_slice = all_slices_gt(:,:,i);
%     figure, imshow(sample_gt_slice,[])
   gt_cropped_slice = get_cropped(sample_gt_slice);
%    figure, imshow(gt_cropped_slice,[])
   maximum_intensity = max(max(gt_cropped_slice));
   gt_cropped_slice_thresh = gt_cropped_slice > (maximum_intensity-1);
    all_cropped_gt(:,:,i-1) = gt_cropped_slice_thresh;
end

%displaying Ground Truth cropped images
figure
for i = 1:len
   subplot(2,len/2,i), imshow(all_cropped_gt(:,:,i)) 
end

%% getting all the cropped images
all_cropped_found = uint8(zeros(cropped_height,cropped_width,len));

%cropping the given slices
for i = 2:len
   [all_cropped_found(:,:,i-1)] = get_cropped(a_uint8_all_slices_found(:,:,i));
end
 
%displaying cropped images
% figure
% for i = 1:len
%    subplot(2,len/2,i), imshow(all_cropped_found(:,:,i)) 
% end

%% getting the masks of the cropped slices:

all_mask_cropped = (zeros(cropped_height,cropped_width,len));

for i = 1:len
%     [~,all_mask_cropped(:,:,i)] = get_inner_wall(all_cropped_found(:,:,i));

    [~,temp] = get_inner_wall(all_cropped_found(:,:,i));
    se = strel('disk',10);
    imclosed_temp = imclose(temp,se);
%     figure, imshow(imclosed_temp);
   [all_mask_cropped(:,:,i)] = imclosed_temp;

end

% displaying found masks:
figure
for i = 1:len
   subplot(2,len/2,i), imshow(all_mask_cropped(:,:,i)) 
end

%% getting the Dice index 
 
    %check if mask is present in all_mask_cropped
   
    similartiy = zeros(1,len);

    for i = 1: len
        if (max(max(all_mask_cropped(:,:,i)))) == 0
            similarity(1,i) = -1;
        else
            similarity(1,i) = dice(all_mask_cropped(:,:,i), all_cropped_gt(:,:,i));
        end
    end
    
 %% plotting the results:
 
 figure
for i = 1:len
   subplot(2,len/2,i), imshow(all_mask_cropped(:,:,i)), title(string(similarity(1,i))) 
end

mean_dice_index = mean(similarity(similarity > 0.5));
 


