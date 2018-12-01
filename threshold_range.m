function [ O ] = threshold_range(I, low, high)

O = I;

for i = size(I,1)
    for j = size(I,2)
        if I(i,j) < low || I(i,j) > high
            O(i,j) = 255;
        end
    end
end
% O = int16(O);
end