% to be edited according to calling PC local file system
os = system_dependent('getos');
if  strncmp(os,'Linux',2)
    local_projects_data_path='/data/projects';
    eegtools_svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
    plugins_path='/mnt/behaviour_lab/Projects/EEG_tools/matlab_toolbox';
else
    local_projects_data_path='C:\Users\Pippo\Documents\EEG_projects';
    eegtools_svn_local_path='C:\Users\Pippo\Documents\MATLAB\svn_beviour_lab\EEG_Tools';
    plugins_path='C:\Users\Pippo\Documents\MATLAB\toolboxes';
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
project_folder='miren_negation';                 ... must correspond to 'local_projects_data_path' subfolder name
conf_file_name='project_config.m';
analysis_name='raw';                             ... subfolder containing the current analysis type (refers to EEG device input data type)
db_folder_name='miren_negation';                  ... must correspond to brainstorm db name
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
global_scripts_path=fullfile(eegtools_svn_local_path, 'global_scripts');
addpath(global_scripts_path);
define_paths    

% load configuration file
[path,name_noext,ext] = fileparts(project_settings);
addpath(path);    eval(name_noext);
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%  OVERRIDE
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
stat_threshold = 0.05;
electrode2inspect='C4';
save_figure=0;
pre_epoching_input_file_name = '_raw_er';    ... dynamic way to refer to different steps of the preprocessing..usually is analysis_name, analysis_name"_er", analysis_name"_mc"
subjects_list={'MIREN_MU000015'};
%=====================================================================================================================================================================
% ======= OPERATIONS LIST ============================================================================================================================================
do_import=0;
do_patch_triggers=0;
do_auto_pauses_removal=0;
do_ica=1; 
do_ica_review=0;
do_epochs=0;
do_singlesubjects_betaband_comparison=0;
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T    P R O C E S S I N G  ==========================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end

if do_import
    for subj=1:length(subjects_list)
        
        if (strcmp(acquisition_system, 'BRAINAMP'))
            inputfile=fullfile(vhdr_path, [subjects_list{subj} '_' analysis_name '.vhdr']);
        else
            inputfile=fullfile(bdf_path, [subjects_list{subj} '_' analysis_name '.bdf']);
        end
        
        eeglab_subject_import_event(project_settings, inputfile, epochs_path, acquisition_system, nch_eeg, 'stimuli',[],[],polygraphic_channels);
        file_name=fullfile(epochs_path, [subjects_list{subj} '_' analysis_name '.set']);
        
        if ~isempty(polygraphic_channels)
            %eeglab_subject_transform_poly(project_settings, file_name, epochs_path, nch_eeg, polygraphic_channels)
            eeglab_subject_emgextraction_epoching(project_settings, file_name, emg_output_postfix_name, emg_epochs_path);
        end
    end
end

if do_patch_triggers
    % patch, add a pause trigger every question trigger
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        %   1) if not present, add start trigger 1 sec before the first trigger
        
        %   2) add: - a pause trigger value at the same latency of a question_trigger_value 
        %           - a resume trigger 1sec before the event following the question trigger
        eeglab_subject_events_add_event_at_code_and_before_next(project_settings, fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']), 'S201', start_pause_trigger, end_pause_trigger, abs(epo_st));
        
        %   3) add a pause trigger value at the same latency of a question_trigger_value
        %eeglab_subject_events_add_eve1_pre_eve2(project_settings, file_name,{question_trigger_value},{resume_trigger_value},10000000000,pause_trigger_value)
    end
end

if do_auto_pauses_removal
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_events_remove_upto_triggercode(project_settings, file_name, start_experiment_trigger_value); ... return if find a boundary as first event
        eeglab_subject_events_remove_after_triggercode(project_settings, file_name, end_experiment_trigger_value); ... return if find a boundary as first event
        pause_resume_errors=eeglab_subject_events_check_2triggers_orders(project_settings, file_name,start_pause_trigger, end_pause_trigger);
        if isempty(pause_resume_errors)
            disp('====>> pause/remove triggers sequence ok....move to pause removal');
            eeglab_subject_remove_pauses(project_settings, file_name, start_pause_trigger, end_pause_trigger);
        else
            disp('====>> errors in pause/resume trigger sequence');
            pause_resume_errors
        end
    end
end

if do_ica
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_ica(project_settings, file_name, epochs_path, nch_eeg, 'cudaica');
    end
end

if do_ica_review
    % calculate IC which show intervals outside Xtimes their standard deviations
    for subj=1:length(subjects_list)
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_remove_segments_ica(project_settings, file_name, 3, 5);
    end
end
%==================================================================================
if do_epochs
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
     for subj=1:length(subjects_list)
         file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
         eeglab_subject_epoching_baseline_remove(project_settings, file_name, epochs_path);
     end
    
    for subj=1:length(subjects_to_swap)
        input_file_name=fullfile(epochs_path, [subjects_to_swap{subj} pre_epoching_input_file_name '.set']);
        output_file_name=fullfile(epochs_path, [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '.set']);
        eeglab_subject_swap_electrodes(project_settings, input_file_name, output_file_name);
        eeglab_subject_epoching_baseline_remove(project_settings, output_file_name, epochs_path);
    end
end
%==================================================================================
if do_singlesubjects_betaband_comparison
    for subj=1:length(subjects_list)
        %electrode2inspect = electrode_of_interest{subj};
        
        cond1=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_control' '.set']);
        cond2=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_AO' '.set']);
        cond3=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_AOCS' '.set']);
        cond4=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '_AOIS' '.set']);
          eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond1, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
         eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond2, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
%         eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond3, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
%         eeglab_subject_tf_plot_onecondition_vs_baseline(project_settings, cond4, electrode2inspect, stat_threshold, baseline_analysis_interval_point, save_figure, results_path);
          eeglab_subject_tf_plot_2conditions(project_settings, cond2, cond1, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project_settings, cond3, cond2, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project_settings, cond3, cond1, electrode2inspect, stat_threshold, save_figure, results_path);
%          eeglab_subject_tf_plot_2conditions(project_settings, cond3, cond4, electrode2inspect, stat_threshold, save_figure, results_path);
    end
end
%==================================================================================
%==================================================================================