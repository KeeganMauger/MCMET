run WC
subplot(2,1,1);
figure(1)
rectangle('Position',[0 0 200e-9 100e-9])
hold on
rectangle('Position',[0.8e-7 0 0.4e-7 0.4e-7])
hold on
rectangle('Position',[0.8e-7 0.6e-7 0.4e-7 0.4e-7])
hold on

%--------------------------------------------------------------------------
% Initializing Positions
%--------------------------------------------------------------------------


N = 100;        % Number of electrons
i = 0;
j = 0;

for i=1:N
    px(i) = 0 + (200e-9 - 0).*rand(1,1);
    py(i) = 0 + (100e-9 - 0).*rand(1,1);
    while (0.8e-7 <= px(i) && px(i) < 1.2e-7) && (0 <= py(i) && py(i) < 0.4e-7) ||...  %Within block
    (0.8e-7 <= px(i) && px(i) < 1.2e-7) && (0.6e-7 <= py(i) && py(i) < 1e-7)
        px(i) = 0 + (200e-9 - 0).*rand(1,1);
        py(i) = 0 + (100e-9 - 0).*rand(1,1);
    end
    subplot(2,1,1);
    plot(px(i),py(i),'b.')
    hold on
end

T = zeros(3,N);