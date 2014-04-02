% accepted values are when : N_stimuli_x_cond * N_effectors / N_block / N_available_video ..... is an integer
N_SUBJ                  = 2;
N_COND                  = 3;
N_TRIALS_X_COND         = 60;
N_STIM_TYPE             = 6;

N_TRIALS                = N_TRIALS_X_COND * N_COND * N_SUBJ;    ... 60 * 3 * 2 = 360
MIN_TRIAL_X_BLOCK       = N_STIM_TYPE * N_COND * N_SUBJ;        ... 6 * 3 * 2 = 36;
MIN_TRIAL_X_BLOCK_X_COND= MIN_TRIAL_X_BLOCK / N_COND;           ... 36 / 3 = 12;
NREP_STIM_TYPE_X_COND   = N_TRIALS_X_COND / N_STIM_TYPE;        ... 60 / 6 = 10
%---------------------------------------------------------------------------------------------
MAX_BLOCK               = N_TRIALS / MIN_TRIAL_X_BLOCK;         ... 360 / 36 = 10
N_BLOCK                 = 10;

N_TRIALS_X_BLOCK        = N_TRIALS / N_BLOCK;                   ... 360 / 10 = 36
N_TRIAL_X_BLOCK_X_COND  = MIN_TRIAL_X_BLOCK_X_COND * MAX_BLOCK / N_BLOCK;   ... 12 * 10 / 10 = 12
... MIN_TRIAL_X_BLOCK * MAX_BLOCK/ N_COND * N_BLOCK = N_STIM_TYPE * N_SUBJ * MAX_BLOCK/ * N_BLOCK
%---------------------------------------------------------------------------------------------

load(input_stimuli_file, 'written_video', 'written_trigger'); ... 2 x 3 x 60



% permute conditions order (permutated serie of 1,2,3)
A=[1,2,3];

concat_trials_list1=[];
concat_trials_list2=[];

for ol=1:N_BLOCK
    ordered_list        = repmat(A, 1, N_TRIAL_X_BLOCK_X_COND/2);
    permutation         = randperm(N_TRIALS_X_BLOCK/2);
    concat_trials_list1 = [concat_trials_list1 ordered_list(permutation)];
end

for ol=1:N_BLOCK
    ordered_list        = repmat(A,1,N_TRIAL_X_BLOCK_X_COND/2);
    permutation         = randperm(N_TRIALS_X_BLOCK/2);
    concat_trials_list2 = [concat_trials_list2 ordered_list(permutation)];
end


% permute the agent of the video
agents=[1,2];
displayed_agents=[];
block_dim=4;
for ag_bl=1:N_TRIALS/block_dim
    ordered_list        = repmat(agents,1,block_dim/2);
    permutation         = randperm(block_dim);
    displayed_agents    = [displayed_agents ordered_list(permutation)];
end


% apply AGENTS perm TO CONDITION perm
concat_trials_list=zeros(1, N_TRIALS);
curr_agents=[0 0];
for st=1:N_TRIALS
    if displayed_agents(st)==1
        curr_agents(1)=curr_agents(1)+1;
        concat_trials_list(st)=concat_trials_list1(curr_agents(1));    
    else
        curr_agents(2)=curr_agents(2)+1;
        concat_trials_list(st)=concat_trials_list2(curr_agents(2));    
    end
end



% permute within-condition stimuli type.... 

video_name_list=cell(2, N_COND, N_TRIALS_X_COND); 
trigger_value_list=cell(2, N_COND, N_TRIALS_X_COND); 

for subj=1:2
    for row=1:N_COND
        permutation=randperm(N_TRIALS_X_COND);

        input_row=written_video(subj, row, :);
        video_name_list(subj,row,:)=input_row(permutation);   

        input_row=written_trigger(subj, row,:);
        trigger_value_list(subj, row,:)=input_row(permutation);   
    end
end


% define question trials onset
question_appearance = zeros(1,N_TRIALS*2);

% onset of questions
qapp=[3 10 21 30 41 50 61 70 81 90 101 110 121 130 141 150 161 170 181 190 201 210 221 230 241 250 261 270 281 290 301 310 321 330 341 350];

for i=1:length(qapp)
    question_appearance(qapp(i))=1;
end

% define when to rest : 3 pauses 
rest_appearence=zeros(1,N_TRIALS*2);
...rest_appearence(1,180)=1;

tr=0;
mc=zeros(2,3);
for effector = concat_trials_list
    tr=tr+1;
    disp_subj               = displayed_agents(tr);
    mc(disp_subj, effector) = mc(disp_subj, effector) + 1;
end