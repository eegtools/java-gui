% function to reproduce a video (movie) from a file; to reproduce an audio
% (sound) from an independent file at a desired frame of the video; to send a
% trigger corresponding to the first frame of the video and another trigger
% corresponding to the start of the audio.

% showMovieSendDoubleTrigger_cla_4(FILE_VIDEO, FILE_AUDIO, WIN, DIO, VIDEO_TRIGGER_VALUE, AUDIO_FRAME, AUDIO_TRIGGER_VALUE,TEST,DURATION,AO) where 
%
% FILE_VIDEO and FILE_AUDIO are the respective full paths of the files containing the video and the audio (supposed to be in .wav format) to be reproduced
%
% WIN is the window where the video is reproduced
% 
% DIO is an object mapping a parallel port. it has to be previously created by dio=dio=digitalio('parallel','PARALLEL_NAME') and initialized by line=addline(dio,0:m,'out'); where m is the number of trigger types - 1
%  
% VIDEO_TRIGGER_VALUE and VIDEO_TRIGGER_VALUE are the trigger codes corresponding respectively to the video and to the audio: they should be 2^(n-1) where n is the number of type of the trigger 
%
% AUDIO_FRAME is the frame of the video when the audio should be reproduced
%
% TEST, if =1 it enables the test mode (without sending triggers) in case the parallel port is not connected
%
% DURATION is the required duration of the trigger (to avoid trigger overlapping AND trigger detection even subsampling)
%
% AO is an object mapping the device used to reproduce the audio. At the moment it is the soundcard but in feauture release a NI card could be used instead 

function showMovieSendDoubleTrigger_cla_4(file_video, file_audio, win, dio, video_trigger_value, audio_frame, audio_trigger_value,test,duration,ao)

 % read the audio file: collect the signal and the sampling frequency
 [s,fc] = wavread(file_audio);
 %set teh sound card to the right sampling frequency
 set(ao,'SampleRate',fc);
 %load the sound to the sound card
 putdata(ao,s(:,1));
 %initialize the soundcard
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



catch
  psychrethrow(psychlasterror);
  sca;
end

return;