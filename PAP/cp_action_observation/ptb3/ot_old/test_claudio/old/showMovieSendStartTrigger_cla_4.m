% functions:
% play a movie
% send a first trigger just before displaying first frame 

function showMovieSendStartTrigger_cla_4(file_video, win, dio, video_trigger_value,test,duration)

% Check if Psychtoolbox is properly installed:
AssertOpenGL;

if nargin < 1 || isempty(file_video)
    disp('input file name not specified');
    return
end

try

% Open movie file:
movie = Screen('OpenMovie', win, file_video);

% Start playback engine:
Screen('PlayMovie', movie, 1);

frame_counter=0;

% Playback loop: Runs until end of movie or keypress:
while 1
%     if~test 
%             WaitSecs(0.02);putvalue(dio,0);
%         
%     end
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
        if ~test
            put_trigger(video_trigger_value,dio,duration);
            
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