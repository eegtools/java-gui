% to be edited according to calling PC local file system
os = system_dependent('getos');
if  strncmp(os,'Linux',2)
    local_projects_data_path='/media/Data/behaviour_platform@local';
    eegtools_svn_local_path='/media/Data/behaviour_platform@SVN/EEG_Tools';
    plugins_path='/media/Data/matlab_toolbox';
else
    
    local_projects_data_path='C:\Users\pippo\Documents\BEHAVIOUR_PLATFORM\behaviourPlatform@local';
    eegtools_svn_local_path='C:\Users\pippo\Documents\BEHAVIOUR_PLATFORM\behaviourPlatform@svn\EEG_Tools';
    plugins_path='C:\Users\Pippo\Documents\matlab_toolbox';
end

%==================================================================================
%==================================================================================
% DESIGN SPECIFICATION
...
...
...
...
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================= PROJECT DATA start here ==================================
project_folder='cp_action_observation';                 ... must correspond to 'local_projects_data_path' subfolder name
conf_file_name='project_structure';
%=====================================================================================================================================================================
%=====================================================================================================================================================================
global_scripts_path=fullfile(eegtools_svn_local_path, 'global_scripts');            addpath(global_scripts_path);
project.paths.scripts=fullfile(eegtools_svn_local_path, project_folder);            addpath(project.paths.scripts);
%=====================================================================================================================================================================
%=====================================================================================================================================================================
% PROJECT AND GLOBAL CONFIG FILE
eval(conf_file_name);       ... project
define_paths_structure      ... global

addpath(fullfile(eegtools_svn_local_path, 'global_scripts','eeglab_new',''));... TEMPORARY...overwrite standard eeglab functions
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%  OVERRIDE
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
project.subjects.list={'CP_08_mattia'}; project.subjects.numsubj=length(project.subjects.list); ... for debugging
%=====================================================================================================================================================================
stat_threshold = 0.05;
electrode2inspect='C4';
save_figure=0;

pre_epoching_input_file_name = '_raw_er1';                              
%=====================================================================================================================================================================
% OPERATIONS LIST 
%=====================================================================================================================================================================
do_import=0;
do_preproc=0;
do_patch_triggers=0;
do_auto_pauses_removal=0;
do_ica=1; 
do_epochs=0;
do_factors=0;
do_singlesubjects_betaband_comparison=0;

%=====================================================================================================================================================================
% S T A R T    P R O C E S S I N G  
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end

if do_import
    for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj}; ... inputfile=fullfile(project.paths.original_data, [project.subjects.list{subj} project.import.original_data_suffix '.' project.import.original_data_extension]);
        proj_eeglab_subject_import_data(project, subj_name);
    end
end
        
if do_preproc        
    for subj=1:project.subjects.numsubj 
        subj_name=project.subjects.list{subj};
        
        proj_eeglab_subject_preprocessing(project, subj_name);
        if project.do_emg_analysis
            proj_eeglab_subject_emgextraction_epoching(project, subj_name);
        end
    end
end

if do_patch_triggers
    for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj}; 
        file_name=fullfile(project.paths.epochs, [project.import.original_data_prefix subj_name pre_epoching_input_file_name '.set']);
        
        %   1) if not present, add start trigger 1 sec before the first trigger
        
        %   2) add: - a pause trigger value at the same latency of a question_trigger_value 
        %           - a resume trigger 1sec before the event following the question trigger
        ...eeglab_subject_events_add_event_at_code_and_before_next(file_name, 'S201', project.task.events.start_pause_trigger, project.task.events.end_pause_trigger, abs(project.epoching.epo_st.s));
        eeglab_subject_events_add_event_around_other_events(file_name, project.epoching.valid_marker, project.task.events.baseline_start_trigger_value, -1);

        %   3) add a pause trigger value at the same latency of a question_trigger_value
        %eeglab_subject_events_add_eve1_pre_eve2(file_name, {project.task.events.question_trigger_value},{project.task.events.resume_trigger_value},10000000000,project.task.events.pause_trigger_value)
    end
