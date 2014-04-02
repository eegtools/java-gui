% © EOG VICON © 
% Protocol for Visuo - Hand coordination in non-constrained targeting 
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% [screen_param] = create_screen_struct
% Generate structure with screen information

function [screen_param] = create_screen_struct

[W, H]=Screen('WindowSize', 0);
rect = Screen('Rect',0);
screen_param.rect = rect;
screen_param.W = W;
screen_param.H = H;
screen_param.Xc = round(W/2);
screen_param.Yc = round(H/2);
screen_param.color.white    =   [255 255 255];
screen_param.color.gray     =   [100 100 100];
screen_param.color.black    =   [0 0 0];
screen_param.color.blue     =   [100 100 250];
screen_param.color.red      =   [200 50 50];
screen_param.color.green    =   [21 152 18];