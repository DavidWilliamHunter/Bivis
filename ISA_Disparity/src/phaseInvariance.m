function [ inv ] = phaseInvariance( phases, responses )
% inv = phaseInvariance( phases, responses )
%
% measures the invariance of the feature to phase

selected = isfinite(phases) & isfinite(responses);
phases = phases(selected);
responses = responses(selected);
% first fit a sinusoid to the data
[xData, yData] = prepareCurveData( phases, responses );

% Set up fittype and options.
fitfunc = sprintf('(a*sin(b.*x + c)+ d).*%d', range(responses));
ft = fittype( fitfunc, 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf -Inf];
opts.StartPoint = [0.959970951086723 0.168493777390473 0.208127883351024 0.159381836850475];
opts.Upper = [Inf Inf Inf Inf];

% Fit model to data.
[model, gof] = fit( xData, yData, ft, opts );

% log likelihood of sinusoid
curveResponses = feval(model, xData);

sloglik = sum((curveResponses - yData).^2./gof.rmse);
nullloglik = sum((yData - mean(yData(:))).^2./var(yData(:)));

% mlogLik = 1;

inv = sloglik; %2.*(sloglik - nullloglik);

end