end

if do_auto_pauses_removal
    for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj};        
        file_name=fullfile(project.paths.epochs, [project.import.original_data_prefix subj_name pre_epoching_input_file_name '.set']);
        
        eeglab_subject_events_remove_upto_triggercode(file_name, project.task.events.start_experiment_trigger_value); ... return if find a boundary as first event
        eeglab_subject_events_remove_after_triggercode(file_name, project.task.events.end_experiment_trigger_value); ... return if find a boundary as first event
        
        pause_resume_errors=eeglab_subject_events_check_2triggers_orders(file_name, project.task.events.pause_trigger_value, project.task.events.resume_trigger_value);
        if isempty(pause_resume_errors)
            disp('====>> pause/remove triggers sequence ok....move to pause removal');
            eeglab_subject_remove_pauses(file_name, project.task.events.pause_trigger_value, project.task.events.resume_trigger_value);
        else
            disp('====>> errors in pause/resume trigger sequence');
            pause_resume_errors
        end
        
        ...pause_resume_errors=eeglab_subject_events_check_2triggers_orders(file_name, project.task.events.videoend_trigger_value, project.task.events.baseline_start_trigger_value);
        pause_resume_errors=[];
        if isempty(pause_resume_errors)
            disp('====>> pause/remove triggers sequence ok....move to pause removal');
            eeglab_subject_remove_pauses(file_name, project.task.events.videoend_trigger_value, project.task.events.baseline_start_trigger_value);
        else
            disp('====>> errors in pause/resume trigger sequence');
            pause_resume_errors
        end

        
    end
end

%==================================================================================
if do_ica
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj}; 
        inputfile=fullfile(project.paths.epochs, [project.import.original_data_prefix subj_name pre_epoching_input_file_name '.set']);
        eeglab_subject_ica(inputfile, project.paths.epochs, project.eegdata.eeg_channels_list, 'cudaica');
    end
end
%==================================================================================
if do_epochs
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
     for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj}; ...inputfile=fullfile(project.paths.epochs, [project.subjects.list{subj} project.epoching.input_suffix '.set']);
        proj_eeglab_subject_epoching(project, subj_name);
     end
end
%==================================================================================
if do_factors
    for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj};        
        proj_eeglab_subject_add_factor(project, subj_name);
    end
end
%==================================================================================
if do_singlesubjects_betaband_comparison
    for subj=1:project.subjects.numsubj
        subj_name=project.subjects.list{subj};        
        cond_files=cell(project.epoching.numcond);
        for nc=1:project.epoching.numcond
            cond_files{nc}=fullfile(project.paths.epochs, [subj_name project.epoching.input_suffix '_' project.epoching.condition_names{nc} '.set']);
        end
        eeglab_subject_tf_plot_onecondition_vs_baseline(cond_files{2}, electrode2inspect, 'pvalue', stat_threshold, 'correct', 'none', 'baseline', [project.epoching.bc_st.ms project.epoching.bc_end.ms], 'save_fig', save_figure, 'fig_output_path', project.paths.results);
        eeglab_subject_tf_plot_onecondition_vs_baseline(cond_files{3}, electrode2inspect, 'pvalue', stat_threshold, 'correct', 'none', 'baseline', [project.epoching.bc_st.ms project.epoching.bc_end.ms], 'save_fig', save_figure, 'fig_output_path', project.paths.results);

        ...eeglab_subject_tf_plot_2conditions(project, cond_files{2}, cond_files{1}, electrode2inspect, stat_threshold, save_figure, project.paths.results);
%          eeglab_subject_tf_plot_2conditions(project, cond3, cond2, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project, cond3, cond1, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project, cond3, cond4, electrode2inspect, stat_threshold, save_figure, results_path);
    end
end
%==================================================================================
%==================================================================================