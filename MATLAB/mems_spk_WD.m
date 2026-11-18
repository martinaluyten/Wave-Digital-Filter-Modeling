%% assignment 2 of Martina Luyten and Andrea Casati

clear; close all; clc

%% Simscape File for Ground Truth
% The ground truth output acoustic pressure signal obtained by the Simscape
% simulation --> for comparing the obtained signal (in time and freq
% domain)
load('ssc_output.mat')
%% Sampling Frequency
fs = 192e3;

%% Sampling Period
Ts = 1/fs;

%% Simulation Duration
stop_time = 2;  % [seconds]

%% Input Signal≠≠≠++

% Time Axis≠≠≠≠
t = 0:Ts:stop_time;
t = t(1:end-1);

% Signal Amplitude
A = 10;
% signal is synthesized
vin = A * sweeptone(1.99, 0.01, fs, 'SweepFrequencyRange', [500 20000]);
load('vin.mat');

%% Circuit Parameters
% Piezoelectric MEMS loudspeaker in Free-field conditions

% Transformer Ratio
alpha = 3.7e-4;
Seff = 2.0e-5;

% Electrical Domain
Re = 4;
Cp = 2.4e-8;

% Mechanical Domain
Rm = 9.7e-3;
Mm = 1e-6;
Cm = 2.2e-3;

% Acoustic Domain
Cbc = 3.6e-13; 
Ltube1 = 1e2;
Ltube2 = 1e2;
Ctube = 6.5e-13;
Rac = 5e6;

%% Removing Ideal Transformers (Mechanical Domain only)

gamma1 = alpha^-1;
gamma2 = Seff;

% Resistive Elements
R1 = Re/gamma1^2;
R2 = Rm;
R3 = Rac*gamma2^2;


% Dynamic Elements
% Capacitors
C1 = Cp*gamma1^2;
C2 = Cm;
C3 = Cbc/gamma2^2;
C4 = Ctube/gamma2^2;


% Inductors
L1 = Mm;
L2 = Ltube1*gamma2^2;
L3 = Ltube2*gamma2^2;

% Source
Fin = alpha * vin;

%% Setting of Free Parameters (Adaptation Conditions)

Z3 = R1;
Z6 = Ts/(2*C1);
Z9 = R2;
Z10 = (2*L1)/Ts;
Z13 = Ts/(2*C2);
Z16 = Ts/(2*C3);
Z19 = (2*L2)/Ts;
Z22 = Ts/(2*C4);
Z24 = (2*L3)/Ts;
Z25 = R3;

Z23 = Z24+Z25;
Z21 = Z23;
Z20 = Z21*Z22/(Z21+Z22);
Z18 = Z20;
Z17 = Z18+Z19;
Z15 = Z17;
Z14 = Z15*Z16/(Z15+Z16);
Z12 = Z14;
Z11 = Z12+Z13;
Z8 = Z11;
Z7 = Z8+Z9+Z10;
Z5 = Z7;
Z4 = Z5*Z6/(Z5+Z6);
Z2 = Z4;

Z1 = Z2+Z3;

%% Computing Scattering Matrices

Q = [1,1,1]; %parallel
B3 = [1,1,1]; %series 3-port
B4 = [-1,1,1,1]; %series 4-port

% scattering matrix for the 3-port parallel adaptor (ports 4,5 and 6)
Zp1 = diag([Z4,Z5,Z6]); 
Sp1 = 2*Q'*inv(Q*inv(Zp1)*Q')*Q*inv(Zp1)-eye(3);

% scattering matrix for the 3-port parallel adaptor (ports 14,15 and 16)
Zp2 = diag([Z14,Z15,Z16]);
Sp2 = 2*Q'*inv(Q*inv(Zp2)*Q')*Q*inv(Zp2)-eye(3);

% scattering matrix for the 3-port parallel adaptor (ports 20,21 and 22)
Zp3 = diag([Z20,Z21,Z22]);
Sp3 = 2*Q'*inv(Q*inv(Zp3)*Q')*Q*inv(Zp3)-eye(3);

% scattering matrix for the 3-port series adaptor (ports 1,2 and 3)
Zs1 = diag([Z1,Z2,Z3]);
Ss1 = eye(3)-2*Zs1*B3'*inv(B3*Zs1*B3')*B3;

% scattering matrix for the 4-port series adaptor (ports 7,8,9 and 10)
Zs2 = diag([Z7,Z8,Z9,Z10]);
Ss2 = eye(4)-2*Zs2*B4'*inv(B4*Zs2*B4')*B4;

% scattering matrix for the 3-port series adaptor (ports 11,12 and 13)
Zs3 = diag([Z11,Z12,Z13]);
Ss3 = eye(3)-2*Zs3*B3'*inv(B3*Zs3*B3')*B3;

% scattering matrix for the 3-port series adaptor (ports 17,18 and 19)
Zs4 = diag([Z17,Z18,Z19]);
Ss4 = eye(3)-2*Zs4*B3'*inv(B3*Zs4*B3')*B3;

% scattering matrix for the 3-port series adaptor (ports 23,24 and 25)
Zs5 = diag([Z23,Z24,Z25]);
Ss5 = eye(3)-2*Zs5*B3'*inv(B3*Zs5*B3')*B3;


%% Initialization of Waves
b6=0;
b10=0;
b13=0;
b16=0;
b19=0;
b22=0;
b24=0;

