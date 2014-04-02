% © EOG VICON ©
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% [screen_param] = create_protocol_struct
% Generate structure with protocol parameter

function [protocol_param] = create_parameters_struct(setup_data,pointing_data_normalized,screen_param,protocol_param)

protocol_param.cdaq_config_file='F:\WorkingDir\EEG_Tools\point_dot_bar\BarDot_eeg\ptb3\DanLiAcq.cfg';

protocol_param.eeg_triggers.experiment_start=2;
protocol_param.eeg_triggers.experiment_end=4;
protocol_param.eeg_triggers.calibrate_start=6;
protocol_param.eeg_triggers.calibrate_end=8;
protocol_param.eeg_triggers.pause_start=10;
protocol_param.eeg_triggers.pause_end=12;
% conditions' triggers code are: bar:11,12 dot:21,22

protocol_param.isi1 = 0.5; % Time [s] between cross and NI start
protocol_param.isi2 = 1;   % Time [s] between NI start and dot
protocol_param.poststimulus_recording = 3;   % Time [s] time between dot and NI recording stop
protocol_param.eog_calib_time=1.5;  % Time [s] to calibrate eog
protocol_param.posttrigger_time=0.1;
protocol_param.post_resume_time=1;

protocol_param.upperY = 0.40; % Percentage distance from top
protocol_param.lowerY = 0.40; % Percentage distance from bottom
protocol_param.border = 0.25; % Distance from border left-right < 0.5
protocol_param.ycross = pointing_data_normalized.ypos;
%This are the right and left position of dot retrived during some normal
%condition test
protocol_param.xleft = pointing_data_normalized.leftmean(1);
protocol_param.xright = pointing_data_normalized.rightmean(1);
protocol_param.left_cal = screen_param.W*protocol_param.border;
protocol_param.right_cal = screen_param.W*(1-protocol_param.border);
protocol_param.deltabar = 0;
protocol_param.deltXbar = 200;

% Create parameters for calibration
protocol_param.Ndots = str2double(setup_data{4}); %Number of calibration points
% Create equispaced point from baseline condition
protocol_param.calibpos = linspace(protocol_param.xleft,protocol_param.xright,protocol_param.Ndots);
% Protocol trial definition


% Defining new parameters for all mixed trial
protocol_param.numtrial = str2double(setup_data{2});
protocol_param.condition = 2; % AIP: Left or Right
N = protocol_param.numtrial;
% Define how many trial in each block (60+60)
protocol_param.block1.trial = 2*N; % BAR 2N condition 
protocol_param.block2.trial = 2*N; % DOT 2N condition


% Two types of experiments
protocol_param.sequence.exp_type =[ 1*ones(1,protocol_param.block1.trial) ... % BAR =  1
    2*ones(1,protocol_param.block2.trial)];   % DOT = 2

% Define left right condition in each block ( L=1 :: R=2 )
% BAR (N+N)
protocol_param.block1.condition = [ 1*ones(1,N) 2*ones(1,N)];

% DOT (N+N)
protocol_param.block2.condition = [ 1*ones(1,N) 2*ones(1,N)];


protocol_param.maxtrial =   protocol_param.block1.trial + ...
    protocol_param.block2.trial;

protocol_param.sequence.condition =  [protocol_param.block1.condition ...
    protocol_param.block2.condition];


% NOW we have a complete sequence of trial, I want to separate Right
% from left condition and create 2 new sequence R L

protocol_param.sequence.L =  find(protocol_param.sequence.condition == 1);
protocol_param.sequence.R =  find(protocol_param.sequence.condition == 2);

L = protocol_param.sequence.L;
R = protocol_param.sequence.R;

%defaultStream = RandStream.getDefaultStream;
stream = RandStream.getGlobalStream

L = Shuffle(L);
R = Shuffle(R);
alternate_sequence = [R ; L];
protocol_param.shuffle  = reshape(alternate_sequence,1,4*N); 



