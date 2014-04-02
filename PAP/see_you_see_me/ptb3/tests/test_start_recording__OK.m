 clear all
close all
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=0;
% ===================================================================
% WEBCAM SCREEN SETTINGS
% ===================================================================
webcam_settings.cam_screen = [0 0 320 240];
webcam_settings.pixel_depth = 4; % default
webcam_settings.fps=30;
webcam_settings.drop_frames_playback=1;  % for istantaneous video-feedback or eye tracking (deliver the most recently acquired frame, dropping previously captured but not delivered)
webcam_settings.drop_frames_recording=0; % for recording, do not drop frames
webcam_settings.num_buff=[]; 
webcam_settings.allow_fallback=[];
webcam_settings.filename=[];  % by default do not write to file
webcam_settings.capt_engine=3;  % set to GStreamer, 0: QuickTime, 1: Firewire libdc1394-V2
webcam_settings.codec=':CodecType=DEFAULTencoder';

webcam_settings.rec_flags=1 + 2 + 16 + 64;  %   0: only video, 2: also audio, 4: only record, no captured data, 16: use parallel background thread ...
                             %  32: try best textures, 64: timestamps management ...
                             % by default, videorate converter is applied only if recording is active and is applied to both live capture and recording
                             % 128: force use of videorate converter also in pure "only live capturing"
                             % 256: in combined live capture and recording, will restrict video framerate conv to recorded video stream only
                             % 512: apply roirectangle ALSO to recording video 
                             % 1024: disable roirectangle application to live video
% ===================================================================
% WEBCAM SCREEN STRUCTURE
% ===================================================================

webcamscreens.settings=webcam_settings;
webcamscreens.wcs(1)= struct('device_id', 20000, 'position', [0 50 690 530],    'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
...webcamscreens.wcs(2)= struct('device_id', 20001, 'position', [650 50 1270 530], 'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
webcamscreens.num=length(webcamscreens.wcs);
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
white = [255 255 255];
webcam_screen=1; 

if debug
    W=750; H=300; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS
% ===================================================================
filename='test_continuos.avi'; ... 'E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';
video_lenght=3;
% ==================================================================================================
% ==================================================================================================
try
    AssertOpenGL;
    record_cam=1;
    [mainwin, rect] = Screen('OpenWindow', webcam_screen, black, rec);
    Screen('Flip',mainwin);

    for w=1:webcamscreens.num
        if (webcamscreens.wcs(w).wndptr == 0)
            webcamscreens.wcs(w).wndptr=Screen('OpenWindow', mainwin, 0, webcamscreens.wcs(w).position);
        end
        webcamscreens.wcs(w).grabber= Screen('OpenVideoCapture', webcamscreens.wcs(w).wndptr, webcamscreens.wcs(w).device_id, webcamscreens.settings.cam_screen, ...
                                                              webcamscreens.settings.pixel_depth, webcamscreens.settings.num_buff, webcamscreens.settings.allow_fallback, ...
                                                              '', webcamscreens.settings.rec_flags, webcamscreens.settings.capt_engine);
        Screen('StartVideoCapture', webcamscreens.wcs(w).grabber, webcamscreens.settings.fps, 0 );                                                  
    end
    
    disp('set OpenVideoCapture')

    [oldFontName,oldFontNumber]=Screen('TextFont', mainwin, '-schumacher-clean-bold-r-normal--0-0-75-75-c-0-iso646.1991-irv');
    Screen('TextSize',mainwin, 20);
    [nx, ny, textbounds] = DrawFormattedText(mainwin,['timePRE: ' num2str(0 )],20,700 ,white, 16 ,[],[],1.5);    
    [nx, ny, textbounds] = DrawFormattedText(mainwin,['timePOST: ' num2str(0 )],20,720 ,white, 16 ,[],[],1.5);    
    Screen('Flip',mainwin);
   dummy=GetSecs;
    
    
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
    pre_start_time=GetSecs
    mname = sprintf('SetNewMoviename=%s', filename);
    Screen('SetVideoCaptureParameter', webcamscreens.wcs(record_cam).grabber, mname);
    Screen('StopVideoCapture', webcamscreens.wcs(record_cam).grabber);
    Screen('StartVideoCapture', webcamscreens.wcs(record_cam).grabber, webcamscreens.settings.fps, 1);
    start_time=GetSecs
    
    
    
    current=GetSecs
    elapsedPRE=current-pre_start_time
    elapsedPOST=current-start_time

    disp(['set StartVideoCapture after :' num2str(elapsedPRE)]);
    disp(['set StartVideoCapture after :' num2str(elapsedPOST)]);
    
    
    while 1

        current=GetSecs;
        elapsedPRE=current-pre_start_time;
        elapsedPOST=current-start_time;
        
        
        [nx, ny, textbounds] = DrawFormattedText(mainwin,['timePRE: ' num2str(elapsedPRE)],20,700 ,white, 16 ,[],[],1.5);    
        [nx, ny, textbounds] = DrawFormattedText(mainwin,['timePOST: ' num2str(elapsedPOST)],20,720 ,white, 16 ,[],[],1.5);    
        Screen('Flip',mainwin);        
        
        
        if KbCheck
            break;
        end;
        update_webcam_screens(webcamscreens);
        if ((GetSecs-start_time) > video_lenght)
            break;
        end
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
