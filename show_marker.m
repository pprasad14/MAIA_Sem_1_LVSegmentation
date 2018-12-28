function [] = show_marker(I)
    for k = 1:10
        slice = I(:,:,k);

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
    mark = insertMarker(slice, [lv_center_x lv_center_y ]);

    
    subplot(2,5,k), imshow(mark), title('LV center marker');
%     subplot(1,2,2), imshow(cropped),title('Cropped Image');
    end
end

