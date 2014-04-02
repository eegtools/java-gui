
GetSecs;
WaitSecs(0.1);

pahandle = PsychPortAudio('Open', [], [], 0, 44100, 2);
PsychPortAudio('Close');