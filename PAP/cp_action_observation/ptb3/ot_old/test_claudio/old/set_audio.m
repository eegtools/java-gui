
function set_audio(audio_file)

% reads data from the file named audio_file, and returns sampled data,s, and a sample rate for that data, fc.
[s,fc] = audioread(audio_file)
% load audio in the sound card ao
ao = analogoutput('winsound')
set(ao,'SampleRate',fc)
set([ao],'TriggerType','Manual')

chans = addchannel(ao,1);
putdata(ao,s')
end