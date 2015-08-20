function [ out ] = convertAbsGabor2Gabor(in, n)

    %
    % imshowScaled(cos2d(25, frequencies/12.5, phases+ cos(angles)*l*pi*(frequencies/12.5), -angles, l, 0)*3 -patches)
    %
    out = in;
    for loop = 1:size(in.phi,1)
        for innerLoop = 1:size(in.phi,2)
            theta = in.theta(loop, innerLoop);
            px = in.xc(loop, innerLoop);
            py = in.yc(loop, innerLoop);
            x =  px*cos(-theta) + py*sin(-theta);
            y = -px*sin(-theta) + py*cos(-theta);
            freq = in.freq(loop, innerLoop);
            out.phi(loop, innerLoop) = in.phi(loop, innerLoop) + x * pi * freq;
        end
    end
end