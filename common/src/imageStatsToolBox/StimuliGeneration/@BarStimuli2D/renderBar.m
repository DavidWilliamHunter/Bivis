function ret = renderBar(imgSize, width, position, orientation)
    [ X, Y ] = meshgrid(1:imgSize(1)*20, 1:imgSize(2)*20);
    
    X = X-imgSize(1)*10;
    Y = Y-imgSize(2)*10;
    
    X = X.*cos(orientation) - Y.*sin(orientation);
    Y = X.*sin(orientation) + Y.*cos(orientation);
    
    temp = abs(X-position.*10);
    
    temp = temp-(width*5);
    ret = zeros(size(temp));
    ret(temp<0) = 1;
    
    ret = imresize(ret, 0.1, 'bicubic');
    ret = ret( (1:imgSize(1)) + round(position*imgSize(1)), (1:imgSize(2))+floor(imgSize(2)/2));
end
    
    