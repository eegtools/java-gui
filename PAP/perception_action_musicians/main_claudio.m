% to be edited according to calling PC local file system
local_projects_data_path='I:\Projects\';
eegtools_svn_local_path='D:\behaviourPlatform\EEG_Tools\';
plugins_path='D:\Matlab-work\matlab_toolbox\';
global_scripts_path='D:\behaviourPlatform\EEG_Tools\global_scripts\';

os = system_dependent('getos');
if  strncmp(os,'Linux',2)
    local_projects_data_path='/media/ADATA/Projects/';
    eegtools_svn_local_path='/media/Data/behaviourPlatform/EEG_Tools/';
    plugins_path='/media/Data/Matlab-work/matlab_toolbox/';
    global_scripts_path='/media/Data/behaviourPlatform/EEG_Tools/global_scripts/';

end



protocol_name='perception_action_musicians';                ... must correspond to brainstorm db name
project_folder='perception_action_musicians';               ... must correspond to 'local_projects_data_path' subfolder name
db_folder_name='bst_db';                                ... must correspond to db folder name contained in 'project_folder'    
analysis_name='';   
acquisition_system='BIOSEMI';... subfolder containing the current analysis type (refers to EEG device input data type)


conf_file_name='project_config.m';                      ...configuration file name
global_scripts_path=fullfile(eegtools_svn_local_path, 'global_scripts');
addpath(global_scripts_path);
define_paths    

% load configuration file
[path,name_noext,ext] = fileparts(project_settings);
addpath(path);    eval(name_noext);

%create a cell array of strings  (the names of the subjects)
files_list=dir(bdf_path);
files_list={files_list.name};
files_list=files_list(3:end);
subjects_list={};
for nf = 1:length(files_list)
    ff=char(files_list(nf));
    subjects_list(nf)={ff(1:end-4)};
end
numsubj=length(subjects_list);


pre_epoching_input_file_name = '_raw';


stat_analysis_suffix='test_order_design_';
if ~ isempty(stat_analysis_suffix)
    stat_analysis_suffix=[stat_analysis_suffix,'-',datestr(now,30)];
end


%=====================================================================================================================================================================
% ======= OPERATIONS LIST ============================================================================================================================================
do_import=0;
do_correct_eve_type=0;
do_correct_ureve_type=0;

do_patch_triggers=0;
do_auto_pauses_removal=0;

do_add_eve1_pre_eve2=0;
do_add_label_eve_around=0;

do_ica=0;



do_test_art=0;




do_epochs=0;

do_factors=0;

do_select_eeg=0;


do_study=0;
do_design=0;
do_study_compute_channels_measures=0;




do_study_plot_roi_erp_curve=0;
do_study_plot_roi_erp_curve_tw=0;

do_study_plot_erp_topo_tw=0;

do_study_plot_roi_ersp_tf=0;
do_study_plot_roi_ersp_tf_tw_fb=0;


do_study_plot_roi_ersp_curve_fb=1;
do_study_plot_roi_ersp_curve_tw_fb=0;

do_study_plot_ersp_topo_tw_fb=0;


do_eeglab_study_export_erp_r=0;
do_eeglab_study_export_ersp_tf_r=0;

% vettore con indici soggetti da analizzare
vecsub=1:numsubj;%1:2;%1:numsubj;%35:numsubj;%33:numsubj;
% vettore di indici (nella lista dei design contenuta in SUDY.design) dei deign da analizzare
vec_sel_design=2:17;
% vettore di indici (nel vettore vec_sel_design) che consente, all'interno
% della lista globale dei design di interesse, di rifare i conti solo su
% un sotoinsieme di design
sel_designs=1;%:length(vec_sel_design);




%alberto
do_ica_review=0;
do_singlesubjects_betaband_comparison=0;
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T    P R O C E S S I N G  ==========================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================





if do_import
    for subj=vecsub
        eeglab_subject_import_event_bck(project_settings, fullfile(bdf_path, [subjects_list{subj} '.bdf']), epochs_path, acquisition_system, nch_eeg, [],[],[],[]);
        file_name=fullfile(epochs_path, [subjects_list{subj} '_raw.set']);
        %eeglab_subject_transform_poly(project_settings, file_name, epochs_path, nch_eeg, polygraphic_channels)
