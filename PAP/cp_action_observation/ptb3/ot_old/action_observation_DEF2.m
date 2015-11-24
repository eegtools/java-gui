clear all 
close all



try

video_file_extension='.mp4';
% input_video_folder='C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\video';
input_video_folder='/data/projects/cp_action_observation/video';


% accepted values are when : N_stimuli_x_cond * N_type_stim / N_block / N_available_video ..... is an integer
N_block=3;                                              % number of blocks composing the experiment, a 3-4 minutes rest is done during the experiment.
N_type_stim=4;                                          % number of different types of stimuli
N_stimuli_x_cond=72;                                    % number of stimuli for condition
N_available_video=6;                                    % number of available video

N_stimuli_x_cond_x_block=N_stimuli_x_cond / N_block;   % number of stimuli for condition for each block
N_tot_stimuli=N_stimuli_x_cond * N_type_stim;
N_tot_stimuli_x_block=N_tot_stimuli / N_block;          % number of stimuli for blcok

N_video_repetition=N_stimuli_x_cond / N_available_video;  % 72/6=12

N_random_questions=24; 
N_stimuli_noquestions=N_tot_stimuli - N_random_questions;

stimulus_time=3;    %time of presentation for each stimulus in seconds
fix_time=0.5;       %time of the red fixation cross at the beginning of the experimental block
iti_time=1.5;       %fixed inter stimulus time in seconds (actual ITI = 1.5 + rand(1) )
question_time=4;    %time of question panel 

black = [0 0 0];
white = [255 255 255];
dot_size = 4;

sound_frame=45;
% =======================================================
subject_label=input('please insert subject label (do not fill in any space char) :','s');
% output_log_file=['C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\logs\log_' subject_label '_' date '.txt'];
output_log_file=['/data/projects/cp_action_observation/logs/log_' subject_label '_' date '.txt'];

% while exist(output_log_file)
%     subject_label=input('the entered subject already exist....do you want to overwrite the current log file (Y) or insert a new subject label (N) ?','s');
%     if (subject_label == 'Y')
%         break;
%     else
%         subject_label=input('please insert subject label (do not fill in any space char)','s');
%         output_log_file=['C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\log\log_' subject_label '_' date '.txt'];
%     endppp
% end
 fp=fopen(output_log_file,'w+');

% =======================================================
% SCREEN SETTINGS
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

% rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
rec = [0,0,1280,768]; W=1280; H=768;

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

% =======================================================
% TRIGGERS
% 1: control video
% 2: action observation (AO)
% 3: AO + congruent sound (AOCS)
% 4: AO + incongruent sound (AOIS)
% 5: question
% 6: audio start in AOCS
% 7: audio start in AOIS

question_trigger_value=5;
AOCS_trigger_value=6;
AOIS_trigger_value=7;

% crea oggetto porta parallela usanndo le impostazioni di default
  dio='' ... = digitalio('parallel','LPT1');

% aggiunge una linea dati in output di 4 bit
%  line=addline(dio,0:3,'out');
 
% =========================================================================================================
% STIMULI PERMUTATION (each of the 3 block is permuted separately, then stimuli are then concatenated)

% --- files
video_file={'ctrl01','ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'aocs01','aocs02','aocs03','aocs04','aocs05','aocs06'; ...
            'aois01','aois02','aois03','aois04','aois05','aois06'};

A=[1 2 3 4];                                    % --- conditions : controls, ao, aocs, aois

ordered_list1=repmat(A,1,N_stimuli_x_cond_x_block);
permutation1=randperm(N_tot_stimuli_x_block);
trials_list1=ordered_list1(permutation1); 

ordered_list2=repmat(A,1,N_stimuli_x_cond_x_block);
permutation2=randperm(N_tot_stimuli_x_block);
trials_list2=ordered_list2(permutation2); 

ordered_list3=repmat(A,1,N_stimuli_x_cond_x_block);
permutation3=randperm(N_tot_stimuli_x_block);
trials_list3=ordered_list3(permutation3); 

trials_list=cat(2,trials_list1, trials_list2, trials_list3);

