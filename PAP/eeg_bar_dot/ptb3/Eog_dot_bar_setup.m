

%%%%%%%%%%%%%%%%%%%%%%%      VISUAL STIMULI   %%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc


Screen('Preference', 'SkipSyncTests',0);
Screen('Preference', 'VisualDebugLevel', 0);
Screen('Preference','SuppressAllWarnings', 0);


prompt={'Subject Initial:','Number of Trial','Number of calibration dots'};
name='Setup';
numlines=1;
defaultanswer={'XX','10','10'};
answer=inputdlg(prompt,name,numlines,defaultanswer);

%---------------   PARAMETERS and initialization  ----------------%
whichScreen = 0;  %working window
%--------------------      COLORS     ---------------------%
white = [255 255 255];
gray = [100 100 100];
black = [0 0 0];
blue =  [100 100 250];
red = [200 50 50];
green = [21 152 18];

%----------------------- TTL INIT --------------------------%
TTLflag = 'test';
if not(exist('TTL_obj','var'))
    [TTL_obj] = init_TTL(TTLflag);
end

% Defining main structure


try
    %---------------------  open working windows ---------------------%
    % on line window
    rec = Screen('Rect',0);
    [W, H]=Screen('WindowSize', 0);
    [window, rect] = Screen('OpenWindow', whichScreen, black, rec);
    monitorFlipInterval = Screen('GetFlipInterval', window);

    %offline window
    Page = Screen(window, 'OpenOffScreenWindow');
    Screen('FillRect', Page, 1);
    Screen('HideCursorHelper', window);

    % Define center of screen
    center.x = round(rect(3)/2);
    center.y = round(rect(4)/2);

    
    %Define generic white oval with black dot inside in (0,0)
    oval.w.radius = 8; %dot radius
    oval.b.radius = 4;
    oval.w.coord = [-oval.w.radius -oval.w.radius oval.w.radius oval.w.radius]';
    oval.b.coord = [-oval.b.radius -oval.b.radius oval.b.radius oval.b.radius]';

    % Prepare some common data
    calib_par.isi = 1.5; % Time [s] between cross and dot
    calib_par.upperY = 0.55; % Percentage distance from top
    calib_par.lowerY = 0.40; % Percentage distance from bottom
    calib_par.border = .1; % Distance from border left-right < 0.5
    calib_par.Ndots = str2double(answer{3}); %Number of calibration points
    calib_par.xleft = 100;
    calib_par.yleft = 900;
    
    
    
    % Define generic cross in (0,0) with arbitraru dimension;
    cross_par.dim = 8;
    cross_par.coord = [-cross_par.dim cross_par.dim 0 0;0 0  -cross_par.dim cross_par.dim];
    cross.yposition =  H * calib_par.upperY;
    
    
    

    calib_par.x_pos = linspace( W * calib_par.border, ...
        W * (1 - calib_par.border),...
        calib_par.Ndots);

    flag_trial = 1;
    case_status = 'choosing';
    while flag_trial
        switch case_status
            case 'choosing'
                
                % Wait for user action to start acquisition
                Screen('Preference', 'TextRenderer', 1);
                Screen('TextSize',window, 21);
                DrawFormattedText(window, 'C :: eog cal / T :: trial / S :: Screen Cal / Quit' , 'Center', center.y, white);
                DrawFormattedText(window, 'V :: show eog Screen / B :: show trial ' , 'Center', center.y+20, white);
                Screen('Flip', window);
                FlushEvents;
                [secs, keyCode, deltaSecs] = KbPressWait;
                ch = KbName(keyCode);
                % Change in lowercase
                ch = lower(ch);
                if not(isempty(strfind('ctsqvb',ch)))  
                    case_status = ch;
                else
                    case_status  = 'choosing';
                end                
            case 'v'
                % Show all elements in eog calibration
                xcross = center.x;
                ycross = H * calib_par.upperY;
                cross_coord = cross_par.coord + repmat([xcross;ycross],1,4);
                % Display Cross
                Screen('DrawLines', window, cross_coord, 3, green);

                %Display Dots
                for N = 1 : calib_par.Ndots

                    %Display Dot
                    xdot = calib_par.x_pos(N);
                    ydot = H * (1 - calib_par.lowerY);
                    dot_coord = [oval.w.coord  oval.b.coord] + ...
                        repmat([xdot;ydot;xdot;ydot],1,2);
                    Screen('FillOval', window, [white' black'],dot_coord);
                end
                Screen('Flip', window);
                [secs, keyCode, deltaSecs] = KbPressWait;
                case_status = 'choosing';

            case 'b'
                % Show all elements in Trial sequence
                % Show Cross
                x = center.x;
                y = H * calib_par.upperY;
                cross_coord = cross_par.coord + repmat([x;y],1,4);
                Screen('DrawLines', window, cross_coord, 3, green);

                % Show Left Dot
                x = calib_par.x_pos(1);
                y = H * (1 - calib_par.lowerY);
                dot_coord = [oval.w.coord  oval.b.coord] + ...
                    repmat([x;y;x;y],1,2);
                Screen('FillOval', window, [white' black'],dot_coord);

                % Show Right Dot
                x = calib_par.x_pos(calib_par.Ndots);
                dot_coord = [oval.w.coord  oval.b.coord] + ...
                    repmat([x;y;x;y],1,2);
                Screen('FillOval', window, [white' black'],dot_coord);

                % Show Bar
                Screen('DrawLines', window, [0 W;y,y], 8,gray);
                Screen('Flip', window);
                [secs, keyCode, deltaSecs] = KbPressWait;
                case_status = 'choosing';




            case 'c'
                % Starting calibration phase, start with a cross in x centered
                % in high part of screen and then show N dot equispaced in lower
                % part of screen in order to produce saccadic movement
                % Compute Cross Coordinates
                xcross = center.x;
                ycross = H * calib_par.upperY;
                cross_coord = cross_par.coord + repmat([xcross;ycross],1,4);

                % Start Sequence : is N block of cross-wait-dot-wait
                for N = 1 : calib_par.Ndots
                    % Display Cross
                    Screen('DrawLines', window, cross_coord, 3, green);
                    Screen('Flip', window);
                    % Wait
                    % If it's the first presentation wait until user action
                    % and then start vicon end sequence
                    if N == 1
                        [secs, keyCode, deltaSecs] = KbPressWait;
                        % Start Vicon Recording
                        status = start_vicon(TTLflag, TTL_obj);
                    else
                        WaitSecs(calib_par.isi);
                    end
                    %Display Dot
                    xdot = calib_par.x_pos(N);
                    ydot = H * (1 - calib_par.lowerY);
                    dot_coord = [oval.w.coord  oval.b.coord] + ...
                        repmat([xdot;ydot;xdot;ydot],1,2);
                    Screen('FillOval', window, [white' black'],dot_coord);
                    Screen('Flip', window);
                    % Wait
                    WaitSecs(calib_par.isi);
                end
                % Display Last Cross
                Screen('DrawLines', window, cross_coord, 3, green);
                Screen('Flip', window);
                % Wait
                WaitSecs(calib_par.isi);
                % Stop Vicon
                status = stop_vicon(TTLflag, TTL_obj);
                point.xcross = xcross;
                point.ycross = ycross;
                point.xdot = calib_par.x_pos;
                point.ydot = ydot;
                save([answer{1} '_eogCAL' '.mat'],'point');
                case_status = 'choosing';
            case 's'
                % Screen Calibration show three line. We must measure this and
                % write as input at the end of procedure (mm are used)
                % Orizontal Line
                dl = 50;
                dy = 100;
                dx = 100;
                Screen('DrawLines', window, [center.x center.x+dl ; center.y center.y], 1, white);
                Screen('DrawLines', window, [center.x center.x+dl ; center.y+dy center.y+dy], 1, white);
                Screen('DrawLines', window, [center.x center.x ; center.y center.y+dl], 1, white);
                Screen('DrawLines', window, [center.x+dy center.x+dy ; center.y center.y+dl], 1, white);
                Screen('Flip', window);
                [secs, keyCode, deltaSecs] = KbPressWait;
                Screen('CloseAll');
                sca;
                dx_p =  input('dx in mm : ');
                dy_p =  input('dy in mm : ');
                screen_calibration.dx = dx;
                screen_calibration.dy = dy;
                screen_calibration.dx_pixel = dx_p;
                screen_calibration.dy_pixel = dy_p;
                scal.subject = answer{1};
                scal.Ntrial = answer{2};
                scal.Ndots = answer{3};
                scal.screen = screen_calibration;
                save([scal.subject '_screenCAL' '.mat'],'scal');
                % Need to create e new windows;
                rec = Screen('Rect',0);
                [W, H]=Screen('WindowSize', 0);
                [window, rect] = Screen('OpenWindow', whichScreen, black, rec);
                Screen('HideCursorHelper', window);
                case_status = 'choosing';

            case 't'
                % Starting trial sequence show : cross, left dot(id=1), cross,
                % right dot (id = N), cross, bar
                % Show cross
                % Compute Cross Coordinates
                for trial_seq = 1:str2double(answer{2})
                    x = center.x;
                    y = H * calib_par.upperY;
                    cross_coord = cross_par.coord + repmat([x;y],1,4);
                    Screen('DrawLines', window, cross_coord, 3, green);
                    Screen('Flip', window);
                    % Wait until user keypress. Prepare subject to fix croos
                    % and star vicon acquisition
                    [secs, keyCode, deltaSecs] = KbPressWait;
                    %Start Vicon Acquisition
                    status = start_vicon(TTLflag, TTL_obj);
                    % Show Left Dot
                    x = calib_par.x_pos(1);
                    y = H * (1 - calib_par.lowerY);
                    dot_coord = [oval.w.coord  oval.b.coord] + ...
                        repmat([x;y;x;y],1,2);
                    Screen('FillOval', window, [white' black'],dot_coord);
                    Screen('Flip', window);
                    % Wait
                    WaitSecs(calib_par.isi);
                    % Show cross
                    Screen('DrawLines', window, cross_coord, 3, green);
                    Screen('Flip', window);
                    % Wait
                    WaitSecs(calib_par.isi);
                    % Show Right Dot
                    x = calib_par.x_pos(calib_par.Ndots);
                    dot_coord = [oval.w.coord  oval.b.coord] + ...
                        repmat([x;y;x;y],1,2);
                    Screen('FillOval', window, [white' black'],dot_coord);
                    Screen('Flip', window);
                    % Wait
                    WaitSecs(calib_par.isi);
                    % Show cross
                    Screen('DrawLines', window, cross_coord, 3, green);
                    Screen('Flip', window);
                    % Wait
                    WaitSecs(calib_par.isi);

                    % Show Bar
                    Screen('DrawLines', window, [0 W;y,y], 8,gray);
                    Screen('Flip', window);
%                     xdot = calib_par.x_pos(3);
%                     ydot = H * (1 - calib_par.lowerY);
%                     dot_coord = [oval.w.coord  oval.b.coord] + ...
%                         repmat([xdot;ydot;xdot;ydot],1,2);
%                     Screen('FillOval', window, [white' black'],dot_coord);
%                     Screen('Flip', window);
                    WaitSecs(5);
                    % Stop Vicon
                    status = stop_vicon(TTLflag, TTL_obj);
                end
                case_status = 'q';
            case 'q'
                Screen('CloseAll');
                sca;
                disp('FINISH CORRECT')
                flag_trial = 0;
        end
    end
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack.line
end