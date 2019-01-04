function [] = discontinuity(a)
%% storing slice
% slice = a(:,:,5);
slice = a;
% slice = cropped;
smooth_slice = zeros(size(slice,1), size(slice,2), 'int16');

for i = 2 : size(slice,1)-1
    for j = 2 : size(slice,2)-1
        
        top = slice(i-1 , j);
        bottom = slice(i+1, j);
        left = slice(i, j-1);
        right = slice(i, j+1);
        
        top_left = slice(i-1, j-1);
        top_right = slice(i-1, j+1);
        bottom_left = slice(i+1, j-1);
        bottom_right = slice(i+1, j+1);
        
        
        E_H_xy = abs(left - right);
        E_V_xy = abs(top - bottom);
        E_D_xy = abs(top_left - bottom_right);
        E_C_xy = abs(top_right - bottom_left);
        
        E_xy = (E_H_xy + E_V_xy + E_D_xy + E_C_xy)/4;
        
        smooth_slice(i,j) = E_xy;
    end
end

%% Displaying result of smoothening:

subplot(1,2,1), imshow(slice,[]), title('Original Slice');
subplot(1,2,2), imshow(smooth_slice,[]), title('Local Discontinuities of Slice');
end

