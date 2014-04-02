% MAIN PROGRAM
%% Called Function

% dialog_setup_data
% create_screen_struct
% check_calib
% record_left_right_baseline
% create_parameters_struct
% create_stimuli_struct
% splash_screen
% show_stimuli
% update_stimuli

clear all
close all
clc

% Random Initializatio
rand('twister',sum(100*clock));

EOG_version = '2.2';
%------    Setup     ------%
% Set acquisition type, valid values are :
% NI : for National Instrument Device
% USB : for USB-SERIAL Converter 
% test : to test program without acquisition
acquisition_flag = 'test';
%-------------------------------%

% Disable Psychtoolbox Warnings
Screen('Preference', 'SkipSyncTests',0);
Screen('Preference', 'VisualDebugLevel', 0);
Screen('Preference','SuppressAllWarnings', 0);

DEBUG = 0;

if strcmp(acquisition_flag,'test')
    clc
    str_warn = {'WARNING :: you are in test mode, no acquisition is done by Vicon' ; 'Press key to continue'};
    warndlg(str_warn,'!! Warning !!')  
    disp('Press Key....')
    pause
    % If you are in test mode, setting also DEBUG to 1
    DEBUG = 1;    
end
 
%% Inizializza TTL Object usando specifiche impostate dall'utente USB o NI
TTL_obj = init_TTL(acquisition_flag);

% Create the main structure of data and setup some information about
% subjects and number of trial
setup_data = dialog_setup_data;
protocol_param.version = EOG_version;
protocol_param.setupdata = setup_data;

% defaul SAVE dir
protocol_param.defaultsavedir = 'F:\DataAcquired\EOGEMGVicon';
protocol_param.datadir = uigetdir(protocol_param.defaultsavedir);
% Add subfolder with Namesubject
mkdir(protocol_param.datadir,setup_data{1});
protocol_param.subjectdir = [protocol_param.datadir '\' setup_data{1}];
% Add Trial dir using date
mkdir(protocol_param.subjectdir,date);
protocol_param.trialdir = [protocol_param.subjectdir '\' date];
screen_param = create_screen_struct;

% Parsing directory, if is empty perform a calibration otherwise ask to
% calibrate

exist_calib = check_calib(protocol_param.trialdir);

if exist_calib
    choice = questdlg('Left-Right Calibration Found..Do you want to recalibrate or load data ?', ...
        'Make a choice', ...
        'Calibrate R-L','Load calibration','Calibrate R-L');
else
    choice = 'Calibrate R-L';
end

switch choice
    case 'Calibrate R-L'
        pointing_data_normalized = record_left_right_baseline(setup_data,screen_param,DEBUG);
  
        save([protocol_param.trialdir '\calib.mat'], 'pointing_data_normalized');
    case 'Load calibration'
        load([protocol_param.trialdir '\calib.mat'])
end

 
% After recording data we can use it to create protocol param structure
protocol_param = create_parameters_struct(setup_data,pointing_data_normalized,screen_param,protocol_param);
% In questa versione il numero di parametri in ingresso è diverso per
% questa funzione, perche deve anche conoscere il risultato della
% calibrazione destra sinistra per disegnare i 2DOT
[DOT,BAR,BARD,BARDA,CROSS] = create_stimuli_struct(screen_param,protocol_param,pointing_data_normalized);

% Create folder for experimental type
mkdir(protocol_param.trialdir,'all');
save([protocol_param.trialdir '\all\protocol_param.mat'], 'protocol_param');
save([protocol_param.trialdir '\all\stimuli.mat'], 'DOT', 'BAR', 'BARD', 'BARDA', 'CROSS');

% Activate Screen Mode
try
[screen_param.window, rect] = Screen('OpenWindow', 0, screen_param.color.black , screen_param.rect);
monitorFlipInterval = Screen('GetFlipInterval', screen_param.window);

% Show splash screen in which you can Cchoose from calibration or trial or
% quit etc, and return the keypressed ch
ch = 'splash';
flag_exit = 1;
    while flag_exit
        switch ch
            case 'e'
                %Calibration screen with N dots
                calibrate_eog;
                ch = 'splash';
            case 'c' % Perform some test
                stimulitestm;
                ch = 'splash';
            case 't' % start trial
                % In debug Mode, a text describe stimulus type
                complex_stimlus_order;
                ch = 'splash';
            case 'splash'
                ch = splash_screen(screen_param);
                % Output can be :
                % E :: for N dots Calibration Screen
                % C :: Show all stimuli in protocol
                % T :: Start Protocol 
                % F :: Fake trial
                  
            case 'q'
                sca
                flag_exit = 0;
        end
    end    
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack
end