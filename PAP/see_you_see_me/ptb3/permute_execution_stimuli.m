% accepted values are when : N_stimuli_x_cond * N_effectors / N_block / N_available_video ..... is an integer

N_COND                  = 3;
N_TRIALS_X_COND         = 60;
N_STIM_TYPE             = 6;

N_TRIALS                = N_TRIALS_X_COND * N_COND;             ... 60 * 3 = 180
MIN_TRIAL_X_BLOCK       = N_COND * N_STIM_TYPE;                 ... 3 * 6 = 18;
    
MAX_BLOCK               = N_TRIALS / MIN_TRIAL_X_BLOCK;         ... 180 / 18 = 10      N_TRIALS_X_COND * N_COND /  N_COND * N_STIM_TYPE = N_TRIALS_X_COND / N_STIM_TYPE
NREP_STIM_TYPE_X_COND   = N_TRIALS_X_COND / N_STIM_TYPE;        ... 60 / 6 = 10

% DEFINE N_BLOCK in ORDER TO:
N_BLOCK                 = 5;                                    
N_TRIALS_X_COND_BLOCK   = N_TRIALS_X_COND / N_BLOCK;            ... 60 / 5 = 12
N_TRIALS_X_BLOCK        = N_TRIALS_X_COND * N_COND / N_BLOCK;   ... 60 * 3 / 5 = 36




trigger_value={ ...
                16,17,19,19,20,21; ... hand
                48,49,50,51,52,53; ... leg
                80,81,82,83,84,85  ... mouth 
              };

movement_type={...
                'h1','h2','h3','h4','h5','h6'; ...
                'l1','l2','l3','l4','l5','l6'; ...
                'm1','m2','m3','m4','m5','m6' ...
              };
        
A=[1 2 3];        % --- conditions : hand, feet, mouth



concat_trials_list1=[];
concat_trials_list2=[];

for ol=1:N_BLOCK
    ordered_list        = repmat(A,1,N_TRIALS_X_COND_BLOCK);
    permutation         = randperm(N_TRIALS_X_BLOCK);
    concat_trials_list1 = [concat_trials_list1 ordered_list(permutation)];
end

for ol=1:N_BLOCK
    ordered_list        = repmat(A,1,N_TRIALS_X_COND_BLOCK);
    permutation         = randperm(N_TRIALS_X_BLOCK);
    concat_trials_list2 = [concat_trials_list2 ordered_list(permutation)];
end

concat_trials_list=zeros(1,N_TRIALS*2);
for st=1:N_TRIALS
    concat_trials_list(2*st-1)=concat_trials_list1(st);    
    concat_trials_list(2*st)=concat_trials_list2(st);    
end

% permute stimuli....

movement_type_list=cell(2, N_COND, N_TRIALS_X_COND); 
trigger_value_list=cell(2, N_COND, N_TRIALS_X_COND); 

ordered_movement_type_list=repmat(movement_type, 1, NREP_STIM_TYPE_X_COND); ... create a matrix of 3x60 cells, replicating the base one (video_file)   
ordered_trigger_value_list=repmat(trigger_value, 1, NREP_STIM_TYPE_X_COND); ... create a matrix of 3x60 cells, replicating the base one (video_file)   

for row=1:N_COND
    permutation=randperm(N_TRIALS_X_COND);

    input_row=ordered_movement_type_list(row,:);
    movement_type_list(1,row,:)=input_row(permutation);   

    input_row=ordered_trigger_value_list(row,:);
    trigger_value_list(1, row,:)=input_row(permutation);   
end

for row=1:N_COND
    permutation=randperm(N_TRIALS_X_COND);

    input_row=ordered_movement_type_list(row,:);
    movement_type_list(2,row,:)=input_row(permutation);   

    input_row=ordered_trigger_value_list(row,:);
    trigger_value_list(2, row,:)=input_row(permutation);   
end


concat_trials_list=zeros(1,N_TRIALS*2);
for st=1:N_TRIALS
    concat_trials_list(2*st-1)=concat_trials_list1(st);    
    concat_trials_list(2*st)=concat_trials_list2(st);    
end


% define question trials onset
question_appearance = zeros(1,N_TRIALS*2);

% onset of questions
qapp=[1 10 21 30 41 50 61 70 81 90 101 110 121 130 141 150 161 170 181 190 201 210 221 230 241 250 261 270 281 290 301 310 321 330 341 350];

for i=1:length(qapp)
    question_appearance(qapp(i))=1;
end

% define when to rest : 3 pauses 
rest_appearence=zeros(1,N_TRIALS*2);
...rest_appearence(1,180)=1;
