% functions:
% play a movie
% send a first trigger just before the first frame displayed
% send a second trigger at the the frame specified [second_trigger_frame]

function showMovie_Audio_SendMultipleTrigger(moviename, audioname, win, port)

if nargin < 1 || isempty(moviename)
    disp('input file name not specified');
    return
end

white = [255 255 255];

try

    % Open movie file:
    movie = Screen('OpenMovie', win, moviename);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);

    %%%%%%%%%%%%%%%%%% load sound into the card
    
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

        if (frame_counter == 45)
            Screen('FillRect', win, white, [0,0,100,100]);
        end
        
        % Update display:
        Screen('Flip', win);

        switch frame_counter
            case 1
                 putvalue(port, 1);
            case 2
%                 putvalue(port, 0);
            case 45
                 putvalue(port, 1); 
                 %%%%%%%%%%%%%%%%% start audio
            case 46
%                 putvalue(port, 0);   
        end            
        
        
        % Release texture:
        Screen('Close', tex);
    end;

    % Stop playback:
    Screen('PlayMovie', movie, 0);

    % Close movie:
    Screen('CloseMovie', movie);
%     putvalue(port, 1);

catch
    
    psychrethrow(psychlasterror);
    sca;
end

return;