a3=0;
a9=0;
a25=0;

%% Initialization of Output Signals

Fout = zeros(1, length(t));

%% Simulation Algorithm

% Before the loop:

for n = 1 : length(Fin)

    % Forward Scan
    % compute waves reflected from linear elements
    a6 = b6;
    a10 = -b10;
    a13 = b13;
    a16 = b16;
    a19 = -b19;
    a22 = b22;
    a24 = -b24;
    
    % compute waves reflected from the first layer of adaptors
    % & compute waves reflected from the second layer of adaptors
    b23 = Ss5(1,:)*[0;a24;a25];
    a21 = b23;
    b20 = Sp3(1,:)*[0;a21;a22];
    a18 = b20;
    b17 = Ss4(1,:)*[0;a18;a19];
    a15 = b17;
    b14 = Sp2(1,:)*[0;a15;a16];
    a12 = b14;
    b11 = Ss3(1,:)*[0;a12;a13];
    a8 = b11;
    b7 = Ss2(1,:)*[0;a8;a9;a10];
    a5 = b7;
    b4 = Sp1(1,:)*[0;a5;a6];
    a2 = b4;
    b1 = Ss1(1,:)*[0;a2;a3];
   
    % Local Root Scattering
    a1 = 2*Fin(n)-b1;

    % Backward Scan
    % compute waves reflected from the second layer of adaptors toward linear elements
    % & compute waves reflected from the first layer of adaptors toward linear elements
    %resistors

    b3 = Ss1(3,:)*[a1;a2;a3];
    b2 = Ss1(2,:)*[a1;a2;a3];
    a4 = b2;
    
    b6 = Sp1(3,:)*[a4;a5;a6];
    b5 = Sp1(2,:)*[a4;a5;a6];
    a7 = b5; 

    b9 = Ss2(3,:)*[a7;a8;a9;a10];
    b10 = Ss2(4,:)*[a7;a8;a9;a10];
    b8 = Ss2(2,:)*[a7;a8;a9;a10];
    a11 = b8;
    
    b13 = Ss3(3,:)*[a11;a12;a13];
    b12 = Ss3(2,:)*[a11;a12;a13];
    a14 = b12;

    b16 = Sp2(3,:)*[a14;a15;a16];
    b15 = Sp2(2,:)*[a14;a15;a16];
    a17 = b15;
    
    b19 = Ss4(3,:)*[a17;a18;a19];
    b18 = Ss4(2,:)*[a17;a18;a19];
    a20 = b18;
    
    b22 = Sp3(3,:)*[a20;a21;a22];
    b21 = Sp3(2,:)*[a20;a21;a22];
    a23 = b21;
    
    b24 = Ss5(2,:)*[a23;a24;a25];
    b25 = Ss5(3,:)*[a23;a24;a25];


    % Read Output
    Fout(n)=(a25+b25)/2;

end



%% Output Plots

% Computing acoustic pressure
pout = Fout ./ Seff;

% Time Domain Plots
figure
set(gcf, 'Color', 'w');
plot(t, pout, 'b', 'Linewidth', 2);
hold on
plot(gt(1, :), gt(2, :), 'r--', 'Linewidth', 2);
grid on;
xlabel('Time [seconds]','Fontsize',16,'interpreter','latex');
ylabel('$p_{\mathrm{out}}$ [Pa]','Fontsize',16,'interpreter','latex');
legend('WDF','SSC','Fontsize',16,'interpreter','latex');
title('Output Pressure - Time Domain','Fontsize',18,'interpreter','latex');

% Frequency domain Plots
nfft = 2^20;
res = fs/nfft;
f = (0:nfft/2-1) * res;

ir = impzest(vin/A, pout');
ir_gt = impzest(vin/A, gt(2, 1:end-1)');

tf = fft(ir, nfft);
tf_gt = fft(ir_gt, nfft);

abs_tf = abs(tf(1:nfft/2));
abs_tf_gt = abs(tf_gt(1:nfft/2));

figure
set(gcf, 'Color', 'w');
semilogx(f, 20*log10(abs_tf/2e-5), 'b', 'Linewidth', 2);
hold on
semilogx(f, 20*log10(abs_tf_gt/2e-5), 'r--', 'Linewidth', 2);
grid on;
xlim([500, 20000])
xlabel('Frequency [Hz]','Fontsize',16,'interpreter','latex');
ylabel('$\mathrm{SPL}\,[\mathrm{dB}_\mathrm{SPL}]$','Fontsize',16,'interpreter','latex');
legend('WDF','SSC','Fontsize',16,'interpreter','latex');
title('Output Sound Pressure Level - Frequency Domain','Fontsize',16,'interpreter','latex');

%% Error Plots

figure
set(gcf, 'Color', 'w');
hold on;
plot(t, pout - gt(2, 1:end-1), 'k', 'Linewidth', 2);
grid on;
xlabel('Time [seconds]','Fontsize',16,'interpreter','latex');
ylabel('$\mathcal{E}_{\mathrm{out}}$ [Pa]','Fontsize',16,'interpreter','latex');
title('Error Signal','Fontsize',16,'interpreter','latex');

%% Compute Mean Squared Error (MSE)

mse = mean((pout - gt(2, 1:end-1)).^2);
disp('MSE = ')
disp(mse)

