function [ rgb ] = showAnaglyph(left, right)
    rgb = zeros(size(left,1), size(left,2), 3);
    rgb(:,:,1) = left;
    rgb(:,:,3) = right;
    
    imshow(rgb);