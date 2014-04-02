clear all
close all
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 2);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=0;
% ===================================================================
% WEBCAM SCREEN SETTINGS
% ===================================================================
webcam_settings.cam_screen = [0 0 640 480 ];
webcam_settings.pixel_depth = 4; % default
webcam_settings.fps=30;
webcam_settings.drop_frames_playback=1;  % for istantaneous video-feedback or eye tracking (deliver the most recently acquired frame, dropping previously captured but not delivered)
webcam_settings.drop_frames_recording=0; % for recording, do not drop frames
webcam_settings.num_buff=[]; 
webcam_settings.allow_fallback=[];
webcam_settings.filename=[];  % by default do not write to file
webcam_settings.capt_engine=3;  % set to GStreamer, 0: QuickTime, 1: Firewire libdc1394-V2
webcam_settings.codec=':CodecType=DEFAULTencoder'; ... ::: CodecSettings=AddAudioTrack=2@48000'; ...':CodecType=xvidenc'; ...':CodecType=DEFAULTencoder';
...webcam_settings.codec=':CodecType=x264enc Keyframe=10 Videobitrate=5000';
webcam_settings.rec_flags=1 + 16 + 64;  %   0: only video, 2: also audio, 4: only record, no captured data, 16: use parallel background thread ...
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
webcamscreens.wcs(1)= struct('device_id', 20000, 'position', [0 50 480 690],    'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
... webcamscreens.wcs(2)= struct('device_id', 20001, 'position', [650 50 1270 530], 'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
webcamscreens.num=length(webcamscreens.wcs);
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
white = [255 255 255];

if debug
    W=750; H=750; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS  
% ===================================================================
... filename='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';
filename='/media/vicon/Data/behaviour_platform_svn/EEG_Tools/see_you_see_me/ptb3/tests/test_fullrecording.avi';
video_lenght=3;
% ==================================================================================================
try
    AssertOpenGL;
    record_cam=1;
    webcam_screen=1;
    [mainwin, rect] = Screen('OpenWindow', webcam_screen  , black, rec);
    Screen('Flip',mainwin);

    [oldFontName,oldFontNumber]=Screen('TextFont', mainwin, '-schumacher-clean-bold-r-normal--0-0-75-75-c-0-iso646.1991-irv');
    
    webcamscreens = start_webcam_screens(mainwin, webcamscreens);
    
    while 1
        if KbCheck
            ...WaitSecs(0.2); 
            break;
        end;
        update_webcam_screens(webcamscreens, 'rotation', 90);
    end
    
    elapsed1=0;
    start_time1=GetSecs;
    
    webcamscreens = switch_webcam_screens_recording(record_cam, filename, webcamscreens);
    
    elapsed2=0;
    start_time2=GetSecs;
    while 1
        
        elapsed1=GetSecs-start_time1;
        elapsed2=GetSecs-start_time2;
        
        [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePRE: ' num2str(elapsed1)],20,720 ,white, 16 ,[],[],1.5);        
        [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePOST: ' num2str(elapsed2)],20,750 ,white, 16 ,[],[],1.5);        
        Screen('Flip',mainwin);
        if KbCheck
            break;
        end;
        update_webcam_screens(webcamscreens, 'rotation', 90);
    end

           

    stop_webcam_screens(webcamscreens);
    Screen('CloseAll'); 
    
    % START PLAYBACK
    ...webcamscreens = start_webcam_screens(mainwin, webcamscreens);
    ...% START RECORDING
    ...webcamscreens = start_webcam_screens(mainwin, webcamscreens,'filename', filename, 'drop_frame', webcam_settings.drop_frames_recording);
    ...webcamscreens = switch_webcam_screens_recording(1, filename, webcamscreens);
    ...start_recording(mainwin, filename, webcamscreens.settings.codec, webcamscreens.settings.rec_flags);
 
        
catch error
    % display error
    error.identifier
    error.message
    error.stack
    
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll');
end
