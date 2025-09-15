%% Project 1 task 1
% Author: Yunpeng Chu
% Date:   2025/9/14
%
% directly run it

function task1()
    %% Set different numbers of points
    n_points = round(logspace(2, 7, 50)); % 50 logarithmic intervals from 10^2 to 10^7
    pi_estimates = zeros(size(n_points));
    errors = zeros(size(n_points));
    times = zeros(size(n_points));

    % Warm up once
    dummy = rand(1000,1); 

    %% Compute π estimation under each number of points
    R = 5;  % number of repetitions
    for i = 1:length(n_points)
        n = n_points(i);

        est_r = zeros(R,1);
        err_r = zeros(R,1);
        tim_r = zeros(R,1);

        for r = 1:R
            tic;
            % Generate random points
            x = rand(n, 1);
            y = rand(n, 1);

            % Count number of points inside the circle
            inside_circle = (x.^2 + y.^2) <= 1;
            n_inside = sum(inside_circle);

            % Estimate π
            est_r(r) = 4 * n_inside / n;

            % Record time
            tim_r(r) = toc;

            % Compute error
            err_r(r) = abs(est_r(r) - pi);
        end

        % Take median
        pi_estimates(i) = median(est_r);
        errors(i)       = median(err_r);
        times(i)        = median(tim_r);
    end

    %% Plot results
    figure;

    % π estimation curve
    subplot(2, 2, 1);
    loglog(n_points, pi_estimates, 'b-', 'LineWidth', 1.5);
    hold on;
    loglog(n_points, pi*ones(size(n_points)), 'r--', 'LineWidth', 1.5);
    xlabel('Number of points');
    ylabel('\pi estimate');
    title('\pi estimate vs number of points');
    legend('Estimate', 'True value', 'Location', 'southeast');
    grid on;

    % Error curve
    subplot(2, 2, 2);
    loglog(n_points, errors, 'b-', 'LineWidth', 1.5);
    hold on;
    n_ref = [min(n_points), max(n_points)];
    e_ref = max(errors) * (n_ref/min(n_ref)).^(-1/2);   % Add reference line
    loglog(n_ref, e_ref, 'k--', 'LineWidth', 1);
    xlabel('Number of points');
    ylabel('Absolute error');
    title('Error vs number of points');
    legend('Experiment', '~ n^{-1/2}', 'Location','southwest');
    grid on;

    % Time curve
    subplot(2, 2, 3);
    loglog(n_points, times, 'b-', 'LineWidth', 1.5);
    xlabel('Number of points');
    ylabel('Computation time (s)');
    title('Computation time vs number of points');
    grid on;

    % Accuracy vs computational cost
    subplot(2, 2, 4);
    [tSort, idx] = sort(times);
    eSort = errors(idx);
    loglog(tSort, eSort, 'b-', 'LineWidth', 1.5);
    hold on;
    t0 = max(min(tSort(tSort>0)), 1e-6);
    e0 = max(errors);
    refT = [t0, max(tSort)];
    refE = e0 * (refT / t0).^(-1/2);
    loglog(refT, refE, 'k--', 'LineWidth', 1);
    xlabel('Computation time (s)');
    ylabel('Absolute error');
    title('Accuracy vs computational cost');
    legend('Experiment','~ n^{-1/2}','Location','southwest');
    grid on;

    % Adjust subplot spacing
    set(gcf, 'Position', [100, 100, 1200, 800]);

    % Print the last π estimation and true value in command window
    fprintf('Number of iterations: %d\n', n_points(end));
    fprintf('Estimated π: %.10f\n', pi_estimates(end));
    fprintf('True π: %.10f\n', pi);
    fprintf('Absolute error: %.10f\n', errors(end));
end
