% function to reproduce a video (movie) from a file; to send a
% trigger corresponding to the first frame of the video 

% showMovieSendStartTrigger_cla_4(FILE_VIDEO, WIN, DIO, VIDEO_TRIGGER_VALUE, TEST,DURATION,AO) where 
%
% FILE_VIDEO is the full path of the file containing the video to be reproduced
%
% WIN is the window where the video is reproduced
% 
% DIO is an object mapping a parallel port. it has to be previously created by dio=dio=digitalio('parallel','PARALLEL_NAME') and initialized by line=addline(dio,0:m,'out'); where m is the number of trigger types - 1
%  
% VIDEO_TRIGGER_VALUE is the trigger code corresponding to the video: it should be 2^(n-1) where n is the number of type of the trigger 
%
%
% TEST, if =1 it enables the test mode (without sending triggers) in case the parallel port is not connected
%
% DURATION is the required duration of the trigger (to avoid trigger overlapping AND trigger detection even subsampling)
%



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