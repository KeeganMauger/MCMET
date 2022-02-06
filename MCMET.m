%% ELEC 4700 Assignment 1
%%% Monte-Carlo Modeling of Electron Transport
% Keegan Mauger
% 101042551

%% Section 1: Electron Modeling
% To initialize the model, constants and a general region are created. The
% electrons are given an effective mass, and will act as carriers in an
% N-type Si semiconductor crystal. The region is to be modeled as a
% rectangle with dimensions of 200nm x 100nm, while the electrons have an
% effective mass of $0.26m_n$.
% Assuming the temperature of the block is 300K, the thermal velocity was
% calculated to be $vth = 1.8702e-5 m/s$, and using this, and the given      
% mean time between collisions of 0.2ps, the mean free path was calculated
% as $MFP = 3.7404e-8 m$, or 37.404nm.
% 
% A program was written to model the random motion of electrons. At the
% start of the program, each electron is given a random direction, with
% fixed velocity. The electrons reflect off of the y-axis bounds, and are
% transported to the opposite x-axis border should they connect with one of
% the two x-axis limits.
%
% The program produces two plots. The first is a plot of the movements for
% a subset of electrons, showcasing the random directions and reflections.
% The second plot shows the mean temperature of all electrons. As the
% electrons were all given a fixed temperature (300K), this mean
% temperature also remains fixed at 300K, indicating the expected results.

% Initialization
set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',10)
set(0,'defaultaxesfontname','Times New Roman')
set(0,'DefaultLineLineWidth', 0.5);

run WC
global C

C.q_0 = 1.60217653e-19;             % electron charge
C.hb = 1.054571596e-34;             % Dirac constant
C.h = C.hb * 2 * pi;                % Planck constant
C.m_0 = 9.10938215e-31;             % electron mass
C.kb = 1.3806504e-23;               % Boltzmann constant
C.eps_0 = 8.854187817e-12;          % vacuum permittivity
C.mu_0 = 1.2566370614e-6;           % vacuum permeability
C.c = 299792458;                    % speed of light
C.g = 9.80665;                      % metres (32.1740 ft) per s²
C.m_n = 0.26 * C.m_0;               % effective electron mass
C.am = 1.66053892e-27;              % atomic mass unit
C.T = 300;                          % temperature

% Mean free path and thermal velocity
Tmn = 0.2e-12;
vth = sqrt(2*C.kb * C.T / C.m_n);
MFP = vth*Tmn;


subplot(2,1,1);
rectangle('Position',[0 0 200e-9 100e-9])
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
end

% Thermal Velocity and Direction

for j=1:N
    v0(j) = vth;                                % Velocity of electron
    theta(j) = 0 + (360 - 0).*rand(1,1);        % Angle of electron
    if theta(j) == 360
        theta(j) = 0;
    end
    vx(j) = v0(j)*cos(theta(j));                % Velocity in x axis
    vy(j) = v0(j)*sin(theta(j));                % Velocity in y axis
end
% 

%--------------------------------------------------------------------------
% Updating particle locations using velocity and angle
%--------------------------------------------------------------------------
% Want to choose a time step so that an electron can cover 1/100th of the
% region in that time
% starting velocity = 1.3224e5 m/s
% spacial step = 100e-9/100 = 100e-11 m
% so time step will be 1.3224e14 steps/s
% or 7.56e-15 s/step, approximate to 1e-14 s/step


t = 0;
T(1) = 0;
dt = 1e-14;     % time step
px_prev = 0;
py_prev = 0;
T_prev = 0;

sampleidx = randi(N,10,1);
figure(1)
for t=2:100
    for k=1:N
        px_prev(k) = px(k);
        px(k) = px(k) + vx(k)*dt;
        py_prev(k) = py(k);
        py(k) = py(k) + vy(k)*dt;
        
        if py(k) >= 100e-9 || py(k) <= 0
            [theta(k),vx(k),vy(k)] = SpecRef(theta(k),vx(k),vy(k));
            if py(k) >= 100e-9
                py(k) = 100e-9;
            elseif py(k) <= 0
                py(k) = 0;
            end
        end
        if px(k) >= 200e-9
            px(k) = 0;
            px_prev(k) = px(k);
        elseif px(k) <= 0
            px(k) = 200e-9;
            px_prev(k) = px(k);
        else
            px(k) = px(k);
        end
        
        v(k) = sqrt(vx(k)^2 + vy(k)^2);
        v2(k) = v(k).*v(k);
        
    end
    for h=1:length(sampleidx)
        subplot(2,1,1);
        plot([px_prev(sampleidx(h)) px(sampleidx(h))],[py_prev(sampleidx(h)) py(sampleidx(h))],'SeriesIndex',h)
        hold on 
    end
    
    KE = 0.5 * C.m_n * mean(v2);
    T_prev = T;
    T = KE /C.kb;
    subplot(2,1,2);
    plot([t-1 t], [T_prev T],'r')
    hold on
    
    pause(0.001)
end


subplot(2,1,1);
title('Random Movements of Electrons')
xlabel('Region Width (m)')
ylabel('Region Height (m)')
subplot(2,1,2);
title('Mean Temperature over Time')
xlabel('Timesteps (1e-14 s per step)') 
ylabel('Temperature (K)')

