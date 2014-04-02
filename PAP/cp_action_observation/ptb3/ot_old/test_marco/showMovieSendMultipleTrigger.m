% functions:
% play a movie
% send a first trigger just before the first frame displayed
% send a second trigger at the the frame specified [second_trigger_frame]

function showMovieSendMultipleTrigger(moviename, win, port,ao)

if nargin < 1 || isempty(moviename)
    disp('input file name not specified');
    return
end

white = [255 255 255];
black = [0 0 0];

try

    % Open movie file:
    movie = Screen('OpenMovie', win, moviename);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);

    frame_counter=0;
    send_trigger = 0;
    
    for j = 1:90
        tex(j) = Screen('GetMovieImage', win, movie);
    end
    % Playback loop: Runs until end of movie or keypress:
    while 1
        % Wait for next movie frame, retrieve texture handle to it
        %tex = Screen('GetMovieImage', win, movie);

        % Valid texture returned? A negative value means end of movie reached:
        frame_counter = frame_counter+1
        
        if tex(frame_counter) <0
            % We're done, break out of loop:
            break
        end

        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex(frame_counter));

        switch frame_counter
            %case 1
             %    putvalue(port, 1);
            %case 2
            %     putvalue(port, 0);
%             case 41
%                  Screen('FillRect', win, white, [0,0,100,100]);
%                  putvalue(port, 1);                
%             case 42
%                  putvalue(port, 0);
%             case 43
%                  Screen('FillRect', win, white, [0,0,100,100]);
%                  putvalue(port, 1);                
             case 40
                  trigger(ao);
            case 45                 
                 Screen('FillRect', win, white, [0,0,100,100]);
                 send_trigger = 1;       
                 
            case 46
                Screen('FillRect', win, black, [0,0,100,100]);
                 putvalue(port, 0);
                 send_trigger = 0;              
        end    

        % Update display:
        Screen('Flip', win);  
        if send_trigger
            putvalue(port, 1); 
        end
        % Release texture:
        Screen('Close', tex(frame_counter));
    end 
    

    % Stop playback:
    Screen('PlayMovie', movie, 0);

    % Close movie:
    Screen('CloseMovie', movie);
    putvalue(port, 0);
    
    KbWait;
catch
    
    psychrethrow(psychlasterror);
    sca;
end

return;