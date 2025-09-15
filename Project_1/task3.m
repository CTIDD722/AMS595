%% Project 1 task 3
% Author: Yunpeng Chu
% Date:   2025/9/14
%
% type "[pi_est, n_iterations] = task3(precision_digits)" in Command Window

function [pi_est, n_iterations] = task3(precision_digits)
    %% Initialization
    n_inside    = 0;
    n_total     = 0;
    pi_est_prev = 0;
    pi_est      = 0;

    % Target precision (absolute error threshold)
    target_error = 0.5 * 10^(-precision_digits);

    % Record number of iterations
    iterations_per_digit = zeros(1, precision_digits);
    achieved_digits = 0;

    % Figure window
    fig = figure('Name','Monte Carlo Estimation of \pi (Dynamic)','Color','w');
    ax  = axes('Parent',fig); hold(ax,'on'); axis(ax,'square');
    xlim([0 1]); ylim([0 1]);
    xlabel('x'); ylabel('y');
    title(ax,'Estimating \pi ...');
    % Draw quarter circle arc and boundary
    t  = linspace(0,pi/2,400);
    xc = cos(t); yc = sin(t);
    plot(ax, xc, yc, 'k-', 'LineWidth', 1.5);                
    plot(ax, [0 1 1 0 0], [0 0 1 1 0], 'k-', 'LineWidth',1); 

    % Pre-create two scatter handles
    hInside = scatter(ax, NaN, NaN, 8, 'g', 'filled', 'MarkerFaceAlpha', 0.6);
    hOutside= scatter(ax, NaN, NaN, 8, 'r', 'filled', 'MarkerFaceAlpha', 0.6);
    legend(ax, 'quarter circle','unit square','inside','outside','Location','southoutside');
    VIS_WINDOW = 5e4;

    %% Start iteration
    BATCH = 1000; % Set batch size
    while achieved_digits < precision_digits
        % Generate random points
        x = rand(BATCH, 1);
        y = rand(BATCH, 1);

        % Count points inside the circle
        inside = (x.^2 + y.^2) <= 1;
        n_inside = n_inside + sum(inside);
        n_total  = n_total + numel(x);

        % Estimate π
        pi_est_prev = pi_est;
        pi_est      = 4 * n_inside / n_total;

        % Dynamic plotting
        xi = x(inside);   yi = y(inside);
        xo = x(~inside);  yo = y(~inside);

        % inside points
        Xin = [get(hInside,'XData'), xi.'];
        Yin = [get(hInside,'YData'), yi.'];
        if numel(Xin) > VIS_WINDOW
            Xin = Xin(end-VIS_WINDOW+1:end);
            Yin = Yin(end-VIS_WINDOW+1:end);
        end
        set(hInside,'XData',Xin,'YData',Yin);

        % outside points
        Xout= [get(hOutside,'XData'), xo.'];
        Yout= [get(hOutside,'YData'), yo.'];
        if numel(Xout) > VIS_WINDOW
            Xout = Xout(end-VIS_WINDOW+1:end);
            Yout = Yout(end-VIS_WINDOW+1:end);
        end
        set(hOutside,'XData',Xout,'YData',Yout);

        drawnow limitrate;

        % Check if higher precision is reached
        current_digits = achieved_digits + 1;
        if current_digits <= precision_digits
            current_error = abs(pi_est - pi_est_prev);
            if current_error < target_error && n_total > BATCH
                iterations_per_digit(current_digits) = n_total;
                achieved_digits = current_digits;
                fprintf('Iterations required to reach %d digit(s) precision: %d\n', current_digits, n_total);
            end
        end
    end

    %% Display results
    fprintf('Final estimated π (2 decimals): %.2f\n', pi_est);
    fprintf('True π: %.10f\n', pi);
    fprintf('Absolute error: %.10f\n', abs(pi_est - pi));

    % Figure annotation
    n_iterations = n_total;     
    title(ax, sprintf('\\pi_{est} = %.2f', pi_est));
end
