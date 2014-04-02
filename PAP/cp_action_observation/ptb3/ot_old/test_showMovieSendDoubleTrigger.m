% functions:
% play a movie
% send a first trigger just before the first frame displayed
% send a second trigger at the the frame specified [second_trigger_frame]

function test_showMovieSendDoubleTrigger(moviename, win, port, first_trigger_value, second_trigger_frame, second_trigger_value )

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
while ~KbCheck
    % Wait for next movie frame, retrieve texture handle to it
    tex = Screen('GetMovieImage', win, movie);

    % Valid texture returned? A negative value means end of movie reached:
    if tex<=0
        % We're done, break out of loop:
        break;
    else
        frame_counter=frame_counter+1;
    end;

    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);

    if (frame_counter == 1)
%         disp('frame 1'); 
%         putvalue(port, first_trigger_value);
    elseif (frame_counter == second_trigger_frame)
%         putvalue(port, second_trigger_value);                
    else
        
          disp(['frame ' num2str(frame_counter)]); 
    end    
    
    % Update display:
     [nx ny textbounds] = DrawFormattedText(win,'azione con audio giusto','center', 0, [255 255 255], 55 ,[],[],1.5);
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