%         eeglab_subject_emgextraction_epoching(project_settings, file_name, emg_output_postfix_name, emg_epochs_path);
    end
end


if do_correct_eve_type
    arr_subject_correct_eve_type=cell(1,numsubj);
    for subj=vecsub
        arr_subject_correct_eve_type{subj}=[subjects_list{subj} analysis_name '_raw' '.set'];
    end
    
    for subj=vecsub
        EEG = eeglab_subject_correct_event_code_biosemi(project_settings,fullfile(epochs_path, arr_subject_correct_eve_type{subj}));
    end 
    

end


if do_correct_ureve_type
    arr_subject_correct_ureve_type=cell(1,numsubj);
    for subj=vecsub
        arr_subject_correct_ureve_type{subj}=[subjects_list{subj} analysis_name '_raw' '.set'];
    end
    
    for subj=vecsub
        EEG = eeglab_subject_correct_urevent_code_biosemi(project_settings,fullfile(epochs_path, arr_subject_correct_ureve_type{subj}));
    end 
    

end




if do_auto_pauses_removal
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_events_remove_upto_triggercode(project_settings, file_name, start_experiment_trigger_value); ... return if find a boundary as first event
%         eeglab_subject_events_remove_after_triggercode(project_settings, file_name, end_experiment_trigger_value); ... return if find a boundary as first event
%         pause_resume_errors=eeglab_subject_events_check_2triggers_orders(project_settings, file_name,pause_trigger_value, resume_trigger_value);
%         if isempty(pause_resume_errors)
%             disp('====>> pause/remove triggers sequence ok....move to pause removal');
%             eeglab_subject_remove_pauses(project_settings, file_name, pause_trigger_value, resume_trigger_value);
%         else
%             disp('====>> errors in pause/resume trigger sequence');
%             pause_resume_errors
%         end
    end
end


if do_test_art
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        EEG=eeglab_subject_test_art(project_settings, file_name, epochs_path, nch_eeg);
    end
end



if do_ica
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_ica(project_settings, file_name, epochs_path, nch_eeg, 'cudaica');
    end
end


if do_add_eve1_pre_eve2
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        list_class_eve1={'203' '204' '207' '208' '201' '202''209' '210' '219' '220' '221' '222' '22' '40' '11' '10' '21' '20'};
        list_class_eve2_1={'42'};
        list_class_eve2_2={'41'};
        EEG = eeglab_subject_add_eve_on_eve1_nlags_from_eve2(project_settings, file_name, list_class_eve1, list_class_eve2_1, 2500,[],'-R',-1);
        EEG = eeglab_subject_add_eve_on_eve1_nlags_from_eve2(project_settings, file_name, list_class_eve1, list_class_eve2_2, 2500,[],'-W',-1);

        
    end
end


if do_add_label_eve_around
    class_eve='22';
    list_class_eve={ '22' '201' '202'  '203' '204' '207' '208' '209' '210' '219' '220' '221' '222' '41' '42'};
    lagvec=[-1,1];
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
         EEG =  eeglab_subject_add_label_eve_around(project_settings, file_name, class_eve,list_class_eve,lagvec);
    end
end





if do_ica_review
    % calculate IC which show intervals outside Xtimes their standard deviations
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_remove_segments_ica(project_settings, file_name, 3, 5);
    end
end
%==================================================================================
if do_epochs
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=vecsub
        file_name=fullfile(epochs_path, [subjects_list{subj} pre_epoching_input_file_name '.set']);
        eeglab_subject_epoching_baseline_remove_bck(project_settings, file_name, epochs_path);
    end
    
    %for subj=1:length(subjects_to_swap)
    %    input_file_name=fullfile(epochs_path, [subjects_to_swap{subj} pre_epoching_input_file_name '.set']);
    %    output_file_name=fullfile(epochs_path, [subjects_to_swap{subj} '_sw' pre_epoching_input_file_name '.set']);
    %    eeglab_subject_swap_electrodes(project_settings, input_file_name, output_file_name);
    %end
