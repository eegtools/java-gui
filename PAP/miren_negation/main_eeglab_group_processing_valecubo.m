%==================================================================================
%==================================================================================
% 1 x 2 design: control, AO  : action vs no_action
% 1 x 3 design: AO, AOCS, AOIS : "paired-ANOVA" on sound effect
%                    
% four posthoc contrasts:   p1) control     vs AO
%                           p2) AO          vs AOCS
%                           p3) AO          vs AOIS
%                           p4) AOCS        vs AOIS
%==================================================================================
% data analysis:
% visual inspection in brainvision, manually removing part of continous data affected by strong artifacts.
% continous data were filtered 0.1-45 Hz, downsampled @ 250 Hz, ocular artifact automatically were removed by an ICA approach and finally exported in binary format
% continous data were imported in EEGLAB, referenced to CAR, baseline corrected (common to all conditions) then epoched and saved as SET (one for each condition)
% epoched data were processed in EEGLAB for TIMEFREQUENCY analysis
%       .............. TODO ........................
%       claudio aggiungi dettagli sull'analisi fatta
%       ............................................
%       ............................................
%=====================================================================================================================================================================
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

%=====================================================================================================================================================================
% PROJECT DATA 
%=====================================================================================================================================================================
project_folder='miren_negation';      ... must correspond to 'local_projects_data_path' subfolder name
conf_file_name='project_config.m';
%=====================================================================================================================================================================
% load configuration file
%=====================================================================================================================================================================
project_settings=fullfile(eegtools_svn_local_path, project_folder, conf_file_name);
[path,name_noext,ext] = fileparts(project_settings);
addpath(path);    eval(name_noext);

global_scripts_path=fullfile(eegtools_svn_local_path, 'global_scripts');
addpath(global_scripts_path);
define_paths    
%=====================================================================================================================================================================
%  OVERRIDE
%=====================================================================================================================================================================

stat_analysis_suffix='nan-';
if ~ isempty(stat_analysis_suffix)
    stat_analysis_suffix=[stat_analysis_suffix,'-',datestr(now,30)];
end


list_sel_designs=[1,2,3];

study_name='miren_negation_NO_18_20';


... .........................................
stat_correction = 'fdr';
stat_threshold = 0.05;
electrode2inspect='C4';
pre_epoching_input_file_name = '_raw_mc';
%=====================================================================================================================================================================
% ======= OPERATIONS LIST ============================================================================================================================================
%=====================================================================================================================================================================
do_study=0;
do_design=0;
do_study_compute_channels_measures=0;

% PLOT STATISTICS
do_study_plot_roi_erp_curve=0;
do_study_plot_roi_erp_curve_tw=0;
do_study_plot_erp_topo_tw=0;

do_study_plot_roi_ersp_tf=0;
do_study_plot_roi_ersp_tf_tw_fb=0;
do_study_plot_roi_ersp_curve_fb=0;
do_study_plot_roi_ersp_curve_tw_fb=1;
do_study_plot_ersp_topo_tw_fb=0;

do_eeglab_study_export_erp_r=0;

%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T    P R O C E S S I N G  ==========================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%===================================================================================================================================================================
% GROUP STATS
%===================================================================================================================================================================
%===================================================================================================================================================================
if do_study
    eeglab_study_create(project_settings,study_name, conditions_names, group_list, pre_epoching_input_file_name, epochs_path);
end

if do_design
    eeglab_study_define_design(project_settings,fullfile(epochs_path, [study_name, '.study']), factor1_list, group_names);
end

if do_study_compute_channels_measures   
    ...tot_des=length(within_design_list)*(length(between_design_list)+1);
    for design_num=1:num_des
        eeglab_study_compute_channels_measures(project_settings,fullfile(epochs_path, [study_name, '.study']), design_num, timeout_analysis_interval, freqout_analysis_interval, 'ALL', 'on', baseline_analysis_interval);
    end
end

%==================================================================================
%==================================================================================
% PLOT/PARSE RESULTS
%==================================================================================
% ERP analysis
sel_designs=[1:3];

% analyzes and plots erp curve for all time points
if do_study_plot_roi_erp_curve
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-erp_curve','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_erp_curve(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des,roi_list,roi_names, [], [],study_ls,num_permutations,correction,[],200,plot_dir,paired_list{sel_des},stat_method,display_only_significant,display_compact_plots, compact_display_h0,compact_display_v0,compact_display_sem,compact_display_stats,display_single_subjects);
    end
end

% analyzes and plots erp curve for time windows
if do_study_plot_roi_erp_curve_tw
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-erp_curve_tw','-',datestr(now,30)]);
        mkdir(plot_dir);        
        eeglab_study_plot_roi_erp_curve(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des,roi_list,roi_names,  time_windows_list{sel_des}, time_windows_names{sel_des},study_ls,num_permutations,correction,[],200,plot_dir,paired_list{sel_des},stat_method,display_only_significant); 
    end
end

% analyzes and plots erp topographical maps for time windows
if do_study_plot_erp_topo_tw
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-erp_topo','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_erp_topo_tw(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des, time_windows_list{sel_des},time_windows_names{sel_des},study_ls,num_permutations,correction,[-3,3],plot_dir,paired_list{sel_des},stat_method,display_only_significant);
    end
end


% ERSP analysis
% analyzes and plots ersp time frequency distribution for all time-frequency points
if do_study_plot_roi_ersp_tf    
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-ersp_tf','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_tf(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des,roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,2,[],[],[],[],[120],plot_dir,paired_list{sel_des},stat_method,freq_scale);
    end                           
end

% anaylyzes and plots ersp time frequency distribution for all seletced time-frequency bins
if do_study_plot_roi_ersp_tf_tw_fb && length(frequency_bands_list)>1   
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-ersp_tf_tw_fb','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_tf(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des,roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,1,time_windows_list{sel_des},time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,0,plot_dir,paired_list{sel_des},stat_method,freq_scale);
    end                           
