AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 0);
PsychGPUControl('FullScreenWindowDisablesCompositor', 1);


%input_folder='/data/projects/cp_action_observation/video';
input_folder='C:\Documents and Settings\martina\My Documents\MATLAB\cpchildren\video';

dio = digitalio('parallel','LPT1');
% aggiunge una linea dati in output di 8 bit
line=addline(dio,0:7,'out'); 

% Gestione scheda audio
fc = 10000;
ft = 440;
Tmax = 2;
t = linspace(0,4,Tmax*fc);
s = sin(2*pi*ft.*t);
ao = analogoutput('winsound')
set(ao,'SampleRate',fc)
set([ao],'TriggerType','Manual')

chans = addchannel(ao,1);
putdata(ao,s')

black = [0 0 0];
%rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
 W=800; H=750; rec = [0,0,W,H];

[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
monitor_freq = 1/monitorFlipInterval;

% showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio);
% showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio);
% showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio);
% showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio);
% showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio);
% showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio);
% 
% sca;
pause(.1);
 start(ao);
 showMovieSendMultipleTrigger(fullfile(input_folder,'aocs01.mp4'), window, dio,ao);
 putdata(ao,s');
 pause(.1);
 start(ao);
 showMovieSendMultipleTrigger(fullfile(input_folder,'aocs02.mp4'), window, dio,ao);
 putdata(ao,s');
 pause(.1);
 start(ao);
 showMovieSendMultipleTrigger(fullfile(input_folder,'aocs03.mp4'), window, dio,ao);
 putdata(ao,s');
 pause(.1);
 start(ao);
 showMovieSendMultipleTrigger(fullfile(input_folder,'aocs04.mp4'), window, dio,ao);
  putdata(ao,s');
 pause(.1);
 start(ao);
 showMovieSendMultipleTrigger(fullfile(input_folder,'aocs05.mp4'), window, dio,ao);
  putdata(ao,s');
 pause(.1);
 start(ao);
 showMovieSendMultipleTrigger(fullfile(input_folder,'aocs06.mp4'), window, dio,ao);
sca
break
showMovieSendMultipleTrigger(fullfile(input_folder,'aois01.mp4'), window, dio);
showMovieSendMultipleTrigger(fullfile(input_folder,'aois02.mp4'), window, dio);
showMovieSendMultipleTrigger(fullfile(input_folder,'aois03.mp4'), window, dio);
showMovieSendMultipleTrigger(fullfile(input_folder,'aois04.mp4'), window, dio);
showMovieSendMultipleTrigger(fullfile(input_folder,'aois05.mp4'), window, dio);
showMovieSendMultipleTrigger(fullfile(input_folder,'aois06.mp4'), window, dio);

sca;    