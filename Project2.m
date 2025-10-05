clear; clc;
%% Initialization
yMin  = 0.0;
yMax  = 1.5;
xMin  = -2.0;
xMax  =  1.0;
n     = 2000;                 
range = linspace(xMin, xMax, n);

% Bisection stopping criteria
bisectMax = 40;
bisectTol = 1e-8;
yBoundary = nan(size(range));

%% Find boundary points
fprintf('[INFO] Finding boundary via bisection on %d vertical lines.\n', n);
for k  = 1:n
    x  = range(k);
    fn = indicatorFn(x);   
    s  = yMin;
    e  = yMax;
    fs = fn(s); fe = fn(e);

    if fs * fe > 0
        % Expand upper bound
        eTry = e;
        for grow = 1:6
            eTry = eTry * 1.6; 
            fe_try = fn(eTry);
            if fs * fe_try <= 0
                e = eTry; fe = fe_try;
                break;
            end
        end
    end

    % If no sign change found, mark as NaN
    if fs * fe > 0
        yBoundary(k) = nan;
        continue;
    end

    % Find the sign change point
    yBoundary(k) = bisection(fn, s, e, bisectTol, bisectMax);
end

%% Fitting interval selection
% Data cleaning
valid = ~isnan(yBoundary) & (yBoundary > 1e-6);
if ~any(valid)
    error('No valid boundary points found');
end

% Avoid scattered points
idx  = find(valid);
i1   = idx(1); 
i2   = idx(end);
xFit = range(i1:i2);
yFit = yBoundary(i1:i2);

% Remove NaN
valid2 = ~isnan(yFit);
xFit   = xFit(valid2);
yFit   = yFit(valid2);

fprintf('[INFO] Fit range: x in [%.6f, %.6f], with %d points.\n', xFit(1), xFit(end), numel(xFit));

%% Polynomial fitting 
polyOrder = 15; % As required, use a 15th-order polynomial                          
p = polyfit(xFit, yFit, polyOrder);    

% Visualization
xPlot = linspace(xFit(1), xFit(end), 2000);
yPred = polyval(p, xPlot);
figure('Color','w','Name','15th-order polynomial fit');
plot(range, yBoundary, '.', 'MarkerSize', 6);
hold on; 
grid on;
plot(xPlot, yPred, '-', 'LineWidth', 1.6);
xlabel('x'); 
ylabel('y (boundary)');
title('15th-order polynomial fit');
legend('Bisection boundary samples','15th-order polyfit','Location','best');

%% Curve length calculation
s = xFit(1);
e = xFit(end);
L = polyLen(p, s, e);
fprintf('[RESULT] Approximated boundary length over fit domain: L = %.10f\n', L);

%% imshow visualization
% Parameters
nxImg = 600;
nyImg = 400;
xImg  = linspace(xMin, xMax, nxImg);
yImg  = linspace(-1.5, 1.5, nyImg);
itImg = zeros(nyImg, nxImg, 'uint16');

for iy = 1:nyImg
    for ix = 1:nxImg
        c = xImg(ix) + 1i*yImg(iy);
        itImg(iy, ix) = fractal(c); 
    end
end

% Plot
figure('Color','w','Name','imshow');
imshow(itImg, [], 'XData', [xMin xMax], 'YData', [1.5 -1.5]); 
axis on;
colormap(parula); 
colorbar; 
xlabel('Re'); 
ylabel('Im');
title('Iteration counts');
hold on;
mask_u = ~isnan(yBoundary) & (yBoundary>=0);
plot(range(mask_u), yBoundary(mask_u), 'k.', 'MarkerSize', 3);

%% Function: it = fractal()
function it = fractal(c)
    maxIter = 100; % Maximum number of iterations
    z = 0 + 0i;
    for k = 1:maxIter
        z = z*z + c;
        if abs(z) > 2.0
            it = k;  
            return;
        end
    end
    it = 0; 
end

%% Function: m = bisection()
function m = bisection(fnF, s, e, tol, maxIter)
    fs = fnF(s);
    fe = fnF(e);

    % Check for exceptions
    if fs == 0
        m = s;
        return;
    elseif fe == 0
        m = e;
        return;
    elseif fs * fe > 0
        error('bisection: invalid bracketing.');
    else
        for it = 1:maxIter
            m = 0.5 * (s + e);
            fm = fnF(m);
            if fm == 0 || abs(e - s) < tol % Check if hits exact boundary or converged
                return;
            elseif fs * fm <= 0
                e = m;
                fe = fm;
            else
                s = m;
                fs = fm;
            end
        end
        m = 0.5 * (s + e);
    end
end

%% Function: l = polyLen()
function l = polyLen(p, s, e)
    dp = polyder(p);  
    ds = @(x) sqrt( 1 + (polyval(dp, x)).^2 );
    l = integral(ds, s, e, 'RelTol',1e-9, 'AbsTol',1e-12);
end

%% Derivative function
function dp = polyder(p)
    n = numel(p) - 1;        
    if n <= 0
        dp = 0;
        return;
    end
    dp = zeros(1, n);
    for k = 1:n
        dp(k) = (numel(p)-k) * p(k);
    end
end

%% Indicator function generator 
function fn = indicatorFn(x)
    fn = @(y) (fractal(x + 1i*y) > 0) * 2 - 1;
end