% permute stimuli....
ordered_video_files=repmat(video_file, 1, N_video_repetition); ... create a matrix of 4x66 cells, replicating the base one (video_file)   
video_files_list=cell(N_type_stim,N_stimuli_x_cond);    

for row=1:N_type_stim
    permutation=randperm(N_stimuli_x_cond);

    input_row=ordered_video_files(row,:);
    video_files_list(row,:)=input_row(permutation);   
end

% define question trials onset
ordered_question_appearance=zeros(N_tot_stimuli);
for n=1:N_random_questions
    ordered_question_appearance(n)=1;
end
permutation=randperm(N_tot_stimuli);
question_appearance = ordered_question_appearance(permutation);

% CROCE
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];

%====================================================================================================================================
% START EXPERIMENT
%====================================================================================================================================
HideCursor;
is_paused=0;
can_pause=0;
curr_stimulus_num=0; control_trial=0; ao_trial=0; aocs_trial=0; aois_trial=0; question_trial=0;
%====================================================================================================================================
% TRAINING / EXPLANATIONS

[nx ny textbounds] = DrawFormattedText(window,['In questo esperimento vedrai una serie di video.\n' 'Alcuni saranno senza audio, altri con il loro giusto audio, altri con un audio sbagliato' ... 
                                                   '\n\n' 'Fai in cenno quando sei pronto'],'center','center',white, 55 ,[],[],1.5);
Screen('Flip', window);
KbWait;


while 0

    [nx ny textbounds] = DrawFormattedText(window,'video senza audio','center', 'center', white, 55 ,[],[],1.5);
    Screen('Flip', window);
    WaitSecs(2);
    rnd=ceil(rand()*N_stimuli_x_cond);
    file_video=fullfile(input_video_folder, [video_files_list{1,rnd} video_file_extension]);
    showMovieSendStartTrigger(file_video, window, dio, 1);

%     [nx ny textbounds] = DrawFormattedText(window,'azione senza audio','center', 'center', white, 55 ,[],[],1.5);
%     Screen('Flip', window);
    WaitSecs(1);
    
    rnd=ceil(rand()*N_stimuli_x_cond);
    file_video=fullfile(input_video_folder, [video_files_list{2,rnd} video_file_extension]);
    showMovieSendStartTrigger(file_video, window, dio, 2);

    
    for id=1:N_available_video
    
        [nx ny textbounds] = DrawFormattedText(window,'azione con audio giusto','center', 'center', white, 55 ,[],[],1.5);
        Screen('Flip', window);
        WaitSecs(2);

        file_video=fullfile(input_video_folder, [video_file{3,id} video_file_extension]);
        showMovieSendStartTrigger(file_video, window, dio, 3);

        [nx ny textbounds] = DrawFormattedText(window,'azione con audio sbagliato','center', 'center', white, 55 ,[],[],1.5);
        Screen('Flip', window);
        WaitSecs(2);
        
        file_video=fullfile(input_video_folder, [video_file{4,id} video_file_extension]);
        showMovieSendStartTrigger(file_video, window, dio, 4);
    end
    
    [nx ny textbounds] = DrawFormattedText(window,'Ogni tanto ti verra chiesto di dire allo sperimentatore come era il suono del video appena visto.\nle tre possibilita` sono:\n1) suono assente\n2) suono giusto\n3) suono sbagliato','center','center',white, 55 ,[],[],1.5);
    Screen('Flip', window);
    WaitSecs(4);
    
    [nx ny textbounds] = DrawFormattedText(window,'Se ti e` tutto chiaro possiamo iniziare con l`esperimento\nIniziamo?','center','center',white, 55 ,[],[],1.5);
    Screen('Flip', window);
    [a,keypressed,c] = KbWait; 
    
    if KbName(keypressed) == 's'
        break;          ... esci dal while ed inizia l'esperimento
    else
        continue;       ... fai un nuovo ciclo di training
    end
end

