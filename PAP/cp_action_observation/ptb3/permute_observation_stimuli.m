% accepted values are when : N_stimuli_x_cond * N_effectors / N_block / N_available_video ..... is an integer
N_COND                  = 4;
N_TRIALS_X_COND         = 60;
N_STIM_TYPE             = 6;
N_GAMES_BLOCK           = 3;

N_TRIALS                = N_TRIALS_X_COND * N_COND;    ... 60 * 4 = 240
MIN_TRIAL_X_BLOCK       = N_STIM_TYPE * N_COND;        ... 6 * 4 = 24;
MIN_TRIAL_X_BLOCK_X_COND= MIN_TRIAL_X_BLOCK / N_COND;           ... 24 / 4 = 6;
NREP_STIM_TYPE_X_COND   = N_TRIALS_X_COND / N_STIM_TYPE;        ... 60 / 6 = 10
%---------------------------------------------------------------------------------------------
MAX_BLOCK               = N_TRIALS / MIN_TRIAL_X_BLOCK;         ... 240 / 24 = 10
N_BLOCK                 = 5;

N_TRIALS_X_BLOCK        = N_TRIALS / N_BLOCK;                   ... 240 / 5 = 48
N_TRIALS_X_BLOCK_X_COND = MIN_TRIAL_X_BLOCK_X_COND * MAX_BLOCK / N_BLOCK;   ... 6 * 10 / 5 = 12
%---------------------------------------------------------------------------------------------

conditions_triggers_values={11,12,13,14,15,16; ...
            21,22,23,24,25,26; ...
            31,32,33,34,35,36; ...
            41,42,43,44,45,46};

video_file={'ctrl01','ctrl02','ctrl03','ctrl04','ctrl05','ctrl06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'; ...
            'ao01','ao02','ao03','ao04','ao05','ao06'};
        
audio_file={'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'none'      ,'none'      ,'none'      ,'none'      ,'none'      ,'none'       ;...
            'cs01','cs02','cs03','cs04','cs05','cs06'; ...
            'is01','is02','is03','is04','is05','is06'};         

% permute conditions order (permutated serie of 1,2,3)
A=[1,2,3,4];

trials_list=[];
for ol=1:N_BLOCK
    ordered_list = repmat(A, 1, N_TRIALS_X_BLOCK_X_COND);
    permutation  = randperm(N_TRIALS_X_BLOCK);
    trials_list  = [trials_list ordered_list(permutation)];
end

% permute within-condition stimuli type.... 
ordered_video_files=repmat(video_file, 1, NREP_STIM_TYPE_X_COND); ... create a matrix of 4x60 cells, replicating the base one (video_file)   
video_files_list=cell(N_COND, N_TRIALS_X_COND); 

ordered_audio_files=repmat(audio_file, 1, NREP_STIM_TYPE_X_COND); ... create a matrix of 4x60 cells, replicating the base one (video_file)   
audio_files_list=cell(N_COND, N_TRIALS_X_COND); 

ordered_triggers_values=repmat(conditions_triggers_values, 1, NREP_STIM_TYPE_X_COND); ... create a matrix of 4x60 cells, replicating the base one (video_file)   
conditions_triggers_values=cell(N_COND, N_TRIALS_X_COND); 


for row=1:N_COND
    permutation=randperm(N_TRIALS_X_COND);

    input_row=ordered_video_files(row,:);
    video_files_list(row,:)=input_row(permutation);   

    input_row=ordered_audio_files(row,:);
    audio_files_list(row,:)=input_row(permutation);   
    
    input_row=ordered_triggers_values(row,:);
    conditions_triggers_values(row,:)=input_row(permutation);   
   
end

% define question trials onset
question_appearance = zeros(1,N_TRIALS);

% onset of questions
qapp=[8 17 27 36 45 54 63 72 88 97 106 115 124 137 145 153 169 178 187 196 205 214 223 232];

for i=1:length(qapp)
    question_appearance(qapp(i))=1;
end

% define when to rest : 3 pauses 
rest_appearence=zeros(1,N_TRIALS);
...rest_appearence(1,180)=1;
    
if do_question_pause == 0
    % adults mode = 4 big pauses
    rest_appearence(1,48)=1;
    rest_appearence(1,96)=1;
    rest_appearence(1,144)=1;
    rest_appearence(1,192)=1;
else
    % children mode = only 2 big pauses
    rest_appearence(1,round(N_TRIALS/N_GAMES_BLOCK))=1;
    rest_appearence(1,round((N_TRIALS/N_GAMES_BLOCK)*2))=1;
end
