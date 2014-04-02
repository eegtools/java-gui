% © EOG VICON ©
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% exist_calib = check_calib(trialdir)
% Parsing directory to check the existence of calib.mat file




function exist_calib = check_calib(trialdir)

trial_dir = dir(trialdir);
exist_calib = 0;
for j = 1: length(trial_dir)
    exist_calib = or(exist_calib,strcmp(trial_dir(j).name,'calib.mat'));
end