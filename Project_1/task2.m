%% Project 1 task 2
% Author: Yunpeng Chu
% ID:     116720193
% Date:   2025/9/14
%
% put "[pi_est, n_iterations] = task2(precision_digits)" in Commond Window

function [pi_est, n_iterations] = task2(precision_digits)
    %% 初始化
    n_inside = 0;
    n_total = 0;
    pi_est_prev = 0;
    pi_est = 0;
    n_iterations=0;
    
    % 计算目标精度（绝对误差）
    target_error = 0.5 * 10^(-precision_digits);
    
    % 记录达到精度的迭代次数
    iterations_per_digit = zeros(1, precision_digits);
    achieved_digits = 0;
    
    %% 开始迭代
    BATCH = 1000; % 设置BATCH
    while achieved_digits < precision_digits
        % 生成随机点
        x = rand(BATCH, 1);  % 每次生成1000个点以提高效率
        y = rand(BATCH, 1);
        
        % 计算落在圆内的点数
        inside = (x.^2 + y.^2) <= 1;
        n_inside = n_inside + sum(inside);
        n_total = n_total + length(x);
        n_iterations = n_total;

        % 估计π值
        pi_est_prev = pi_est;
        pi_est = 4 * n_inside / n_total;
        
        % 检查是否达到更高精度
        current_digits = achieved_digits + 1;
        if current_digits <= precision_digits
            current_error = abs(pi_est - pi_est_prev);
            if current_error < target_error && n_total > BATCH
                iterations_per_digit(current_digits) = n_total;
                achieved_digits = current_digits;
                fprintf('达到 %d 位有效数字所需迭代次数: %d\n', current_digits, n_total);
            end
        end
    end
    
    %% 显示结果
    fprintf('最终估计的π值: %.10f\n', pi_est);
    fprintf('真实π值: %.10f\n', pi);
    fprintf('绝对误差: %.10f\n', abs(pi_est - pi));
    
    % 绘制迭代次数与精度的关系
    figure;
    plot(1:precision_digits, iterations_per_digit, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
    xlabel('有效数字位数');
    ylabel('所需迭代次数');
    title('达到不同精度所需的迭代次数');
    grid on;
end