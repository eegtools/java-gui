% functions:
% play a movie
% send a first trigger just before the first frame displayed
% send a second trigger at the the frame specified [second_trigger_frame]
% the duration of the trigger is to avoid trigger overlapping AND trigger detection even subsampling



%                                       file_video, window, dio,    4,             sound_frame,         AOCS_trigger_value,   test
function showMovieSendDoubleTrigger_cla_2(moviename, win, dio, first_trigger_value, second_trigger_frame, second_trigger_value,test,duration )


% Check if Psychtoolbox is properly installed:
AssertOpenGL;

if nargin < 1 || isempty(moviename)
    disp('input file name not specified');
    return
end

try

% Open movie file:
movie = Screen('OpenMovie', win, moviename);

% Start playback engine:
Screen('PlayMovie', movie, 1);

frame_counter=0;

% Playback loop: Runs until end of movie or keypress:
while 1
%     if~test 
%           WaitSecs(0.02);putvalue(dio,0);
%         
%     end
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);

    % Valid texture returned? A negative value means end of movie reached:
    frame_counter=frame_counter+1;
    if tex<=0
        % We're done, break out of loop:
        break;
    end;

    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);

%      disp(['frame ' num2str(frame_counter)]);
    if (frame_counter == 1)
        if~test 
            put_trigger( first_trigger_value,dio,duration);
        else
            disp(['first frame, sound frame @ ' num2str(second_trigger_frame)]);
        end
%     elseif (frame_counter == 2)
%         if~test
%             WaitSecs(0.02);putvalue(dio, 0);
%         end
%     elseif (frame_counter == second_trigger_frame)

        if~test
            WaitSecs(0.02);put_trigger( second_trigger_value,dio,duration);  
            
        else
            disp('@@@@@@@@@ 2nd trigger @@@@@@@@@@@@@@');
        end
    end    
    
    % Update display:
    Screen('Flip', win);

    % Release texture:
    Screen('Close', tex);
end;

% Stop playback:
Screen('PlayMovie', movie, 0);

% Close movie:
Screen('CloseMovie', movie);


catch
  psychrethrow(psychlasterror);
  sca;
end

return;