%====================================================================================================================================
% EXPERIMENT
trials_list
for iter = trials_list
%     putvalue(dio,cross_trigger_value);

    % if is paused, check for a 'p' press in order to resume the experiment
    while is_paused == 1
        [nx ny textbounds] = DrawFormattedText(window,'esperimento in PAUSA','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
        if keyIsDown
            if KbName(keyCode) == 'p'
                is_paused=0;
                
                % show a 3 seconds countdown panel
                start_time=GetSecs;
                while 1 
                    elapsed=GetSecs-start_time;
                    left=ceil(3-elapsed);
                    [nx ny textbounds] = DrawFormattedText(window,['Preparati!, stiamo sta per ripartire\n\n\n' num2str(left)],'center','center',white, 55 ,[],[],1.5);
                    Screen('Flip', window);
                    if elapsed > 3
                        [nx ny textbounds] = DrawFormattedText(window,'Ricominciamo!','center','center',white, 55 ,[],[],1.5);
                        Screen('Flip', window);
                        WaitSecs(1);
                        break;
                    end
                end                
            end
        end 
    end


    % draw the cross and wait for half a second
    Screen('DrawLines', window, cross_center, 3, white);
    Screen('Flip', window);

    start_time=GetSecs;
    while 1 
        elapsed=GetSecs-start_time;
        if elapsed > 0.5
            break;
        end
    end     
    
    % show videos
    curr_stimulus_num=curr_stimulus_num+1;
    switch iter

        case 1
            control_trial=control_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,control_trial} video_file_extension]);
            showMovieSendStartTrigger(file_video, window, dio, (iter));
            fwrite(fp, [video_files_list{iter,control_trial} '\n']);

        case 2
            ao_trial=ao_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,ao_trial} video_file_extension]);
            showMovieSendStartTrigger(file_video, window, dio, (iter));
            fwrite(fp, [video_files_list{iter,ao_trial} '\n']);

        case 3
            aocs_trial=aocs_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aocs_trial} video_file_extension]);
            showMovieSendDoubleTrigger(file_video, window, dio, (iter), sound_frame, AOCS_trigger_value);    % also send the frame at which send the second trigger
            fwrite(fp, [video_files_list{iter,aocs_trial} '\n']);

        case 4
            aois_trial=aois_trial+1;
            file_video=fullfile(input_video_folder, [video_files_list{iter,aois_trial} video_file_extension]);
            showMovieSendDoubleTrigger(file_video, window, dio, (iter), sound_frame, AOIS_trigger_value);    % also send the frame at which send the second trigger
            fwrite(fp, [video_files_list{iter,aois_trial} '\n']);
    end

    % check if question must be shown
    if question_appearance(curr_stimulus_num)
%         putvalue(dio,question_trigger_value);
        [nx ny textbounds] = DrawFormattedText(window,'come era il suono appena sentito?\na) assente\nb) giusto\nc) sbagliato','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        WaitSecs(question_time);
    end

    Screen('FillRect', window, black, rect);
    Screen('Flip', window);
    iti=round(iti_time+rand(1));

    % check if 'p' is pressed in order to pause the experiment
    can_pause=1;
    start_time=GetSecs;
    while is_paused == 0
        [keyIsDown,secs, keyCode, deltaSecs] = KbCheck;
        if (keyIsDown && can_pause == 1)
            if KbName(keyCode) == 'p'
                is_paused=1;
                WaitSecs(0.2);
                break
            end
        end 
        elapsed=GetSecs-start_time;
        if elapsed > iti
            break;
        end            

    end  
    can_pause=0;

    % check if half of experiment is reached
    if (curr_stimulus_num == N_tot_stimuli/2)
        [nx ny textbounds] = DrawFormattedText(window,'la prima parte dell esperimento e` finita\nriposati qualche minuto\nquando sei pronto, avvisa lo sperimentatore','center','center',white, 55 ,[],[],1.5);
        Screen('Flip',window);
        KbWait;
    end
end

 
ShowCursor;
Screen('Flip', window);
Screen('CloseAll');
sca;
catch err
    % This "catch" section executes in case of an error in the "try" section
    % above.  Importantly, it closes the onscreen window if it's open.
    Screen('CloseAll');
    err
    err.stack(1)
end
