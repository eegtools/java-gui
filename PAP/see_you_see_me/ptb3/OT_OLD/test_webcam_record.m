% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=1;
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
webcamscreens.device_ids={20000, 20001};    % id of the DirectShow webcams as obtained from: Screen('VideoCaptureDevices')
webcamscreens.positions{1}=[50 50 370 290]; % positions of the windows containing the webcam screens
webcamscreens.positions{2}=[420 50 740 290];
... .................................................................
webcamscreens.settings=webcam_settings;
webcamscreens.num=length(webcamscreens.device_ids);
for w=1:webcamscreens.num; webcamscreens.wndptrs{w}=0; end
for w=1:webcamscreens.num; webcamscreens.isRecording{w}=0; end
webcamscreens.grabbers=cell(1,webcamscreens.num);
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
screenid=max(Screen('Screens'));

if debug
    W=750; H=300; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS
% ===================================================================
filename='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';

% ==================================================================================================
% ==================================================================================================
try
    AssertOpenGL;
    
    [mainwin, rect] = Screen('OpenWindow', screenid, black, rec);
    Screen('Flip',mainwin);


    % START PLAYBACK
    webcamscreens = start_webcam_screens(mainwin, webcamscreens);
    ...% START RECORDING
    ...webcamscreens = start_webcam_screens(mainwin, webcamscreens,'filename', filename, 'drop_frame', webcam_settings.drop_frames_recording);
    webcamscreens = switch_webcam_screens_recording(1, filename, webcamscreens);

    while 1
        if KbCheck
            break;
        end;
        update_webcam_screens(webcamscreens);
    end
    webcamscreens = switch_webcam_screens_recording(0, filename, webcamscreens);


    % END PLAYBACK
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll');
        
catch error
    % display error
    error.identifier
    error.message
    error.stack
    
    stop_webcam_screens(webcamscreens);
    Screen('CloseAll');
end