disp('Section 1')
fprintf('\nThe thermal velocity is %f meters per second.',vth)
fprintf('\nThe mean free path is %f nanometers.\n',MFP*1e9)

%%% All requirements met.


%% Section 2: Collisions with Mean Free Path
% Modifying the code of Section 1, each starting electron is given a
% randomized vecolcity for its x and y components using a
% Maxwell-Boltzmann distribution.
%
% The average velocity was calculated to ensure the result would
% approximate the thermal velocity vth, and velocity distribution of all
% electrons were displayed in a histograph to show a proper
% Maxwell-Boltzmann distribution.
%
% Additionally, the scattering of electrons through collision was modeled
% as a probability of scattering at each time step. Should the electron
% scatter, its velocity would be changed to a new value using the M-B
% distributions.


% Initialization
set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaultaxesfontsize',20)
set(0,'defaultaxesfontname','Times New Roman')
set(0,'DefaultLineLineWidth', 0.5);

close all
clear all
global C

C.q_0 = 1.60217653e-19;             % electron charge
C.hb = 1.054571596e-34;             % Dirac constant
C.h = C.hb * 2 * pi;                % Planck constant
C.m_0 = 9.10938215e-31;             % electron mass
C.kb = 1.3806504e-23;               % Boltzmann constant
C.eps_0 = 8.854187817e-12;          % vacuum permittivity
C.mu_0 = 1.2566370614e-6;           % vacuum permeability
C.c = 299792458;                    % speed of light
C.g = 9.80665;                      % metres (32.1740 ft) per s²
C.m_n = 0.26 * C.m_0;               % effective electron mass
C.am = 1.66053892e-27;              % atomic mass unit
C.T = 300;
C.vth = sqrt(2*C.kb * C.T / C.m_n);


temp = C.T;

subplot(2,1,1);
figure(1)
rectangle('Position',[0 0 200e-9 100e-9])
hold on

%--------------------------------------------------------------------------
% Initializing Positions
%--------------------------------------------------------------------------


N = 1000;        % Number of electrons
i = 0;
j = 0;

for i=1:N
    px(i) = 0 + (200e-9 - 0).*rand(1,1);
    py(i) = 0 + (100e-9 - 0).*rand(1,1);
%     subplot(2,1,1);
%     plot(px(i),py(i),'b.')
%     hold on
end

%--------------------------------------------------------------------------
% Thermal Velocity and Direction
%--------------------------------------------------------------------------

vth = C.vth;

for j=1:N
%     v0(j) = MaxBoltzDis();                                % Velocity of electron
%     theta(j) = 0 + (360 - 0).*rand(1,1);        % Angle of electron
%     if theta(j) == 360
%         theta(j) = 0;
%     end
%     vx(j) = v0(j)*cos(theta(j));
    vx(j) = (vth/sqrt(2))*randn();                            % Velocity in x axis
    vy(j) = (vth/sqrt(2))*randn();
    vth_calc(j) = sqrt(vx(j)^2 + vy(j)^2);
    %vy(j) = v0(j)*sin(theta(j));                % Velocity in y axis
end


t = 0;
T(1) = 0;
dt = 1e-14;     % time step

for l=1:N           %Scattering time step
    ndt(l) = dt;
end
P_scat = 0;
Tmn = 0.2e-12;

px_prev = 0;
py_prev = 0;
T_prev = 0;

sampleidx = randi(N,10,1);
for t=2:100
    for k=1:N
        
        P_scat(k) = 1 - exp(-(dt/Tmn));
        %r = 0.8 + (1 - 0.8).*rand(1,1);
        if P_scat(k) > rand()
            vx(k) = (vth/sqrt(2))*randn();
            vy(k) = (vth/sqrt(2))*randn();
        else
            ndt(k) = ndt(k) + dt;
        end
        
        px_prev(k) = px(k);
        px(k) = px(k) + vx(k)*dt;
        py_prev(k) = py(k);
        py(k) = py(k) + vy(k)*dt;
        
        if py(k) >= 100e-9 || py(k) <= 0
            %[theta(k),vx(k),vy(k)] = SpecRef(theta(k),vx(k),vy(k));
            vy(k) = -vy(k);
            if py(k) >= 100e-9
                py(k) = 100e-9;
            end
            if py(k) <= 0
                py(k) = 0;
            end
        end
        if px(k) >= 200e-9
            px(k) = 0;
            px_prev(k) = px(k);
        elseif px(k) <= 0
            px(k) = 200e-9;
            px_prev(k) = px(k);
        else
            px(k) = px(k);
        end
        
        v(k) = sqrt(vx(k)^2 + vy(k)^2);
        v2(k) = v(k).*v(k);
        
    end
    for h=1:length(sampleidx)
        subplot(2,1,1);
        plot([px_prev(sampleidx(h)) px(sampleidx(h))],[py_prev(sampleidx(h)) py(sampleidx(h))],'SeriesIndex',h)
        hold on 
    end
    
    KE = 0.5 * C.m_n * mean(v2);
    T_prev = T;
    T = KE / C.kb;
    subplot(2,1,2);
    %plot(t, T, 'b.')
    plot([t-1 t], [T_prev T],'r')
    hold on
    
    pause(0.01)
end

T_T_C = mean(ndt)
MFP = mean(v)*mean(ndt)
figure(2)
histogram(vth_calc,10)
