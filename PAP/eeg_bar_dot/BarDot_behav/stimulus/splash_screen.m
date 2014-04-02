% © EOG VICON ©
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% Splash Screen to choose action
%
% ch = splash_screen
%

function case_status = splash_screen(screen_param)
window = screen_param.window;
flag_trial = 1;
try
    while flag_trial
        % Wait for user action to start acquisition
        Screen('Preference', 'TextRenderer', 1);
        Screen('TextSize',window, 18);
        DrawFormattedText(window, 'E :: Calibration EOG [show N dot to calibrate EOG]' , 100,100, screen_param.color.white);
        DrawFormattedText(window, 'T :: Start Protocol ' , 100, 130,screen_param.color.white);
        DrawFormattedText(window, 'C :: Check' , 100, 160,screen_param.color.white);
        DrawFormattedText(window, 'Q :: Quit ' , 100, 190,screen_param.color.white);
        Screen('Flip', window);
        FlushEvents;
        [secs, keyCode, deltaSecs] = KbPressWait;
        ch = KbName(keyCode);
        % Change in lowercase
        ch = lower(ch);
        if not(isempty(strfind('etcq',ch)))
            case_status = ch;
            flag_trial = 0;
        end
    end   
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack.line
end



