% © EOG VICON © 
% Protocol for Visuo - Hand coordination in non-constrained targeting 
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
% 
% Dialog Box 
% This is used to input some parameter

% Define input for dialogBOX
function setup_data = dialog_setup_data
str_1 = 'Subject Initial:';
str_2 = '# of trial for each condition [pair]';
str_3 = '# of trial for calibration';
str_4 = '# of calibration dots';
str_5 = '# of trial to compute mean (R-L)';
title= 'Setup Data';

prompt={str_1,str_2,str_3,str_4,str_5};
numlines=1;
defaultanswer={'TEST','20','20','10','5'};
setup_data = inputdlg(prompt,title,numlines,defaultanswer);