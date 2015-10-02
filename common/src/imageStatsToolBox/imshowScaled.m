function [] = imshowScaled(img)
    imshow(img, [min(min(img)), max(max(img))]);
end