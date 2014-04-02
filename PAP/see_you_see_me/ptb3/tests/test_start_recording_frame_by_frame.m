clear all
close all
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 2);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=0   ;
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
webcam_settings.codec=':CodecType=DEFAULTencoder';
...webcam_settings.codec=':CodecType=x264enc Keyframe=10 Videobitrate=5000';
webcam_settings.rec_flags=1 + 16 + 64;  %   0: only video, 2: also audio, 4: only record, no captured data, 16: use parallel background thread ...
                             %  32: try best textures, 64: timestamps management ...
                             % by default, videorate converter is applied only if recording is active and is applied to both live capture and recording
                             % 128: force use of videorate converter also in pure "only live capt uring"
                             % 256: in combined live capture and recording, will restrict video framerate conv to recorded video stream only
                             % 512: apply roirectangle ALSO to recording video 
                             % 1024: disable roirectangle application to live video
% ===================================================================
% WEBCAM SCREEN STRUCTURE
% ===================================================================
% id of the DirectShow webcams as obtained from: Screen('VideoCaptureDevices')
webcamscreens.settings=webcam_settings;
webcamscreens.wcs(1)= struct('device_id', 20000, 'position', [0 50 640 530],    'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
...webcamscreens.wcs(2)= struct('device_id', 20001, 'position', [650 50 1270 530], 'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
webcamscreens.num=length(webcamscreens.wcs);
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
white = [255 255 255];

record_cam=1;
webcam_screen=1; 

if debug
    W=320; H=240 ; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS  
% ===================================================================
... filename='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';
filename='test_framerecording.avi';
video_lenght=3;
% ==================================================================================================
dropped_frames=0;
pts=zeros(1, webcam_settings.fps*video_lenght+10);
num_pts=0;
elapsed1=0;
elapsed2=0;
dropped_frames=0;
tex=0;
% ==================================================================================================
try
    AssertOpenGL;
   
    [mainwin, rect] = Screen('OpenWindow', webcam_screen, black, rec);    
    [oldFontName,oldFontNumber]=Screen('TextFont', mainwin, '-schumacher-clean-bold-r-normal--0-0-75-75-c-0-iso646.1991-irv');
    [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePRE: ' num2str(0 )],20,720 ,white, 16 ,[],[],1.5);    
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
    % prepare video recording
    start_time2=GetSecs;    
    webcamscreens = switch_webcam_screens_recording_frame_by_frame( record_cam, filename, webcamscreens);    
    start_time1=GetSecs;

    while 1
        num_pts=num_pts+1;        
          
        if (elapsed1 >= video_lenght)
            break;
        end
        
        if KbCheck
            break;
        end;
        [tex, pt, df] = update_recording_webcam_screen_addframe_return_tex(webcamscreens.wcs(record_cam), 'prev_tex', tex, 'rotation', 90);
        ...[pt, df] = update_recording_webcam_screen_addframe(webcamscreens.wcs(record_cam), 'rotation', 90);
        dropped_frames = dropped_frames + df;
        pts(num_pts)=pt;
        
        
        if (num_pts == 1)
            start_time1=start_time1 +  pt;
        else
           elapsed1=GetSecs-start_time1;
        end

        ...elapsed2=GetSecs-start_time2;
        [nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePRE: ' num2str(elapsed1)],20,720 ,white, 16 ,[],[],1.5);        
        ...[nx, ny, textbounds] = DrawFormattedText(mainwin,['elapsed timePOST: ' num2str(elapsed2)],20,750 ,white, 16 ,[],[],1.5);        
        Screen('Flip',mainwin);  
    end

    disp(['dropped frames: ' num2str(dropped_frames)]);
    disp(['displayed frames: ' num2str(num_pts)]);
    disp(['total frames: ' num2str(num_pts+dropped_frames)]);
    pts
    
    Screen('FinalizeMovie', webcamscreens.wcs(record_cam).fileptr);   
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll'); 

catch error
    % display error
    sca;
    error.identifier
    error.message
    error.stack
    
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll');
end
