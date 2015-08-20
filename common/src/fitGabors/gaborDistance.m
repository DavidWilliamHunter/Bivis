function [ dist, orthDistance ] = gaborDistance(gabors)

    aveTheta = mod((gabors.theta(:,1) + gabors.theta(:,2))/2.0, 2*pi);
    aveTheta = [aveTheta , aveTheta]; %[ gabors.theta(:,1), gabors.theta(:,2) ] ; %[aveTheta , aveTheta];
    x = gabors.xc.*cos(-aveTheta) + gabors.yc.*sin(-aveTheta);
    y = -gabors.xc.*sin(-aveTheta)+ gabors.yc.*cos(-aveTheta);

    dist = (x(:,1)-x(:,2));
    orthDistance = (y(:,1)-y(:,2));
end