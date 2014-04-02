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
webcam_settings.cam_screen = [0 0 640 480];
webcam_settings.pixel_depth = 4; % default
webcam_settings.fps=30;
webcam_settings.drop_frames_playback=1;  % for istantaneous video-feedback or eye tracking (deliver the most recently acquired frame, dropping previously captured but not delivered)
webcam_settings.drop_frames_recording=0; % for recording, do not drop frames
webcam_settings.num_buff=[]; 
webcam_settings.allow_fallback=[];
webcam_settings.filename=[];  % by default do not write to file
webcam_settings.capt_engine=3;  % set to GStreamer, 0: QuickTime, 1: Firewire libdc1394-V2
webcam_settings.codec=':CodecType=DEFAULTencoder'; .... ':CodecType=DEFAULTencoder AddAudioTrack'; it works, but you have to insert some audio, otherwise file is corrupted
...webcam_settings.codec=':CodecType=x264enc Keyframe=10 Videobitrate=5000';
webcam_settings.rec_flags=1 + 16 + 32 + 64 + 128 ;  %   0: only video, 2: also audio, 4: only record, no captured data, 16: use parallel background thread ...
                             %  32: try best textures, 64: timestamps management ...
                             % by default, videorate converter is applied only if recording is active and is applied to both live capture and recording
                             % 128: force use of videorate converter also in pure "only live capturing"
                             % 256: in combined live capture and recording, will restrict video framerate conv to recorded video stream only
                             % 512: apply roirectangle ALSO to recording video 
                             % 1024: disable roirectangle application to live video
% ===================================================================
% WEBCAM SCREEN STRUCTURE
% ===================================================================
% id of the DirectShow webcams as obtained from: Screen('VideoCaptureDevices')
webcamscreens.settings=webcam_settings;
webcamscreens.wcs(1)= struct('device_id', 20000, 'position', [0 50 480 690],    'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0, 'own_snd_hndl', [], 'own_audio_id', 2, 'other_snd_hndl', [], 'other_audio_id', 6);    
...webcamscreens.wcs(2)= struct('device_id', 20001, 'position', [650 50 1270 530], 'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0, 'own_audio_id', 6, 'other_audio_id', 2);    
webcamscreens.num=length(webcamscreens.wcs);


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
video_filename='test_framerecording.avi';
sound_filename='test_audiorecording.wav';
image='hand_circle.png';
video_lenght=3;
% ==================================================================================================
dropped_frames=0;
pts=zeros(1, webcam_settings.fps*video_lenght+10);
num_pts=0;
elapsed=0;
elapsed2=0;
dropped_frames=0;
tex=0;
% ==================================================================================================

try
    AssertOpenGL;
   
    [mainwin, rect] = Screen('OpenWindow', webcam_screen, black, rec);    
    Screen('TextSize', mainwin, 24);
    
    ...image_screen_wnd = Screen('OpenWindow', image_screen_id, black); 
    
    [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePRE: ' num2str(0 )], 1000, 720, white, 16, [], [], 1.5);    
    Screen('Flip',mainwin);
    
    % start playback
    webcamscreens = start_webcam_screens(mainwin, webcamscreens);
    
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
    webcamscreens = start_movie_recording(record_cam, video_filename, webcamscreens);   
    
    ...showImageNseconds(image, image_screen_wnd, 1);
    ...Screen('FillRect', image_screen_wnd, black);
    ...Screen('Flip',image_screen_wnd);
    
    ...webcamscreens = switch_webcam_screens_recording_frame_by_frame(record_cam, video_filename, webcamscreens);   
    [tex, pt, df]=Screen('GetCapturedImage', webcamscreens.wcs(record_cam).wndptr, webcamscreens.wcs(record_cam).grabber, 1); 
    ...webcamscreens.wcs(record_cam).own_snd_hndl = start_sound_recording(webcamscreens.wcs(record_cam).own_audio_id, video_lenght, recording_freq);
    
    start_df = df;
    start_pt = pt;
    elapsed = 0;
    while 1 
        
        [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePRE: ' num2str(elapsed)],1000,720 ,white, 16 ,[],[],1.5);        
        Screen('Flip',mainwin);        
        
        num_pts=num_pts+1;   
             
        ...[tex, pt, df] = update_recording_webcam_screen_addframe_return_tex(webcamscreens.wcs(record_cam), 'prev_frame', tex, 'rotation', 90);
        [pt, df] = update_recording_webcam_screen_addfrontframe(webcamscreens.wcs(record_cam), 'rotation', 90);
        dropped_frames = dropped_frames + df - start_df;
        pts(num_pts) = pt - start_pt;
        
        ...if (num_pts == 1)
        ...    PsychPortAudio('Start', handle_output_audio, 1, 0, 1);
        ...end
        
        elapsed = pt - start_pt;
        if (elapsed >= video_lenght)
            break;
        end
        
        if (num_pts>1)
            pts2(num_pts)=pt-pts(num_pts-1)-start_pt;
        end
        
 
    end

    disp(['dropped frames: ' num2str(dropped_frames)]);
    disp(['displayed frames: ' num2str(num_pts)]);
    disp(['total frames: ' num2str(num_pts+dropped_frames)]);
    pts
    pts2
    
    ...stop_sound_recording_save2file( webcamscreens.wcs(record_cam).own_snd_hndl, sound_filename, recording_freq ); 
    Screen('FinalizeMovie', webcamscreens.wcs(record_cam).fileptr);   
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