end

%==================================================================================


% versione pi� figa perch� usa direttamente il nome del file e non la
% condizione (� pi� generale, puoi usarla anche per il gruppo o mettere degli OR ed accorpare livelli tipo gruppi)
if do_factors
    for subj=1:length(subjects_list(vecsub))
        for cond=1:length(condition_names)
            setname=[subjects_list{subj} , pre_epoching_input_file_name,'_' , condition_names{cond} '.set'];
            fullsetname=fullfile(epochs_path,setname,'');
            eeglab_subject_add_factor_bck(project_settings,fullsetname, add_factor_bck_list);
        end
    end

end




% % versione pi� figa perch� usa direttamente il nome del file e non la
% % condizione (� pi� generale, puoi usarla anche per il gruppo o mettere degli OR ed accorpare livelli tipo gruppi)
% if do_factors
%     for subj=1:length(subjects_list(vecsub))
%         for cond=1:length(condition_names)
%             setname=[subjects_list{subj} , pre_epoching_input_file_name,'_' , condition_names{cond} '.set'];
%             fullsetname=fullfile(epochs_path,setname,'');
%             if strfind(fullsetname,'M')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'CueVsImperative', 'Match');                    
%             end
%             
%             if strfind(fullsetname,'MM')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'CueVsImperative', 'Mismatch');                    
%             end
%                         
%             if strfind(fullsetname,'100')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Anticipation', '100');
%             end
% 
%             if strfind(fullsetname,'300')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Anticipation', '300');
%             end
%             
%             if strfind(fullsetname,'-R')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Response', 'Right');
%             end
%             
%             
%             if strfind(fullsetname,'-W')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Response', 'Wrong');
%             end
%             
%             if strfind(fullsetname,'-note')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Cue', 'Note');
%             end
%             
%             if strfind(fullsetname,'passive')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Status', 'Passive');
%             end
%             
%             if strfind(fullsetname,'active')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Status', 'Active');
%             end
%             
%         end
%     end
% 
% end


if do_select_eeg
    for subj=1:length(subjects_list(vecsub))
        for cond=1:length(condition_names)
            setname=[subjects_list{subj} , pre_epoching_input_file_name,'_' , condition_names{cond} '.set'];
            fullsetname=fullfile(epochs_path,setname,'');
            EEG = eeglab_subject_sel_eeg(project_settings, fullsetname, epochs_path, nch_eeg);
        end
    end    
    
end


%=====================================================================================================================================================================
%===================================================================================================================================================================
% GROUP STATS
%===================================================================================================================================================================
%===================================================================================================================================================================
if do_study
    [STUDY, EEG]=eeglab_study_create_bck(project_settings,protocol_name, condition_names, group_list, pre_epoching_input_file_name, epochs_path);
end

if do_design
    [STUDY, EEG]=eeglab_study_define_design_bck(project_settings,fullfile(epochs_path, [protocol_name, '.study']), design_list_bck,design_pairing_list_bck);
end

if do_study_compute_channels_measures   
    tot_des=length(design_list_bck)+1;    
    design_num_vec=2:tot_des;%2:tot_des;    
        eeglab_study_compute_channels_measures_bck(project_settings,fullfile(epochs_path, [protocol_name, '.study']), design_num_vec, timeout_analysis_interval, freqout_analysis_interval, ...
            {'ERP'}, 'on', baseline_analysis_interval,[]);    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%% statistical analyses

%%%%%%%%%%%%%%%%%%%%%%%%%%%% erp analysis

% anaylyzes and plots of erp curve for all time points
if do_study_plot_roi_erp_curve
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-erp_curve','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_erp_curve(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,  [], [],study_ls,num_permutations,correction,[],200,plot_dir,design_pairing_list_bck{sel_des},stat_method,display_only_significant,display_compact_plots_erp, compact_display_h0_erp,compact_display_v0_erp,compact_display_sem_erp,compact_display_stats_erp,display_single_subjects,compact_display_xlim_erp,compact_display_ylim_erp);
    end
end

