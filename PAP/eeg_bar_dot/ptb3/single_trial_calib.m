%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       START CALIBRATION PHASE                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%t%%%%%%%%%%%%%%%
DrawFormattedText(window, 'Fix the stimuli on screen','Center', CROSS.yposition, screen_param.color.white);
Screen('Flip', window);

%wait untill pressing a key to start trial
[secs, keyCode, deltaSecs] = KbPressWait;
...status = start_vicon(acquisition_flag, TTL_obj);
pause(1);
Screen('Flip', window);
ListenChar(2);
%%%%%%%%%%%%%%
% Show cross %
%%%%%%%%%%%%%%
err = show_stimuli(CROSS,window,screen_param);
Screen('Flip', window);
pause(protocol_param.eog_calib_time);
%%%%%%%%%%%%%%%%%
% Show LEFT DOT
%%%%%%%%%%%%%
DOT.xposition = protocol_param.xleft; % Left position
DOT.yposition = CROSS.yposition;
err = show_stimuli(DOT,window,screen_param);
Screen('Flip', window);
pause(protocol_param.eog_calib_time);
%%%%%%%%%%%%%%
% Show Cross %
%%%%%%%%%%%%%%
err = show_stimuli(CROSS,window,screen_param);
Screen('Flip', window);
pause(protocol_param.eog_calib_time);
%%%%%%%%%%%%%
% Shot DotR %
%%%%%%%%%%%%%
DOT.xposition = protocol_param.xright; % Right position
DOT.yposition = CROSS.yposition;
err = show_stimuli(DOT,window,screen_param);
Screen('Flip', window);
pause(protocol_param.eog_calib_time);
