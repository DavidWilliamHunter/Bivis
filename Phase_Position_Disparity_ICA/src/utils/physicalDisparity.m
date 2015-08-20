function [ phyDisparity, shapeChange ] = physicalDisparity( gabors, right )
% [ phyDisparity, shapeChange ] = physicalDisparity( gabors )
%
% Calculate the physical disparity between left and right gabors.
% Theory: After fitting, the left and right gabor exhibit both phase and
% position disparity. As both respresent shifts in the position of physical
% stimuli (they differ by RF window) phase and position shifts can
% interact. Here we define the 'physical' disparity as the disparity
% between left and right signals when position and phase interactions are
% accounted for. The remaining axis (orthogonal) we call the shape-change
% axis as the accounts for the differences in window position.

if nargin==2
    temp.n = gabors.n;
    temp.xc = [gabors.xc right.xc];
    temp.yc = [gabors.xc right.xc];
    temp.sigmax = [gabors.sigmax right.sigmax];
    temp.sigmay = [gabors.sigmay right.sigmay];
    temp.gtheta = [gabors.gtheta right.gtheta];
    temp.theta = [gabors.theta right.theta];
    temp.freq = [gabors.freq right.freq];
    temp.phi = [gabors.phi right.phi];
    temp.s = [gabors.s right.s];
    
    gabors = temp;
end
    
positionDisp = gaborDistance(gabors);

phaseDisp = gabors.phi(:,2) - gabors.phi(:,1);
%phaseDisp = mod(gabors.phi(:,2) - gabors.phi(:,1), 2*pi);
%phaseDisp(phaseDisp>pi) = phaseDisp(phaseDisp>pi)-(2*pi);


shapeChange = positionDisp - phaseDisp.* gabors.freq(:,1).*pi;

phyDisparity = positionDisp + phaseDisp./(gabors.freq(:,1) .*pi);

%phyDisparity = positionDisp - phaseDisp.* pi;

%shapeChange = positionDisp + phaseDisp./pi;

end

