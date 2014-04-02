



%==========================================================================
%==========================================================================
% PROJECT DATA
project_name='moving_scrambled_walker_sall';
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
analysis_name='OCICA_250';
%==========================================================================
%==========================================================================

%names of conditions
name_cond={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};

% path where eeglab epochs files are exported
epochs_path=fullfile('/media/ADATA NH03/OCICA_250_concat_all');
% path where eeglab epochs files are exported
exp2r_path=fullfile('/media/ADATA NH03/OCICA_250_concat_all_exp2r');


% start EEGLab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];


for nsubj=1:length(subjects_list) %9:10%
    for cond=1:length(name_cond)
        setname=[subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.set'];
        expname=[exp2r_path, '/',subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.txt'];
        EEG = pop_loadset('filename',setname,'filepath',epochs_path);
        pop_export(EEG,expname,'erp','on','transpose','on');
    end
end




