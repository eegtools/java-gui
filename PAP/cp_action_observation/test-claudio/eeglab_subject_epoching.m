function EEG = eeglab_subject_epoching(input_file_name, output_path, settings_path, acquisition_system, valid_marker,nch_eeg)    

    [path,name_noext,ext] = fileparts(input_file_name);
    EEG=pop_loadset(input_file_name);

    % load configuration file
    addpath(settings_path);
    project_config;
    
    
    EEG = pop_rmbase( EEG, [bc_st  bc_end]);
    
%     % perform processing and then save condition datasets
    for cond=1:length(mrkcode_cond)
        EEG2 = pop_epoch( EEG,  mrkcode_cond{cond}  , [epo_st         epo_end], 'newname', name_cond{cond}, 'epochinfo', 'yes');
        
        EEG2 = eeg_checkset( EEG2 );
        EEG2 = pop_saveset( EEG2, 'filename',[name_noext '_' name_cond{cond}],'filepath',output_path);
    end

end