%% Project 1 task 2
% Author: Yunpeng Chu
% Date:   2025/9/14
%
% type "[pi_est, n_iterations] = task2(precision_digits)" in Command Window

function [pi_est, n_iterations] = task2(precision_digits)
    %% Initialization
    n_inside = 0;
    n_total = 0;
    pi_est_prev = 0;
    pi_est = 0;
    n_iterations=0;
    
    % Compute target precision (absolute error)
    target_error = 0.5 * 10^(-precision_digits);
    
    % Record the number of iterations required to achieve each precision
    iterations_per_digit = zeros(1, precision_digits);
    achieved_digits = 0;
    
    %% Start iteration
    BATCH = 1000; % Set batch size
    while achieved_digits < precision_digits
        % Generate random points
        x = rand(BATCH, 1);  % Generate 1000 points each time for efficiency
        y = rand(BATCH, 1);
        
        % Count the number of points inside the circle
        inside = (x.^2 + y.^2) <= 1;
        n_inside = n_inside + sum(inside);
        n_total = n_total + length(x);
        n_iterations = n_total;

        % Estimate π
        pi_est_prev = pi_est;
        pi_est = 4 * n_inside / n_total;
        
        % Check if a higher precision is reached
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
    fprintf('Final estimated π: %.10f\n', pi_est);
    fprintf('True π: %.10f\n', pi);
    fprintf('Absolute error: %.10f\n', abs(pi_est - pi));
    
    % Plot the relation between iterations and precision
    figure;
    plot(1:precision_digits, iterations_per_digit, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
    xlabel('Number of significant digits');
    ylabel('Required iterations');
    title('Iterations required to achieve different precisions');
    grid on;
end
