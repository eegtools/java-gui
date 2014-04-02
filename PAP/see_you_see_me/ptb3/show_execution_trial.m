% each subject has a webcam and a monitor aside him, pointing to the other subject.
% when A is expected to move (A=moving_subject)
% => the webcam close to B (=observing_subject) start recording and the monitor shows the cues.
% => the microphone of the webcam of the executing subject record the sound
webcamscreens.wcs(observing_subject).other_snd_hndl = prepare_sound_recording(webcamscreens.wcs(observing_subject).other_audio_id, video_length, recording_freq);
webcamscreens.wcs(observing_subject).file_ptr = Screen('CreateMovie', webcamscreens.wcs(observing_subject).wndptr, output_video_file, [], [], [], webcamscreens.settings.codec);

showImageNseconds(file_cue, experimenter_cue_wnd, -1);                                      ... don't wait and keep image
if send_out_trigger
    put_trigger_linux(address, cue_cross_trigger_value, trigger_duration, portnum);
end      
showImageNseconds(file_cue, subjects_screens{observing_subject}, cue_time, 0, black);       ... wait 1 sec and then remove image

[tex, pt, df] = Screen('GetCapturedImage', webcamscreens.wcs(observing_subject).wndptr, webcamscreens.wcs(observing_subject).grabber, 1); 
start_sound_recording(webcamscreens.wcs(observing_subject).own_snd_hndl);

start_pt = pt;

if send_out_trigger
    put_trigger_linux(address, cue_trigger_value, trigger_duration, portnum);
end  

while 1 
    [pt, df] = update_recording_webcam_screen_addfrontframe(webcamscreens.wcs(observing_subject), 'rotation', 90);

    elapsed = pt - start_pt;
    if (elapsed >= video_length)
        break;
    end
end

if send_out_trigger
    put_trigger_linux(address, end_trial_trigger_value, trigger_duration, portnum);
end 

stop_sound_recording_save2file( webcamscreens.wcs(observing_subject).own_snd_hndl, output_audio_file, recording_freq ); 
Screen('FinalizeMovie', webcamscreens.wcs(observing_subject).fileptr);  

webcamscreens = switch_capturing_webcam_screens(executing_subject, webcamscreens);