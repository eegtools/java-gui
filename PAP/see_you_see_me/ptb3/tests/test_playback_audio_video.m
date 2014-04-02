clear all
close all
ListenChar(2);
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=0;
% ===================================================================
% AUDIO RECORDING
% ===================================================================
InitializePsychSound;
recording_freq=16000;

% =================================================================== 
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
white = [255 255 255];

webcam_screen=0; 

if debug
    W=640; H=640 ; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS  
% ===================================================================
... filename='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';
input_path='/media/vicon/Data/behaviour_platform_svn/EEG_Tools/see_you_see_me/ptb3/tests';
video_filename=fullfile(input_path, 'test_framerecording.avi'); 
sound_filename=fullfile(input_path, 'test_audiorecording.wav');
video_lenght=3;
% ==================================================================================================
init_dummy_functions
try
    AssertOpenGL;
   
    [mainwin, rect] = Screen('OpenWindow', webcam_screen, black, rec);    
    ...[oldFontName,oldFontNumber]=Screen('TextFont', mainwin, '-schumacher-clean-bold-r-normal--0-0-75-75-c-0-iso646.1991-irv');
    oldTextSize=Screen('TextSize', mainwin, 24);

    pahandle = PsychPortAudio('Open', 0, [], 0, recording_freq, 2);
    
    
    [nx, ny, textbounds] = DrawFormattedText(mainwin, 'press a key to start playback an audio/video file',150,150 ,white, 16 ,[],[],1.5);    
    Screen('Flip',mainwin);
    while 1
        if KbCheck
            break;
        end;
     end
    
    %==================================================================================================
    %==================================================================================================
    %==================================================================================================
    %==================================================================================================
    %                        (file_video,       file_audio,       win,   dio, start_video_trigger_value, audio_frame, audio_trigger_value, end_video_trigger,       send_out_trigger,duration,         ao)
  ...  showMovieAudioTriggers_mm(input_video_file, input_audio_file, wnd_1,  {address, portnum},  cue_trigger_value,  1,       [],   end_trial_trigger_value, 1,     trigger_duration, pahandle);    % also send the frame at which send the second trigger
    
    
    %                      file_video,     file_audio,     win,     dio, video_trigger_value, audio_frame, audio_trigger_value,send_out_trigger,duration,ao)
    showMovieAudioTriggers(       video_filename,   sound_filename, mainwin, [],                 1,                 1,          2,    0,                    0,  0.02,    pahandle)
    
    ...sca
    PsychPortAudio('Close');
    ListenChar(0);
    
catch error
    % display error
    sca;
    error.identifier
    error.message
    error.stack
    
    Screen('CloseAll');
    ListenChar(0);
    
end
