% 将必经节点联结成无间断路径，如果结点间不连续，则插入节点使其连续。
function [single_new_pop] = generate_continuous_path(single_pop, Grid, x)
i = 1;
single_new_pop = single_pop;  %传入的某行的初始路径，有20个路径节点
[~, single_path_num] = size(single_new_pop);
%遍历该行的所有节点，使其连续
while i ~= single_path_num
%%定位第i、i+1个节点的坐标
    % 路径中第i个栅格在地图的列（从左到右编号1.2.3...）
    column_now = mod(single_new_pop(1, i), x) + 1; 
    % 路径中第i个栅格在地图的行（从上到下编号行1.2.3...）
    row_now = fix(single_new_pop(1, i) / x) + 1;
    % 路径中第i+1个栅格在地图的列、行
    column_next = mod(single_new_pop(1, i + 1), x) + 1;
    row_next = fix(single_new_pop(1, i + 1) / x) + 1;
    
    % 初始化最大迭代次数
    max_iteration = 0;
    
    %% 判断点i和i+1是否连续,若不连续插入值(如果前后两节点的X坐标与Y坐标的差中较大值不等于1，说明不连续)
while max(abs(column_next - column_now), abs(row_next - row_now)) ~= 1
%取两节点的中点作为插入点,见forGA_word.xls-sheet1
%插入点的横坐标 x_insert，纵坐标 y_insert
        x_insert = floor((column_next + column_now) / 2);%Y = floor(X) 将 X 的每个元素四舍五入到小于或等于该元素的最接近整数。
        y_insert = floor((row_next + row_now) / 2);
        
        % 插入栅格为自由栅格
        if Grid(y_insert, x_insert) == 0  
            % 插入的栅格序号
            num_insert = (x_insert - 1) + (y_insert - 1) * x;
            % 插入新序号（将当前的栅格序号中间插入一个新栅格序号 其他保持不变）
            single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
            
        % 插入栅格为障碍物栅格
        else   
            % 往左走(如果当前待插入格（障碍物格)的左邻格不是障碍物 且 左邻格不是当前研究的两个格中任意一个)
            if Grid(y_insert, x_insert - 1) == 0 && ((x_insert - 2) + (y_insert - 1) * x ~= single_new_pop(1, i)) && ((x_insert - 2) + (y_insert - 1) * x ~= single_new_pop(1, i+1))
                x_insert = x_insert - 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
                               
            % 往右走 (如果当前待插入格（障碍物格)的右邻格不是障碍物 且 右邻格不是当前研究的两个格中任意一个)   
            elseif Grid(y_insert, x_insert + 1) == 0 && (x_insert + (y_insert - 1) * x ~= single_new_pop(1, i)) && (x_insert + (y_insert - 1) * x ~= single_new_pop(1, i+1))
                x_insert = x_insert + 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
                
            % 向上走
            elseif Grid(y_insert + 1, x_insert) == 0 && ((x_insert - 1) + y_insert * x ~= single_new_pop(1, i)) && ((x_insert - 1) + y_insert * x ~= single_new_pop(1, i+1))
                y_insert = y_insert + 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
 
            % 向下走
            elseif  Grid(y_insert - 1, x_insert) == 0 && ((x_insert - 1) + (y_insert - 2) * x ~= single_new_pop(1, i)) && ((x_insert - 1) + (y_insert-2) * x ~= single_new_pop(1, i+1))
                y_insert = y_insert - 1;
                % 栅格序号
                num_insert = (x_insert - 1) + (y_insert - 1) * x;
                % 插入新序号
                single_new_pop = [single_new_pop(1, 1:i), num_insert, single_new_pop(1, i+1:end)];
                
            % 如果各方向都无法插入则舍去此路径
            else
                %break_pop = single_new_pop
                single_new_pop = [];
                break
            end    
        end
        
        column_next = x_insert;
        row_next = y_insert;
        max_iteration = max_iteration + 1;
%如果可以不断的增加新节点，但增加次数超过20000次，则舍弃此路径
        if max_iteration > 20000
            single_new_pop = [];
            break
        end
        
    end
    
    if isempty(single_new_pop)
        break
    end
    
    [~, single_path_num] = size(single_new_pop);
    i = i + 1;
end
