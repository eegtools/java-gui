function [protocol_param] = create_parameters_struct(setup_data,pointing_data_normalized,screen_param,protocol_param)

protocol_param.isi = 1.5; % Time [s] between cross and dot
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
% Define how many trial in each block (20+20)
protocol_param.block1.trial = 2*N; % DOT 2N condition
protocol_param.block2.trial = 2*N; % BAR 2N condition 
protocol_param.block3.trial = 2*N; % BARD 2N condition
protocol_param.block4.trial = 2*N; % BARDA 2N condition

% Four types of experiments
protocol_param.sequence.exp_type =[ 1*ones(1,protocol_param.block1.trial) ... % DOT =  1
    2*ones(1,protocol_param.block2.trial) ... % BAR = 2
    3*ones(1,protocol_param.block3.trial) ... % BARD =  3
    4*ones(1,protocol_param.block4.trial)];   % BARDA = 4

% Define left right condition in each block ( L=1 :: R=2 )
% DOT (N+N)
protocol_param.block1.condition = [ 1*ones(1,N) 2*ones(1,N)];

% BAR (N+N)
protocol_param.block2.condition = [ 1*ones(1,N) 2*ones(1,N)];

% BARD (N+N)
protocol_param.block3.condition = [ 1*ones(1,N) 2*ones(1,N)];

% BARDA (N+N)
protocol_param.block4.condition = [ 1*ones(1,N) 2*ones(1,N)];


protocol_param.maxtrial =   protocol_param.block1.trial + ...
    protocol_param.block2.trial + ...
    protocol_param.block3.trial + ...
    protocol_param.block4.trial;

protocol_param.sequence.condition =  [protocol_param.block1.condition ...
    protocol_param.block2.condition...
    protocol_param.block3.condition...
    protocol_param.block4.condition];


% NOW we have a complete sequence of trial, I want to separate Right
% from left condition and create 2 new sequence R L

protocol_param.sequence.L =  find(protocol_param.sequence.condition == 1);
protocol_param.sequence.R =  find(protocol_param.sequence.condition == 2);

L = protocol_param.sequence.L;
R = protocol_param.sequence.R;


defaultStream = RandStream.getDefaultStream;

L = Shuffle(L);
R = Shuffle(R);
alternate_sequence = [R ; L];
protocol_param.shuffle  = reshape(alternate_sequence,1,8*N); 

% Create Randomdot position for DOT 
% AIP: LEFT
amp =  (protocol_param.xright-protocol_param.xleft);
xminl = protocol_param.xleft + amp/2;
protocol_param.randomdotl = xminl + amp*rand(1,protocol_param.maxtrial);
% AIP: RIGHT
amp = (protocol_param.xright-protocol_param.xleft);
xminr = protocol_param.xright+ amp/2;
protocol_param.randomdotr = xminr + amp*rand(1,protocol_param.maxtrial);


% Create Randombard position for BARD and BARDA
% AIP: LEFT
ampl = (protocol_param.xright-protocol_param.xleft)/6;
xminl = protocol_param.xright -ampl/2;
protocol_param.randombardl = xminl + ampl*rand(1,protocol_param.maxtrial);
% AIP: RIGHT
ampr = (protocol_param.xright-protocol_param.xleft)/6;
xminr = protocol_param.xleft- ampr/2;
protocol_param.randombardr = xminr + ampr*rand(1,protocol_param.maxtrial);