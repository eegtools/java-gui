% functions:
% play a movie
% send a first trigger just before the first frame displayed
% send a second trigger at the the frame specified [audio_frame]
% the duration of the trigger is to avoid trigger overlapping AND trigger detection even subsampling



%                                      
function showMovieSendDoubleTrigger_cla_4(file_video, file_audio, win, dio, video_trigger_value, audio_frame, audio_trigger_value,test,duration,ao)

 [s,fc] = wavread(file_audio);
 set(ao,'SampleRate',fc);

  putdata(ao,s(:,1));
  start(ao);



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
            put_trigger(video_trigger_value,dio,duration);
        else
            disp(['first frame, audio frame @ ' num2str(audio_frame)]);
        end

     elseif (frame_counter == audio_frame)   
        %reproduce audio pre-loaded in the sound card
        trigger(ao);
        if~test
            put_trigger(audio_trigger_value,dio,duration);             
            
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

% clear ao

catch
  psychrethrow(psychlasterror);
  sca;
end

return;