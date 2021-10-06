%% Project: Linear Inverted Pendulum Model
%  Complexity: Single Link
%  Created by: Michael Napoli
%  Created on: 9/22/2021

%  Purpose: Simulate a linear inverted pendulum model with
%       1-DOF and actuated by the ground connection. Create
%       conrol system to reach equilibrium at theta = pi/2.

clc;clear;
close all;

% animation adjustment and time span
adj = pi/2;  % [rad]
T = 10;      % [s]

% initial conditions and tracking variables for gains
q0 = [pi/2+adj; 1; 0; 0; 0];  % joint pos and joint vel

% solve nonlinear state space
[t,q] = ode45(@(t,q) statespace(q,50,800,800), [0 T], q0);

% % angular position
% figure(1)
% hold on
% plot(t, q(:,1));
% title('Angular Position')
% hold off
% 
% % angular velocity
% figure(2)
% hold on
% plot(t, q(:,2));
% title('Angular Velocity')
% hold off

% % proportional gain vs. position
% figure(3)
% hold on
% plot(q(:,3), q(:,1))
% title('Proportional Gain Plot')
% xlabel('Kp * Torque [Nm]')
% ylabel('Angle [rad]')
% hold off

% % gain vs. position equation
% figure(4)
% fplot(@(q1) sin(1/2 * (q1 + pi)), [0 6*pi])

% % simulate process
n = length(q(:,1));
animation([q(:,1)-adj, zeros(n,1), q(:,2), zeros(n,1)]', 0.01);
