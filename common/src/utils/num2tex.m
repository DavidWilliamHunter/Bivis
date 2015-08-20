function [ tex ] = num2tex(varargin)
% [ tex ] = num2tex(number)
% [ tex ] = num2tex(format, number)
% [ tex ] = num2tex(number, unitValue)
% [ tex ] = num2tex(number, unitSymbol, unitValue)
% [ tex ] = num2tex(format, number, unitValue)
%
%  Converts a number to a latex formated fractional number
% inputs:
%    format (chars) the SPRINTF format to use to format the number.
%       Formating expects to find two (and only two) number formats, the first
%       representing the numerator the second the denominator.
%    number [matrix of] floating point values to format.
%    unitSymbol (string) a latex formated symbol to use as the unit
%       totally over-ridden if a format is specified.
%    unitValue a value to divide the input number by prior to formating,
%               stands in for a unit size (e.g. pi)
%
%   defaults:   format - '$\frac{%d%s}{%d}$'
%               unitValue - 1
%

%defaults
inputs.format = [];
inputs.unitSymbol = '';
inputs.unitValue = 1;

% process inputs
if nargin<1
    error('Not enough inputs, see help num2tex for details');
end

if isstruct(varargin{1})
    inputs = varargin{1};
else
    
    if ischar(varargin{1})
        inputs.format = varargin{1};
        expectedNumberPosition = 2;
    else
        expectedNumberPosition = 1;
    end
    
    if nargin<expectedNumberPosition
        error('A numerical input is expected after a inputs.format definition. See help num2tex for details.')
    end
    
    if ~isnumeric(varargin{expectedNumberPosition})
        error('A numerical input is expected');
    end
    
    inputs.number = varargin{expectedNumberPosition};
    if nargin > expectedNumberPosition
        if ischar(varargin{expectedNumberPosition+1})
            inputs.unitSymbol = varargin{expectedNumberPosition+1};
            expectedUnitValuePosition = expectedNumberPosition+2;
        else
            expectedUnitValuePosition = expectedNumberPosition+1;
        end
        
        if nargin >= expectedUnitValuePosition
            inputs.unitValue = varargin{expectedUnitValuePosition};
        end
    end
    
end
%%
%
if ~isscalar(inputs.number)
    if iscell(inputs.number)
        tex = cell(size(inputs.number));
        for loop = 1:numel(tex)
            passThrough = inputs;
            passThrough.number = inputs.number{loop};
            tex{loop} = num2tex(passThrough);
        end
        return;
    elseif ismatrix(inputs.number)
        tex = cell(size(inputs.number));
        for loop = 1:numel(tex)
            passThrough = inputs;
            passThrough.number = inputs.number(loop);
            tex{loop} = num2tex(passThrough);
        end
        return;
    end
else
    
    [ numerator , denominator ] = rat(inputs.number./inputs.unitValue);
    
    if ~isempty(inputs.format)
        tex = sprintf(inputs.format, numerator, denominator);
        return;
    end
    
    if numerator < 0
        signText = '-';
        numerator = abs(numerator);
    else
        signText = [];
    end
    
    if isfinite(numerator)
        if (numerator==1 || numerator==-1) && ~isempty(inputs.unitSymbol)
            numeratorText = inputs.unitSymbol;
        elseif numerator==0
            numeratorText = sprintf('\\mathbf{%d}', numerator);
        else
            numeratorText = sprintf('\\mathbf{%d%s}', numerator, inputs.unitSymbol);
        end
    else
        if isinf(numerator)
            numeratorText = '\infty';
        elseif isnan(numerator)
            numeratorText = 'NaN';
        end
    end
    
    if isfinite(denominator)
        denominatorText = sprintf('\\mathbf{%d}', denominator);
    else
        if isinf(denominator)
            denominatorText = '\infty';
        elseif isnan(denominator)
            denominatorText = 'NaN';
        end
    end
    
    if denominator~=1
        tex = sprintf('$%s\\frac{%s}{%s}$', signText, numeratorText, denominatorText);
    else
        tex = sprintf('$%s%s$', signText, numeratorText);
    end
end

end