clear all
close all
ListenChar(2);
disp('----------------------START initiating mex files');
init_dummy_functions
disp('----------------------END initiating mex files');
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=0   ;
% ===================================================================
% WEBCAM SCREEN SETTINGS
% ===================================================================
init_webcam_screens

% ===================================================================
% AUDIO RECORDING
% ===================================================================
InitializePsychSound;
recording_freq=16000;

...handle_output_audio =  PsychPortAudio('Open', 0, 1, 0, 44100, 1);
...beep = MakeBeep(50,0.1);
...PsychPortAudio('FillBuffer', handle_output_audio, beep);
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
white = [255 255 255];

record_cam=1;
webcam_screen=0;
image_screen_id=2;
image_screen_wnd=0;

if debug
    W=320; H=240 ; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS  
% ===================================================================
... filename='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';
output_video_file='test_framerecording.avi';
output_audio_file='test_audiorecording.wav';
image='hand_circle.png';
video_length=3;
% ==================================================================================================
dropped_frames=0;
pts=zeros(1, webcam_settings.fps*video_length+10);
num_pts=0;
elapsed=0;
elapsed2=0;
dropped_frames=0;
tex=0;
% ==================================================================================================

try
    AssertOpenGL;
   
    [mainwnd, rect] = Screen('OpenWindow', webcam_screen, black, rec);    
    Screen('TextSize', mainwnd, 24);
    
    ...image_screen_wnd = Screen('OpenWindow', image_screen_id, black); 
    
    [nx, ny, textbounds] = DrawFormattedText(mainwnd,['elapsed timePRE: ' num2str(0 )], 1000, 720, white, 16, [], [], 1.5);    
    Screen('Flip',mainwnd);
    
    webcamscreens = open_webcam_screens(mainwnd, webcamscreens);
    webcamscreens = switch_capturing_webcam_screens(record_cam, webcamscreens);
    
    while 1
        if KbCheck
            break;
        end;
        update_webcam_screens(webcamscreens,'rotation', 90);
    end
    
    %==================================================================================================
    %==================================================================================================
    %==================================================================================================
    %==================================================================================================
    % START TRIAL
    
    webcamscreens.wcs(record_cam).other_snd_hndl = prepare_sound_recording(webcamscreens.wcs(record_cam).other_audio_id, video_length, recording_freq);
    webcamscreens.wcs(record_cam).file_ptr = Screen('CreateMovie', webcamscreens.wcs(record_cam).wndptr, output_video_file, [], [], [], webcamscreens.settings.codec);

    WaitSecs(1);
    ...showImageNseconds(file_cue, experimenter_cue_wnd, -1);                                      ... don't wait and keep image
    ...if send_out_trigger
    ...    put_trigger_linux(address, cue_cross_trigger_value, trigger_duration, portnum);
    ...end      
    ...showImageNseconds(file_cue, subjects_screens{observing_subject}, cue_time, 0, black);       ... wait 1 sec and then remove image

    [tex, pt, df] = Screen('GetCapturedImage', webcamscreens.wcs(record_cam).wndptr, webcamscreens.wcs(record_cam).grabber, 1); 
    start_sound_recording(webcamscreens.wcs(record_cam).other_snd_hndl);

    start_pt = pt;

    ...if send_out_trigger
    ...    put_trigger_linux(address, cue_trigger_value, trigger_duration, portnum);
    ...end  

    while 1 
        [pt, df] = update_recording_webcam_screen_addfrontframe(webcamscreens.wcs(record_cam), 'rotation', 90);

        elapsed = pt - start_pt;
        if (elapsed >= video_length)
            break;
        end
    end

    ...if send_out_trigger
    ...    put_trigger_linux(address, end_trial_trigger_value, trigger_duration, portnum);
    ...end 

    stop_sound_recording_save2file( webcamscreens.wcs(record_cam).other_snd_hndl, output_audio_file, recording_freq ); 
    Screen('FinalizeMovie', webcamscreens.wcs(record_cam).fileptr);  

    webcamscreens = switch_capturing_webcam_screens(record_cam, webcamscreens);    
    
    
    
%     webcamscreens = start_movie_recording(record_cam, output_video_file, webcamscreens);   
%     
%     ...showImageNseconds(image, image_screen_wnd, 1);
%     ...Screen('FillRect', image_screen_wnd, black);
%     ...Screen('Flip',image_screen_wnd);
%     
%     ...webcamscreens = switch_webcam_screens_recording_frame_by_frame(record_cam, video_filename, webcamscreens);   
%     [tex, pt, df]=Screen('GetCapturedImage', webcamscreens.wcs(record_cam).wndptr, webcamscreens.wcs(record_cam).grabber, 1); 
%     ...webcamscreens.wcs(record_cam).own_snd_hndl = start_sound_recording(webcamscreens.wcs(record_cam).own_audio_id, video_lenght, recording_freq);
%     
%     start_df = df;
%     start_pt = pt;
%     elapsed = 0;
%     while 1 
%         
%         [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePRE: ' num2str(elapsed)],1000,720 ,white, 16 ,[],[],1.5);        
%         Screen('Flip',mainwin);        
%         
%         num_pts=num_pts+1;   
%              
%         ...[tex, pt, df] = update_recording_webcam_screen_addframe_return_tex(webcamscreens.wcs(record_cam), 'prev_frame', tex, 'rotation', 90);
%         [pt, df] = update_recording_webcam_screen_addfrontframe(webcamscreens.wcs(record_cam), 'rotation', 90);
%         dropped_frames = dropped_frames + df - start_df;
%         pts(num_pts) = pt - start_pt;
%         
%         ...if (num_pts == 1)
%         ...    PsychPortAudio('Start', handle_output_audio, 1, 0, 1);
%         ...end
%         
%         elapsed = pt - start_pt;
%         if (elapsed >= video_lenght)
%             break;
%         end
%         
%         if (num_pts>1)
%             pts2(num_pts)=pt-pts(num_pts-1)-start_pt;
%         end
%         
%  
%     end
%     stop_sound_recording_save2file( webcamscreens.wcs(record_cam).own_snd_hndl, sound_filename, recording_freq ); 
%     Screen('FinalizeMovie', webcamscreens.wcs(record_cam).fileptr);   
    
    disp(['dropped frames: ' num2str(dropped_frames)]);
    disp(['displayed frames: ' num2str(num_pts)]);
    disp(['total frames: ' num2str(num_pts+dropped_frames)]);
    ...pts
    ...pts2
    

    stop_webcam_screens(webcamscreens);
    Screen('CloseAll'); 
    ListenChar(0);

catch error
    % display error
    sca;
    error.identifier
    error.message
    error.stack
    
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll');
    ListenChar(0);
end

