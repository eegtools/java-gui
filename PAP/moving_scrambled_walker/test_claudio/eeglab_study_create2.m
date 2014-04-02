function [STUDY, EEG] = eeglab_study_create2(settings_path, project_name, factor1_list, factor1_levels, factor2_list, factor2_levels ,pre_epoching_suffix,  epochs_path)

% function [STUDY, EEG] = eeglab_study_create(project_name, subjects_list, epoch_path, settings_path)
% creates a study using the datasets in a folder.
% project_name is the name of the project,
% subjects_list is the list of the subjects considered in the study, 
% conditions_list is the list of the conditions considered in the study, 
% analysis_name is the name of the analysis within the project
% pre_epoching_suffix is the suffix appent for the operations before the
% epoching
% epoch_path is the path where are datasets of EEGLab files,
% settings_path is the complete path were the settings file of the project (typically named project_settings) is placed.



    % load configuration file
    [path,name_noext,ext] = fileparts(settings_path);
    addpath(path);    eval(name_noext);
    
    nset=1;
    commands={};
    
    % start EEGLab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

    % create the study with the epoched data of all subjects
    % load each epochs set file (subject and condition) into the study structure
    % of EEGLab
    for nf1=1:length(factor1_levels)
        for subj=1:length(factor1_list{nf1})
            for nf2=1:length(factor2_levels)
                setname=[group_list{nf1}{subj} pre_epoching_suffix '_'  condition_names{nf2} '.set'];
                fullsetname=fullfile(epochs_path,setname,'');
                cmd={'index' nset 'load' fullsetname 'subject' group_list{nf1}{subj} 'session' 1 'condition' condition_names{nf2} 'group' group_names{nf1}};
                commands=[commands, cmd];    
                nset=nset+1;    
            end
        end
    end
    [STUDY, ALLEEG] = std_editset( STUDY, ALLEEG, 'name' ,project_name, 'commands',commands,'updatedat','on','savedat','on' );
    CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
    
    % save study on file
    [STUDY, ALLEEG] = std_checkset(STUDY, ALLEEG);
    [STUDY, EEG] = pop_savestudy( STUDY, EEG, 'filename',[project_name '.study'],'filepath',epochs_path);
end