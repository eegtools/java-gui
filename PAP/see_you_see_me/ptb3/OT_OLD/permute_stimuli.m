% accepted values are when : N_stimuli_x_cond * N_effectors / N_block / N_available_video ..... is an integer

N_block=4;                                              % number of blocks composing the experiment, a 3-4 minutes rest is done during the experiment.
N_effectors=3;                                          % number of different types of stimuli
N_stimuli_x_cond=24;                                    % number of stimuli for condition
N_movement_type=6;                                      % number of available video

N_stimuli_x_cond_x_block=N_stimuli_x_cond / N_block;    % 60/5=12   number of stimuli for condition for each block
N_tot_stimuli=N_stimuli_x_cond * N_effectors;           % 60*3=180  TOTAL number of stimuli 
N_tot_stimuli_x_block=N_tot_stimuli / N_block;          % 180/5=36  number of stimuli for block

N_movement_repetition=N_stimuli_x_cond / N_movement_type;  % 60/6=10

N_random_questions=20; 
N_stimuli_noquestions=N_tot_stimuli - N_random_questions;

% PERMUTATION (each of the 3 block is permuted separately, then stimuli are then concatenated)
% --- files

% hand:       11,12,13,14,15,16
% foot:       21,22,23,24,25,26
% mouth:      31,32,33,34,35,36

trigger_value={ ...
                            11,12,13,14,15,16; ...
                            21,22,23,24,25,26; ...
                            31,32,33,34,35,36 ...
                            };

movement_type={...
            'h1','h2','h3','h4','h5','h6'; ...
            'l1','l2','l3','l4','l5','l6'; ...
            'm1','m2','m3','m4','m5','m6' ...
            };
        
A=[1 2 3];        % --- conditions : hand, feet, mouth

ordered_list1=repmat(A,1,N_stimuli_x_cond_x_block);
permutation1=randperm(N_tot_stimuli_x_block);
trials_list1=ordered_list1(permutation1); 

ordered_list2=repmat(A,1,N_stimuli_x_cond_x_block);
permutation2=randperm(N_tot_stimuli_x_block);
trials_list2=ordered_list2(permutation2); 

ordered_list3=repmat(A,1,N_stimuli_x_cond_x_block);
permutation3=randperm(N_tot_stimuli_x_block);
trials_list3=ordered_list3(permutation3); 

ordered_list4=repmat(A,1,N_stimuli_x_cond_x_block);
permutation4=randperm(N_tot_stimuli_x_block);
trials_list4=ordered_list4(permutation4); 

ordered_list5=repmat(A,1,N_stimuli_x_cond_x_block);
permutation5=randperm(N_tot_stimuli_x_block);
trials_list5=ordered_list5(permutation5); 

% define the rows of the next structures
concat_trials_list1=cat(2,trials_list1, trials_list2, trials_list3, trials_list4, trials_list5);

ordered_list1=repmat(A,1,N_stimuli_x_cond_x_block);
permutation1=randperm(N_tot_stimuli_x_block);
trials_list1=ordered_list1(permutation1); 

ordered_list2=repmat(A,1,N_stimuli_x_cond_x_block);
permutation2=randperm(N_tot_stimuli_x_block);
trials_list2=ordered_list2(permutation2); 

ordered_list3=repmat(A,1,N_stimuli_x_cond_x_block);
permutation3=randperm(N_tot_stimuli_x_block);
trials_list3=ordered_list3(permutation3); 

ordered_list4=repmat(A,1,N_stimuli_x_cond_x_block);
permutation4=randperm(N_tot_stimuli_x_block);
trials_list4=ordered_list4(permutation4); 

ordered_list5=repmat(A,1,N_stimuli_x_cond_x_block);
permutation5=randperm(N_tot_stimuli_x_block);
trials_list5=ordered_list5(permutation5); 

% define the rows of the next structures
concat_trials_list2=cat(2,trials_list1, trials_list2, trials_list3, trials_list4, trials_list5);


concat_trials_list=zeros(1,N_tot_stimuli*2);
for st=1:N_tot_stimuli
    concat_trials_list(2*st-1)=concat_trials_list1(st);    
    concat_trials_list(2*st)=concat_trials_list2(st);    
end

% permute stimuli....

movement_type_list=cell(2, N_effectors, N_stimuli_x_cond); 
trigger_value_list=cell(2, N_effectors, N_stimuli_x_cond); 

ordered_movement_type_list=repmat(movement_type, 1, N_movement_repetition); ... create a matrix of 3x60 cells, replicating the base one (video_file)   
ordered_trigger_value_list=repmat(trigger_value, 1, N_movement_repetition); ... create a matrix of 3x60 cells, replicating the base one (video_file)   

for row=1:N_effectors
    permutation=randperm(N_stimuli_x_cond);

    input_row=ordered_movement_type_list(row,:);
    movement_type_list(1,row,:)=input_row(permutation);   

    input_row=ordered_trigger_value_list(row,:);
    trigger_value_list(1, row,:)=input_row(permutation);   
end

for row=1:N_effectors
    permutation=randperm(N_stimuli_x_cond);

    input_row=ordered_movement_type_list(row,:);
    movement_type_list(2,row,:)=input_row(permutation);   

    input_row=ordered_trigger_value_list(row,:);
    trigger_value_list(2, row,:)=input_row(permutation);   
end

% define question trials onset
question_appearance = zeros(1,N_tot_stimuli*2);

% onset of questions
qapp=[3 10 21 30 41 50 61 70 81 90 101 110 121 130 141 150 161 170 181 190 201 210 221 230 241 250 261 270 281 290 301 310 321 330 341 350];

...for i=1:length(qapp)
    ...question_appearance(qapp(i))=1;
...end

% define when to rest : 3 pauses 
rest_appearence=zeros(1,N_tot_stimuli*2);
...rest_appearence(1,180)=1;
