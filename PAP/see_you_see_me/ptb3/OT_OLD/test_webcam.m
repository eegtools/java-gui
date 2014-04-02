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
webcam_settings.pixel_depth = 0; % default
webcam_settings.fps=30;
webcam_settings.drop_frames_playback=1;  % set 1 for istantaneous video-feedback or eye tracking (deliver the most recently acquired frame, dropping previously captured but not delivered)
webcam_settings.drop_frames_recording=0;  % for recording, do not drop frames
webcam_settings.num_buff=[]; webcam_settings.allow_fallback=[];
webcam_settings.filename=[];  % by default do not write to file
webcam_settings.rec_flags=[];
webcam_settings.capt_engine=[];

webcamscreen_id_list={20000, 20001};
num_webcamscreen=length(webcamscreen_id_list);

% array definition
webcamscreen_ptr_list=cell(num_webcamscreen);
webcamscreen_position_list=cell(num_webcamscreen);
webcamscreen_grabber_list=cell(num_webcamscreen);

% screen position
webcamscreen_position_list{1}=[50 50 370 290];
webcamscreen_position_list{2}=[420 50 740 290];
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
screenid=max(Screen('Screens'));

if debug
    W=1027; H=500; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ==================================================================================================
% ==================================================================================================
% ==================================================================================================
% ==================================================================================================
% ==================================================================================================
try
    AssertOpenGL;
    
    [mainwin, rect] = Screen('OpenWindow', screenid, black, rec);
    Screen('Flip',mainwin);

    for wcs=1:num_webcamscreen
        webcamscreen_ptr_list{wcs}=Screen('OpenWindow', mainwin, 0, webcamscreen_position_list{wcs});
        webcamscreen_grabber_list{wcs}= Screen('OpenVideoCapture', webcamscreen_ptr_list{wcs}, webcamscreen_id_list{wcs}, webcam_settings.cam_screen, webcam_settings.pixel_depth, webcam_settings.num_buff, webcam_settings.allow_fallback, filename, webcam_settings.rec_flags, webcam_settings.capt_engine);
        Screen('StartVideoCapture', webcamscreen_grabber_list{wcs}, webcam_settings.fps, webcam_settings.drop_frames_playback);
    end

    tex=0;

    while 1 
        if KbCheck
            break;
        end;
        for wcs=1:num_webcamscreen
            [tex pts nrdropped]=Screen('GetCapturedImage', webcamscreen_ptr_list{wcs}, webcamscreen_grabber_list{wcs}, 1); 
            if (tex>0)
                % Perform first-time setup of transformations, if needed:
                Screen('DrawTexture', webcamscreen_ptr_list{wcs}, tex);
                Screen('Flip', webcamscreen_ptr_list{wcs});
                Screen('Close', tex);
                tex=0;
            end;            
        end
    end;
    % ====================================
    % END RECORDING
    % ====================================
    for wcs=1:num_webcamscreen   
        Screen('StopVideoCapture', webcamscreen_grabber_list{wcs});
        Screen('CloseVideoCapture', webcamscreen_grabber_list{wcs});
    end
    Screen('CloseAll');

catch error
    % display error
    error.identifier
    error.message
    error.stack
    
    % close wcs
    for wcs=1:num_webcamscreen   
        Screen('StopVideoCapture', webcamscreen_grabber_list{wcs});
        Screen('CloseVideoCapture', webcamscreen_grabber_list{wcs});
    end
    
    Screen('CloseAll');
end
