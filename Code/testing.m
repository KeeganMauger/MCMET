run WC
r = 20;
xCenter = 30;
yCenter = 10;
angles = linspace(0, 2*pi, 1000);
center = [xCenter yCenter];
x1=center(1)+r*cos(angles);
y1=center(2)+r*sin(angles);
plot(x1,y1, 'k-','LineWidth', 3)
hold on;
plot(xCenter, yCenter, 'r+', 'MarkerSize', 250, 'LineWidth', 2)
axis equal
grid on;
% Make line
xLine1 = xCenter + r;
yLine1 = yCenter - 2 * r;
xLine2 = x1(end-100);
yLine2 = y1(end-100);
line([xLine1, xLine2], [yLine1, yLine2], 'Color', 'r', 'LineWidth', 3);
line([xCenter, xLine2], [yCenter, yLine2], 'Color', 'r', 'LineWidth', 3);