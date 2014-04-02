% � EOG VICON �
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% Show on current windows the stimulus, according to its properties
%
% status = show_stimuli(stimulus_struct,window);
%
% Questa funzione si occuma di mostrare gli stimoli sullo schermo
% utilizzando i dati contenuti nella specifica struttura che contiene le
% propriet� dello stimolo, � divisa per tipologia di stimoli CROSS DOT DOT2
% e BAR. Prima di procedere con lo SCREEN, viene lanciata la funzione
% UPDATE_STIMULI, che si occupa di aggiornare la struttura dello stimolo,
% nel caso alcune suo componenti siano state cambiate (come ad esempio la
% posizione o altri paramentri)

function [err] = show_stimuli(stim_struct,window,screen_param)

try
    case_flag = stim_struct.stimulustype;
    switch case_flag
        case 'dot'
            % Data la struttura in ingresso, questa viene copiata sulla
            % variabile globale che rappresenata lo stimolo
            DOT = stim_struct;
            % Qui viene aggiornata la struttura dello stimolo
            DOT = update_stimuli(DOT);                        
            Screen('FillOval', window, [screen_param.color.white' screen_param.color.black'],DOT.mtx_coord);            
            err = 0;
                 
        case 'cross'
            CROSS = stim_struct;
            CROSS = update_stimuli(CROSS);
            Screen('DrawLines', window, CROSS.mtx_coord, CROSS.linedim, screen_param.color.green);
            err = 0;
            
        case 'bar'
            BAR = stim_struct;
            BAR = update_stimuli(BAR);
            Screen('DrawLines', window, BAR.mtx_coord, BAR.dim,BAR.color);            
            err = 0;     
            
    end
catch err
    Screen('CloseAll');
    sca    
    err.message
    err.stack 
    ListenChar(0);
    pause
    
end