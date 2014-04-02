
% © EOG VICON ©
%
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
% BARDOTV2.2 
% Last Update 17 February Final Version Used in Experiments
%
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

%% Release INFO %%
%
% La distanza nella condizione 2DOT adesso non è un parametro fisso, ma funzione della distanza
% tra i punti medi. La distanza ora è di 2/3U a destra e a sinistra (IN EX condition)
% dove U rappresenta la distanza tra la crocetta e il punto medio
%
% Aggiungo in qualche struttura le informazioni relative a quale versione
% di EOG sto lanciando, in modo che si possa capire che tipo di dati
% aspettarsi
%
% Aggiungo a qualche struttura le informazioni relative a ogni quanti trial
% faccio partire la calibrazione salvo interamente le risposte della dialog
%
% Aggiunto una directory di default per il salvataggio, in modo da non
% dover sempre scorrere l'albero delle cartelle
%
% Le scritte RIGHT e LEFT sono state centrate sulla croce

clear all
close all
clc

% Random Initialization
rand('twister',sum(100*clock));

EOG_version = '2.2';
%------    da SETTARE     ------%
% Set acquisition type, valid values are :
% NI : for National Instrument Device
% USB : for USB-SERIAL Converter 
% test : to test program without acquisition
acquisition_flag = 'NI';
%-------------------------------%

% Disable Psychtoolbox Warnings
Screen('Preference', 'SkipSyncTests',0);
Screen('Preference', 'VisualDebugLevel', 0);
Screen('Preference','SuppressAllWarnings', 0);

DEBUG = 0;

if strcmp(acquisition_flag,'test')
    clc
    str_warn = {'WARNING :: you are in test mode, no acquisition is done by BrainVision' ; 'Press key to continue'};
    warndlg(str_warn,'!! Warning !!')  
    disp('Press Key....')
    pause
    % If you are in test mode, setting also DEBUG to 1
    DEBUG = 1;    
end
 
%% Init CDAQ library
cdaq_config_file='F:\WorkingDir\EEG_Tools\point_dot_bar\BarDot_eeg\ptb3\DotBar_cdaq_config.cfg';
if ~cdaq_init(cdaq_config_file)
    return; 
end
address = hex2dec('378'); 

% Create the main structure of data and setup some information about
% subjects and number of trial
setup_data = dialog_setup_data;
protocol_param.version = EOG_version;
protocol_param.setupdata = setup_data;

% defaul SAVE dir
protocol_param.defaultsavedir = 'F:\DataAcquired\EOGEEG';
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
[DOT,BARD,BAR,DOTD,CROSS] = create_stimuli_struct(screen_param,protocol_param,pointing_data_normalized);

% Create folder for experimental type
mkdir(protocol_param.trialdir,'all');
save([protocol_param.trialdir '\all\protocol_param.mat'], 'protocol_param');
save([protocol_param.trialdir '\all\stimuli.mat'], 'DOT', 'BARD', 'BAR', 'DOTD', 'CROSS');

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