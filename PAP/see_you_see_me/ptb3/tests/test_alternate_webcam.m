clear all
close all
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 2);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=1;
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
webcam_settings.capt_engine=[];...3;  % set to GStreamer, 0: QuickTime, 1: Firewire libdc1394-V2
webcam_settings.codec=[];...':CodecType=DEFAULTencoder';
webcam_settings.rec_flags=1 + 16 + 64 + 128;  %   0: only video, 2: also audio, 4: only record, no captured data, 16: use parallel background thread ...
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
webcamscreens.wcs(1)= struct('device_id', 20001, 'position', [50 50 530 690],    'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
webcamscreens.wcs(2)= struct('device_id', 20000, 'position', [650 50 1130 690], 'wndptr', 0, 'grabber', 0, 'isRecording', 0,  'fileptr', 0);    
webcamscreens.num=length(webcamscreens.wcs);
% ===================================================================
% ===================================================================
% MAIN SCREEN SETTINGS
% ================================== =================================
black = [0 0 0];
white = [255 255 255];
screenid=0; ...min(Screen('Screens'));

if debug
    W=750; H=750; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ==================================================================================================
% ==================================================================================================
capturing_screen=1  ;
switch_count=0;
try
    AssertOpenGL;
    
    [mainwin, rect] = Screen('OpenWindow', screenid, black, rec);
    Screen('Flip',mainwin);

    % START PLAYBACK
    webcamscreens = open_webcam_screens(mainwin, webcamscreens);
    webcamscreens = switch_capturing_webcam_screens(capturing_screen, webcamscreens);
    
    
    
    ...Screen('SetVideoCaptureParameter', webcamscreens.grabbers{1}, 'PrintParameters')
    ...Screen('SetVideoCaptureParameter', webcamscreens.grabbers{2}, 'PrintParameters')
    ... res = Screen('SetVideoCaptureParameter', webcamscreens.grabbers{2}, 'Focusmode', 2);
    ...sca 
    ...% START RECORDING
    ...webcamscreens = start_webcam_screens(mainwin, webcamscreens,'filename', filename, 'drop_frame', webcam_settings.drop_frames_recording);
    
    while 1
        if KbCheck
            break;
        end;
        update_webcam_screen(webcamscreens.wcs(capturing_screen), 'rotation', 90);
    end
    
    % END PLAYBACK
    stop_webcam_screen(webcamscreens.wcs(capturing_screen));
    Screen('CloseAll');

 catch error
    % display error
    error.identifier
    error.message
    error.stack
    
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll');
end
