% functions:
% play a movie
% send a first trigger just before the first frame displayed
% send a second trigger at the the frame specified [second_trigger_frame]

function showMovieSendDoubleTrigger(moviename, win, port, first_trigger_value, second_trigger_frame, second_trigger_value )

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
%         putvalue(port, first_trigger_value);
         %   disp(['first frame, sound frame @ ' num2str(second_trigger_frame)]);
    elseif (frame_counter == 2)
%         putvalue(port, 0);
       
    elseif (frame_counter == second_trigger_frame)
          %  disp('@@@@@@@@@ 2nd trigger @@@@@@@@@@@@@@');
%         putvalue(port, second_trigger_value);                
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
%         putvalue(port, 0);
% putvalue(port, 0);
catch
  psychrethrow(psychlasterror);
  sca;
end

return;