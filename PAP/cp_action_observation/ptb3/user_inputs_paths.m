% used keys
s_key = KbName('s');    ... s: to start experiment after training
r_key = KbName('r');    ... r: to resume after a manual pause
p_key = KbName('p');    ... p: to manually pause the experiment
y_key = KbName('y');    ... y: correct answer
n_key = KbName('n');    ... n: wrong answer

% 6.1) subject name =====================================================
subject_label = input('please insert subject label (do not fill in any space char) :','s');
output_log_file = fullfile(root_dir, 'logs', ['log_' subject_label '_' date '.txt']);

while exist(output_log_file, 'file')
    subject_label=input('the entered subject already exist....do you want to overwrite the current log file (Y) or insert a new subject label (N) ?','s');
    if (subject_label == 'Y')
        break;
    else
        subject_label=input('please insert subject label (do not fill in any space char)','s');
        output_log_file=fullfile(root_dir, 'logs', ['log_' subject_label '_' date '.txt']);
    end
end
 fp=fopen(output_log_file,'w+');
if ~fp 
    disp('error opening file descriptor');
end

% 6.2) experiment mode ================================================
% 0:    full children   do training, wait for key press during questions, do 2 pauses
% 1:    full adults     do training, 4 secs pause during questions, do 4 pauses
% 2:    fast mode       no training, 4 secs pause during questions, do 4 pauses
while 1
    modestr = input('please insert experiment mode (accepted values are: 0,1,2) [0] :','s');
    if isempty(modestr)
        mode = 0;
    else
        switch modestr
            case {'0','1','2'}
                mode = str2num(modestr);
                break;
            otherwise
                disp('accepted mode are: 0,1,2');
        end
    end
end

switch mode
    case 0
        do_training = 1;
        do_question_pause = 1;
    case 1
        do_training = 1;
        do_question_pause = 0;
    case 2
        do_training = 0;
        do_question_pause = 0;
end

% 6.3) video side =====================================================
while 1
    video_side = input('please specify the hand side to be displayed (press : r or l): ', 's');
    switch video_side
        case {'r','l'}
            break;
        otherwise
            disp('accepted sides are: l & r');
    end
end

input_video_folder = fullfile(root_dir, 'video', ['video_' video_side], '');
input_audio_folder = fullfile(root_dir, 'video', 'audio', '');
games_folder = fullfile(root_dir, 'video', 'games', '');

start_video = fullfile(games_folder, 'start_video.avi');
instruction_image = fullfile(games_folder, 'descrizione_compito.jpg');
question_image = fullfile(games_folder, 'question.jpg');

fb_roots = {fullfile(games_folder, 'feedback_1', ''), fullfile(games_folder, 'feedback_2', ''), fullfile(games_folder, 'feedback_3', '')};
feedback_files = {'fb1_1.jpg','fb1_2.jpg','fb1_3.jpg','fb1_4.jpg','fb1_5.jpg','fb1_6.jpg','fb1_7.jpg','fb1_8.jpg'; ...
                  'fb2_1.png','fb2_2.png','fb2_3.png','fb2_4.png','fb2_5.png','fb2_6.png','fb2_7.png','fb2_8.png'; ...
                  'fb3_1.jpg','fb3_2.jpg','fb3_3.jpg','fb3_4.jpg','fb3_5.jpg','fb3_6.jpg','fb3_7.jpg','fb3_8.jpg'; ...
                  'fb3_1.mp4','fb3_2.mp4','fb3_3.mp4','fb3_4.mp4','fb3_5.mp4','fb3_6.mp4','fb3_7.mp4','fb3_8.mp4'};
              
pause_videos = {fullfile(games_folder, 'pause_1.avi'), fullfile(games_folder, 'pause_2.mp4')};
prepause_photos = {fullfile(games_folder, 'prePause1.jpg'), fullfile(games_folder, 'prePause2.png')};
end_video = fullfile(games_folder, 'end_video.mp4');


success_audio = fullfile(games_folder, 'sound_success.wav');
video_file_extension='.mp4';
audio_file_extension='.wav';
