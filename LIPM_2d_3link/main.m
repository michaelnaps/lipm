%% Project: Linear Inverted Pendulum Model
%  Complexity: 2 Links (actuated at ground)
%  Created by: Michael Napoli
%  Created on: 11/5/2021

%  Purpose: Model and stabilize an actuated
%           linear inverted pendulum system made 
%           up of two connected rods.
%
%           The system will be contrtolled via
%           the torque at both pendulum joints.

clc;clear;
close all;


%% Cost Function
%           ang pos.        ang. vel.        cart pos.
% Cq = {
%       @(qc) (10*cos(pi)-10*cos(qc(1))).^2; % + (0-qc(4)).^2; % + (pd-qc(1))^2;
%       @(qc) (10*cos(0.)-10*cos(qc(3))).^2;
%      };

Cq = {
      @(qc) (pi -qc(1)).^2;  % cost of position of Link 1
      @(qc) (0.0-qc(3)).^2;  % cost of position of Link 2
      @(qc) (0.0-qc(5)).^2;  % cost of position of Link 3
     };

 
%% Variable Setup
% establish state space vectors and variables
P = 4;                    % prediction horizon
dt = 0.10;                % change in time
T = 0:dt:10;              % time span
th1_0 = [pi; 0.0];        % link 1 position and velocity
th2_0 = [0.; 0.0];        % link 2 position and velocity
th3_0 = [0.; 0.0];        % link 3 position and velocity
um = [0; 0; 0];  % maximum input to joints

% create initial states
q0 = [
        th1_0;th2_0;th3_0;...       % initial joint states
        zeros(length(um),1);...     % return for inputs
        zeros(length(Cq),1);...     % return for cost
        0                           % iteration count
     ];

% Damping Coefficients
% (interesting behavior when c1 < 20)
c1 = 50;
c2 = c1;
c3 = c2;


%% Implementation
tic
[T, q] = mpc_control(P, T, q0, um, c1, c2, c3, Cq, 1e-6);
toc


%% Graphing and Evaluation
fprintf("Final Input at Link 1 ------------- %.4f [N]\n", q(length(q),7))
fprintf("Final Input at Link 2 ------------- %.4f [N]\n", q(length(q),8))
fprintf("Final Input at Link 3 ------------- %.4f [N]\n", q(length(q),9))
fprintf("Final Position of Link 1 ---------- %.4f [m]\n", q(length(q),1))
fprintf("Final Velocity of Link 1 ---------- %.4f [m/s]\n", q(length(q),2))
fprintf("Final Position of Link 2 ---------- %.4f [rad]\n", q(length(q),3))
fprintf("Final Velocity of Link 2 ---------- %.4f [rad/s]\n", q(length(q),4))
fprintf("Final Position of Link 3 ---------- %.4f [rad]\n", q(length(q),5))
fprintf("Final Velocity of Link 3 ---------- %.4f [rad/s]\n", q(length(q),6))
fprintf("Average Number of Iterations ------ %.4f [n]\n", sum(q(:,13))/length(q));

% velocity and position of link 1
figure('Position', [0 0 1400 800])
hold on
subplot(3,3,1)
yyaxis left
plot(T, q(:,1))
ylabel('Pos [rad]')
yyaxis right
plot(T, q(:,2))
ylabel('Vel [rad/s]')
xlabel('Time')
title('Link 1')
legend('Pos', 'Vel')

% velocity and position of link 2
subplot(3,3,2)
yyaxis left
plot(T, q(:,3))
ylabel('Pos [rad]')
yyaxis right
plot(T, q(:,4))
ylabel('Vel [rad/s]')
xlabel('Time')
title('Link 2')
legend('Pos', 'Vel')

% velocity and position of link 3
subplot(3,3,3)
yyaxis left
plot(T, q(:,5))
ylabel('Pos [rad]')
yyaxis right
plot(T, q(:,6))
ylabel('Vel [rad/s]')
xlabel('Time')
title('Link 3')
legend('Pos', 'Vel')

% plot input on link 1
subplot(3,3,4)
yyaxis left
plot(T, q(:,7))
title('Input on Link 1')
ylabel('Input [Nm]')
xlabel('Time')

% plot input on link 2
subplot(3,3,5)
plot(T, q(:,8))
title('Input on Link 2')
ylabel('Input [Nm]')
xlabel('Time')
hold off

% plot input on link 3
subplot(3,3,6)
plot(T, q(:,9))
title('Input on Link 3')
ylabel('Input [Nm]')
xlabel('Time')
hold off

% plot cost of link 1
figure('Position', [0 0 700 400])
subplot(3,3,7)
plot(T, q(:,10))
title('Cost of Link 1')
ylabel('Cost [unitless]')
xlabel('Time')
hold off

% plot cost of link 2
subplot(3,3,8)
plot(T, q(:,11))
title('Cost of Link 2')
ylabel('Cost [unitless]')
xlabel('Time')
hold off

% plot cost of link 3
subplot(3,3,9)
plot(T, q(:,12))
title('Cost of Link 3')
ylabel('Cost [unitless]')
xlabel('Time')
hold off
