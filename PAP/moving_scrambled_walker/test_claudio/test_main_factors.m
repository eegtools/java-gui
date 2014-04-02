 for subj=1:length(subjects_list)
    for cond=1:length(conditions_list)
        setname=[subjects_list{subj} '_',analysis_name '_'  conditions_list{cond} '.set'];
        fullsetname=fullfile(epochs_path,setname,'');
        switch conditions_list{cond}
            case'twalker'
                eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'translating');
                eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'walker');                    

            case'cwalker'
                eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'centered');
                eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'walker');                    

            case'tscrambled'
                eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'translating');
                eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'scrambled');                    

            case'cscrambled'
                eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'centered');
                eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'scrambled');                            
        end
    end
 end