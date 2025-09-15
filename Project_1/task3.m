%% Project 1 task 2
% Author: Yunpeng Chu
% ID:     116720193
% Date:   2025/9/14
%
% put "[pi_est, n_iterations] = task3(precision_digits)" in Commond Window

function [pi_est, n_iterations] = task3(precision_digits)
    %% 初始化
    n_inside    = 0;
    n_total     = 0;
    pi_est_prev = 0;
    pi_est      = 0;

    % 目标精度（绝对误差阈值）
    target_error = 0.5 * 10^(-precision_digits);

    % 记录迭代次数
    iterations_per_digit = zeros(1, precision_digits);
    achieved_digits = 0;

    % 图形窗口
    fig = figure('Name','Monte Carlo Estimation of \pi (Dynamic)','Color','w');
    ax  = axes('Parent',fig); hold(ax,'on'); axis(ax,'square');
    xlim([0 1]); ylim([0 1]);
    xlabel('x'); ylabel('y');
    title(ax,'Estimating \pi ...');
    % 画四分之一圆弧与边界
    t  = linspace(0,pi/2,400);
    xc = cos(t); yc = sin(t);
    plot(ax, xc, yc, 'k-', 'LineWidth', 1.5);                
    plot(ax, [0 1 1 0 0], [0 0 1 1 0], 'k-', 'LineWidth',1); 

    % 预创建两个散点图句柄
    hInside = scatter(ax, NaN, NaN, 8, 'g', 'filled', 'MarkerFaceAlpha', 0.6);
    hOutside= scatter(ax, NaN, NaN, 8, 'r', 'filled', 'MarkerFaceAlpha', 0.6);
    legend(ax, 'quarter circle','unit square','inside','outside','Location','southoutside');
    VIS_WINDOW = 5e4;

    %% 开始迭代
    BATCH = 1000; % 设置BATCH
    while achieved_digits < precision_digits
        % 批量随机点
        x = rand(BATCH, 1);
        y = rand(BATCH, 1);

        % 计算落在圆内的点
        inside = (x.^2 + y.^2) <= 1;
        n_inside = n_inside + sum(inside);
        n_total  = n_total + numel(x);

        % 估计π值
        pi_est_prev = pi_est;
        pi_est      = 4 * n_inside / n_total;

        % 动态绘图
        xi = x(inside);   yi = y(inside);
        xo = x(~inside);  yo = y(~inside);

        % inside
        Xin = [get(hInside,'XData'), xi.'];
        Yin = [get(hInside,'YData'), yi.'];
        if numel(Xin) > VIS_WINDOW
            Xin = Xin(end-VIS_WINDOW+1:end);
            Yin = Yin(end-VIS_WINDOW+1:end);
        end
        set(hInside,'XData',Xin,'YData',Yin);

        % outside
        Xout= [get(hOutside,'XData'), xo.'];
        Yout= [get(hOutside,'YData'), yo.'];
        if numel(Xout) > VIS_WINDOW
            Xout = Xout(end-VIS_WINDOW+1:end);
            Yout = Yout(end-VIS_WINDOW+1:end);
        end
        set(hOutside,'XData',Xout,'YData',Yout);

        drawnow limitrate;

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
    fprintf(['最终估计的π值(按指定精度): ', fmt, '\n'], pi_est);
    fprintf('真实π值: %.10f\n', pi);
    fprintf('绝对误差: %.10f\n', abs(pi_est - pi));

     % 图标标注
    n_iterations = n_total;
    fmt = ['%0.', num2str(precision_digits), 'f'];      
    title(ax, sprintf('\\pi_{est} = %s', sprintf(fmt, pi_est)));
end
