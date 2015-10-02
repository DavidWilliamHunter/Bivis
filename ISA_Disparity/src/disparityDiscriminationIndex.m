function [ ddi ] = disparityDiscriminationIndex( disparities, responses )
% Calculates the Disparity Discrimination Index in the manner of Prince et
% al. 2002

selected = isfinite(disparities) & isfinite(responses);
disparities = disparities(selected);
responses = responses(selected);
% first fit a sinusoid to the data
[xData, yData] = prepareCurveData( disparities, responses );

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

curveResponses = feval(model, disparities);

ddi = range(curveResponses(:)) ./ (range(curveResponses(:)) + 2.*gof.rmse);

end

