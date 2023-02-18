%% 用轮盘堵法选择新的个体
% 输入变量：pop元胞种群，fitvalue：适应度值
% 输出变量：newpop选择以后的元胞种群
function [new_pop] = selection(pop, fit_value)
%构造轮盘
[px, ~] = size(pop);
total_fit = sum(fit_value);
p_fit_value = fit_value / total_fit;
p_fit_value = cumsum(p_fit_value);    % B = cumsum(A) 从 A 中的第一个其大小不等于 1 的数组维度开始返回 A 的累积和。
% 随机数从小到大排列
ms = sort(rand(px, 1));   
fitin = 1;
newin = 1;
while newin <= px
    if(ms(newin)) < p_fit_value(fitin)
        new_pop{newin, 1} = pop{fitin, 1};
        newin = newin+1;
    else
        fitin = fitin+1;
    end
end