% analyzes and plots of erp curve for time windows of the selected design
if do_study_plot_roi_erp_curve_tw
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-erp_curve_tw','-',datestr(now,30)]);
        mkdir(plot_dir);        
        eeglab_study_plot_roi_erp_curve(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,  time_windows_list{sel_des}, time_windows_names{sel_des},study_ls,num_permutations,correction,[],200,plot_dir,design_pairing_list_bck{sel_des},stat_method,display_only_significant,display_compact_plots_erp, compact_display_h0_erp,compact_display_v0_erp,compact_display_sem_erp,compact_display_stats_erp,display_single_subjects,compact_display_xlim_erp,compact_display_ylim_erp); 
    end
end

% analyzes and plots of erp topographical maps for time windows of the selected design
if do_study_plot_erp_topo_tw
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-erp_topo','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_erp_topo_tw(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des, time_windows_list{sel_des},time_windows_names{sel_des},study_ls,num_permutations,correction,[-3,3],plot_dir,design_pairing_list_bck{sel_des},stat_method);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% ersp analysis

% anaylyzes and plots of ersp time frequency distribution for all time-frequency points
if do_study_plot_roi_ersp_tf    
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];    
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_tf','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_tf(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,2,[],[],[],[],[120],plot_dir,design_pairing_list_bck{sel_des},stat_method,freq_scale);
    end                           
end

% anaylyzes and plots of ersp time frequency distribution for all seletced time-frequency bins
if do_study_plot_roi_ersp_tf_tw_fb && length(frequency_bands_list)>1   
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];    
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_tf_tw_fb','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_tf(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,1,time_windows_list{sel_des},time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,0,plot_dir,design_pairing_list_bck{sel_des},stat_method,freq_scale);
    end                           
end

% anaylyzes and plots of ersp curve of a frequency band for all time-frequency points
if do_study_plot_roi_ersp_curve_fb
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_curve','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_curve_fb(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,  [], [],frequency_bands_list,...
        frequency_bands_names,study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)],...
        200,plot_dir,design_pairing_list_bck{sel_des},stat_method,display_only_significant,...
        display_compact_plots_ersp_curve_fb, compact_display_h0_ersp_curve_fb,compact_display_v0_ersp_curve_fb,compact_display_sem_ersp_curve_fb,compact_display_stats_ersp_curve_fb,...
        display_single_subjects,compact_display_xlim_ersp_curve_fb,compact_display_ylim_ersp_curve_fb);
    end                           
end

% anaylyzes and plots of ersp curve of a frequency band for all time windows
if do_study_plot_roi_ersp_curve_tw_fb
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=vec_sel_design(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_curve_tw','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_curve_fb(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,time_windows_list{sel_des}, ...
        time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,  study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)]...
        ,200,plot_dir,design_pairing_list_bck{sel_des},stat_method,display_only_significant,...    
        display_compact_plots_ersp_curve_fb, compact_display_h0_ersp_curve_fb,compact_display_v0_ersp_curve_fb,compact_display_sem_ersp_curve_fb,compact_display_stats_ersp_curve_fb,...
        display_single_subjects,compact_display_xlim_ersp_curve_fb,compact_display_ylim_ersp_curve_fb);
    
    
  
    
    
    
    
    
    end                           
end


% analyzes and plots of ersp topographical maps for the selected bands in the time windows of the selected design
if do_study_plot_ersp_topo_tw_fb
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs)
        sel_des=vec_sel_design(sel_designs(design_num));
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_tf_topo','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_ersp_topo_tw_fb(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des, time_windows_list{sel_des},time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,study_ls,num_permutations,correction,[-3,3],plot_dir,design_pairing_list_bck{sel_des},stat_method);        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% export to R
if do_eeglab_study_export_ersp_tf_r
%     vec_sel_design=[2,8,9];
%     sel_designs=[1:3];
    for design_num=1:length(sel_designs)
        sel_des=vec_sel_design(sel_designs(design_num));
        eeglab_study_export_tf_r(project_settings, fullfile(epochs_path, [protocol_name, '.study']), sel_des, export_r_bands, tf_path);
    end
end
