%创建具有障碍物的栅格地图
%矩阵中1代表黑色栅格
function Grid = DrawMap(Grid)
b = Grid;
b(end+1,end+1) = 0;
colormap([1 1 1;0 0 0]);  % 创建颜色
pcolor(0.5:size(Grid,2) + 0.5, 0.5:size(Grid,1) + 0.5, b); % 赋予栅格颜色
set(gca, 'XTick', 1:size(Grid,1), 'YTick', 1:size(Grid,2));  % 设置坐标
axis image xy;  % 沿每个坐标轴使用相同的数据单位，保持一致
