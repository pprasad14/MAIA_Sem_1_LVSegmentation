folder = "training";
patient_0_9 = "/patient00";
patient_10_99 = "/patient0";
ext = "_frame01.nii.gz";

for i = 1:20
    if i < 10
        file = strcat(folder,patient_0_9,string(i),patient_0_9, string(i),ext);
        a = niftiread(file);%patient001_frame01.nii.gz
        a_uint8 = uint8(a);
    else
        file = strcat(folder,patient_10_99,string(i),patient_10_99, string(i),ext);
        a = niftiread(file);
        a_uint8 = uint8(a);
    end
    figure
    for j = 2:9
        subplot(2,4,j-1), imshow(a_uint8(:,:,j));
    end
    
end

% for i = 1:10
%     subplot(2,5,i), imshow(a_uint8(:,:,i),[]), title(i);
% end