end

% anaylyzes and plots ersp curve: one for each selected bands, all latencies
if do_study_plot_roi_ersp_curve_fb
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-ersp_curve','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_curve_fb(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des,roi_list,roi_names,  [], [],frequency_bands_list,frequency_bands_names,study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)],200,plot_dir,paired_list{sel_des},stat_method,display_only_significant,display_compact_plots, compact_display_h0,compact_display_v0,compact_display_sem,compact_display_stats,display_single_subjects);
    end                           
end

% anaylyzes and plots ersp curve: one for each selected bands, in the time windows
if do_study_plot_roi_ersp_curve_tw_fb
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des} '-ersp_curve_tw' '-' datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_curve_fb(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des,roi_list,roi_names,time_windows_list{sel_des}, time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,  study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)],200,plot_dir,paired_list{sel_des},stat_method,display_only_significant);
    end                           
end


% analyzes and plots ersp topographical maps: one for each selected bands, in the time windows
if do_study_plot_ersp_topo_tw_fb
    for design_num=1:length(sel_designs)
        sel_des=list_sel_designs(sel_designs(design_num));
        plot_dir=fullfile(results_path,stat_analysis_suffix,[within_design_names{sel_des},'-ersp_tf_topo','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_ersp_topo_tw_fb(project_settings,fullfile(epochs_path, [study_name, '.study']), sel_des, time_windows_list{sel_des},time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,study_ls,num_permutations,correction,[-3,3],plot_dir,paired_list{sel_des},stat_method);        
    end
end











% if do_study_plot_roi_erp
%     sel_designs=[1:5];
%     for design_num=1:length(sel_designs) 
%         plot_dir=fullfile(results_path,[datestr(now,30),'-',within_design_names{list_sel_designs(sel_designs(design_num))},'-erp']);
%         mkdir(plot_dir);
%         eeglab_study_plot_roi_erp2(project_settings,fullfile(epochs_path, [project_folder, '.study']), list_sel_designs(sel_designs(design_num)),roi_list,roi_names,  time_windows_list{sel_designs(design_num)}, time_windows_names{sel_designs(design_num)},study_ls,num_permutations,correction,[],200,plot_dir,paired_list{design_num},stat_method)
%      end
% end
% 
% if do_study_plot_roi_erp_curve
%      el_designs=[1:5];
%     for design_num=1:length(sel_designs) 
%         plot_dir=fullfile(results_path,[datestr(now,30),'-',within_design_names{list_sel_designs(sel_designs(design_num))},'-erp_curve']);
%         mkdir(plot_dir);
%         eeglab_study_plot_roi_erp2(project_settings,fullfile(epochs_path, [project_folder, '.study']), list_sel_designs(sel_designs(design_num)),roi_list,roi_names,  [], [],study_ls,num_permutations,correction,[],200,plot_dir,paired_list{design_num},stat_method)
%     end
% end
% 
% 
% if do_study_plot_roi_erp_topo
%     sel_designs=[1:5];
%     for design_num=1:length(sel_designs) 
%         plot_dir=fullfile(results_path,[datestr(now,30),'-',within_design_names{list_sel_designs(sel_designs(design_num))},'-erp_topo']);
%         mkdir(plot_dir);
%         eeglab_study_plot_erp_topo(project_settings,fullfile(epochs_path, [project_folder, '.study']), list_sel_designs(sel_designs(design_num)), time_windows_list,time_windows_names,study_ls,num_permutations,correction,[-3,3],plot_dir,paired_list{design_num},stat_method);
%     end
% end
% 
% 
% 
% if do_study_plot_roi_tf
%     sel_designs=[1:5];
%     for design_num=1:length(sel_designs) 
%         plot_dir=fullfile(results_path,[datestr(now,30),'-',within_design_names{list_sel_designs(sel_designs(design_num))},'-ersp_tf']);
%         mkdir(plot_dir);
%         eeglab_study_plot_roi_tf(project_settings,fullfile(epochs_path, [project_folder, '.study']), list_sel_designs(sel_designs(design_num)),roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,2,[],[],[120],plot_dir,paired_list{design_num},stat_method);
%     end                           
% end
% 
% if do_study_plot_roi_tf_curve
%     sel_designs=[1:5];
%     for design_num=1:length(sel_designs) 
%         plot_dir=fullfile(results_path,[datestr(now,30),'-',within_design_names{list_sel_designs(sel_designs(design_num))},'-ersp_tf_curve']);
%         mkdir(plot_dir);
%         eeglab_study_plot_roi_tf_curve2(project_settings,fullfile(epochs_path, [project_folder, '.study']), list_sel_designs(sel_designs(design_num)),roi_list,roi_names,frequency_bands_list,frequency_bands_names, time_windows_list{sel_designs(design_num)}, time_windows_names{sel_designs(design_num)},study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)],200,plot_dir,paired_list{design_num},stat_method);
%      end                           
% end
% 
% if do_study_plot_tf_topo
%     sel_designs=[1:5];
%     for design_num=1:length(sel_designs) 
%         plot_dir=fullfile(results_path,[datestr(now,30),'-',within_design_names{list_sel_designs(sel_designs(design_num))},'-ersp_tf_topo']);
%         mkdir(plot_dir);
%         eeglab_study_plot_tf_topo(project_settings,fullfile(epochs_path, [project_folder, '.study']), list_sel_designs(sel_designs(design_num)), time_windows_list,time_windows_names,frequency_bands_list,frequency_bands_names,study_ls,num_permutations,correction,[-3,3],plot_dir,paired_list{design_num},stat_method);
%         close all
%     end
% end













