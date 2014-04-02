function start_recording(wndptr, moviename, codec, rec_flag)

    waitforimage = 1;
    fprintf('Recording to movie file %s ...\n', moviename);
    oldtex = 0;

    try
    %wcs.grabbers{w}= Screen('OpenVideoCapture', wcs.wndptrs{w}, wcs.device_ids{w}, wcs.settings.cam_screen, wcs.settings.pixel_depth, wcs.settings.num_buff, wcs.settings.allow_fallback, filename, wcs.settings.rec_flags, wcs.settings.capt_engine);
        grabber = Screen('OpenVideoCapture', wndptr,           [],                 [0 0 640 480],           [],                        [],                   [],                          codec,    rec_flag);

        for nreps = 1:1
            % Non-legacy engine? GStreamer allows more convenient spec of moviename:
            if Screen('Preference', 'DefaultVideocaptureEngine') > 0
                % Select a moviename for the recorded movie file:
                mname = sprintf('SetNewMoviename=%s', moviename);
                Screen('SetVideoCaptureParameter', grabber, mname);
            end

            Screen('StartVideoCapture', grabber, 30, 1)

            % Run until keypress:
            while ~KbCheck 
                % Live preview: Wait blocking for new frame, return texture
                % handle and capture timestamp:
                [tex pts nrdropped]=Screen('GetCapturedImage', wndptr, grabber, waitforimage, oldtex);

                % If a texture is available, draw and show it.
                if (tex>0)
                    % Draw new texture from framegrabber.
                    Screen('DrawTexture', wndptr, tex);

                    oldtex = tex;
                    % Show it:
                    Screen('Flip', wndptr);
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