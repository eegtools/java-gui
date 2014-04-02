function my_VideoRecordingDemo(screen_num, moviename, codec, rec_flag, windowed)

    AssertOpenGL;

    waitforimage = 1;
    fprintf('Recording to movie file %s ...\n', moviename);

    if Screen('Preference', 'DefaultVideocaptureEngine') > 0
        if isempty(codec)
            % These do not work yet:
            %codec = ':CodecType=huffyuv'  % Huffmann encoded YUV + MPEG-4 audio: FAIL!
            %codec = ':CodecType=ffenc_h263p'  % H263 video + MPEG-4 audio: FAIL!
            %codec = ':CodecType=yuvraw' % Raw YUV + MPEG-4 audio: FAIL!

            % These are so slow, they are basically useless for live recording:
            %codec = ':CodecType=theoraenc'% Theoravideo + Ogg vorbis audio: Gut @ 320 x 240
            %codec = ':CodecType=vp8enc_webm'   % VP-8/WebM  + Ogg vorbis audio: Ok @ 320 x 240, miserabel higher.
            %codec = ':CodecType=vp8enc_matroska'   % VP-8/Matroska  + Ogg vorbis audio: Gut @ 320 x 240

            % The good ones...
            %codec = ':CodecType=ffenc_mpeg4' % % MPEG-4 video + audio: Tut ok @ 640 x 480.
            %codec = ':CodecType=xvidenc'  % MPEG-4 video + audio: Tut sehr gut @ 640 x 480 Very good a-v sync! Works well in all conditions. -> Champion.
            %codec = ':CodecType=x264enc Keyframe=1 Videobitrate=8192 AudioCodec=alawenc ::: AudioSource=pulsesrc ::: Muxer=qtmux'  % H264 video + MPEG-4 audio: Tut seshr gut @ 640 x 480
            %codec = ':CodecType=VideoCodec=x264enc speed-preset=1 noise-reduction=100000 ::: AudioCodec=faac ::: Muxer=avimux'
            %codec = ':CodecSettings=Keyframe=60 Videobitrate=8192 '
            %codec = ':CodecType=xvidenc Keyframe=60 Videobitrate=8192 '

            % Assign default auto-selected codec:
            codec = ':CodecType=DEFAULTencoder';
        else
            % Assign specific user-selected codec:
            codec = [':CodecType=' codec];
        end
    end

    fprintf('Using codec: %s\n', codec);
    oldtex = 0;
    try
        if windowed > 0
            oldsynclevel = Screen('Preference', 'SkipSyncTests', 1);
            win=Screen('OpenWindow', screen_num, 0, [0 0 800 600]);
        else
            oldsynclevel = Screen('Preference', 'SkipSyncTests');
            win=Screen('OpenWindow', screen_num, 0);
        end
        Screen('Flip',win);

        % Capture and record video + audio to disk:
        % Specify the special flags in 'withsound', the codec settings for
        % recording in 'codec'. Leave everything else at auto-detected defaults:
        if IsWin
    %wcs.grabbers{w}= Screen('OpenVideoCapture', wcs.wndptrs{w}, wcs.device_ids{w}, wcs.settings.cam_screen, wcs.settings.pixel_depth, wcs.settings.num_buff, wcs.settings.allow_fallback, filename, wcs.settings.rec_flags, wcs.settings.capt_engine);
            grabber = Screen('OpenVideoCapture', win,           [],                 [0 0 640 480],           [],                        [],                   [],                          codec,    rec_flag);
        else
            % Is this the legacy Quicktime videocapture engine?
            if Screen('Preference', 'DefaultVideocaptureEngine') == 0
                % Yes: Need to store the name of the moviefile in the codec
                % parameter:
                codec = [moviename '.mov' codec];
            end

            % No need for Windows-style workarounds:
            grabber = Screen('OpenVideoCapture', win, [0], [], [], [], [], codec, withsound);
        end

    for nreps = 1:1
        % Non-legacy engine? GStreamer allows more convenient spec of moviename:
        if Screen('Preference', 'DefaultVideocaptureEngine') > 0
            % Select a moviename for the recorded movie file:
            mname = sprintf('SetNewMoviename=%s_%i.mov', moviename, nreps);
            Screen('SetVideoCaptureParameter', grabber, mname);
        end

        Screen('StartVideoCapture', grabber, 30, 1)

        % Run until keypress:
        while ~KbCheck 
            % Live preview: Wait blocking for new frame, return texture
            % handle and capture timestamp:
            [tex pts nrdropped]=Screen('GetCapturedImage', win, grabber, waitforimage, oldtex);

            % Some output to the console:
            % fprintf('tex = %i  pts = %f nrdropped = %i\n', tex, pts, nrdropped);

            % If a texture is available, draw and show it.
            if (tex>0)
                % Draw new texture from framegrabber.
                Screen('DrawTexture', win, tex);
                
                oldtex = tex;
                % Show it:
                Screen('Flip', win);
            else
                WaitSecs('YieldSecs', 0.005);
            end
        end
        % Stop capture engine and recording:
        Screen('StopVideoCapture', grabber);
    end

    % Close engine and recorded movie file:
    Screen('CloseVideoCapture', grabber);

    % Close display, release all remaining ressources:
    Screen('CloseAll');


    catch error
        % display error
        error.identifier
        error.message
        error.stack
        % In case of error, the 'CloseAll' call will perform proper shutdown
        % and cleanup:
        RestrictKeysForKbCheck([]);
        Screen('CloseAll');
    end;

end