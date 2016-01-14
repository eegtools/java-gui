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


%==================================================================================
%==================================================================================
% 2 x 2 design: cwalker, cscrambled, twalker, tscrambled
% two main effects:         m1) centered    vs translating
%                           m2) walker      vs scrambled
%                    
% four posthoc contrasts:   p1) cwalker     vs cscrambled
%                           p2) twalker     vs tscrambled
%                           p3) cwalker     vs twalker
%                           p4) cscrambled  vs tscrambled
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
% epoched data were processed in BRAINSTORM for source and connectivity analysis
%       a common MRI and electrode montage is used => a common BEM was created and copied to all subjects.
%       for each subject a noise estimation was computed over the first conditions and then copied (since baseline was computed with all conditions) to all other conditions
%       source analysis was performed in three different sources spaces:
%       a)  using the standard 15000 vertices
%       b)  downsampling the cortex to 3000 vertices
%       c)  downsampling the cortex to 500 vertices
%       Time-frequency analysis of specific scouts and in four frequency bands: teta, mu, beta1, beta2
%======================= PROJECT DATA start here ==================================
protocol_name='moving_scrambled_walker';                ... must correspond to brainstorm db name
project_folder='moving_scrambled_walker';               ... must correspond to 'local_projects_data_path' subfolder name
db_folder_name='bst_db';                                ... must correspond to db folder name contained in 'project_folder'    
analysis_name='OCICA_250';                              ... subfolder containing the current analysis type (refers to EEG device input data type)


conf_file_name='project_config_test4.m';                      ...configuration file name

stat_analysis_suffix='results_10000_000156_nse';
if ~ isempty(stat_analysis_suffix)
    stat_analysis_suffix=[stat_analysis_suffix,'-',datestr(now,30)];
end

%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%  OVERRIDE
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================

% ======= OPERATIONS LIST =========================================================


do_csd=0;

do_factors=0;
do_study=0;
do_design=0;
do_study_invert_polarity=0;
do_study_invert_polarity2=0;
do_study_compute_channels_measures=0;

do_study_plot_roi_erp_curve=1;
do_study_plot_roi_erp_curve_tw=1;

do_study_plot_erp_topo_tw=0;

do_study_plot_roi_ersp_tf=0;
do_study_plot_roi_ersp_tf_tw_fb=0;


do_study_plot_roi_ersp_curve_fb=1;
do_study_plot_roi_ersp_curve_tw_fb=1;

do_study_plot_ersp_topo_tw_fb=0;


do_eeglab_study_export_erp_r=0;
do_eeglab_study_export_ersp_tf_r=0;




do_epochs=0;
do_tf=0;
do_brainstorm_import_averaging=0;
do_brainstorm_averaging_main_effects=0;
do_common_noise_estimation=0;   ... possible if baseline correction was calculated using all the conditions pre-stimulus
do_bem=0;
do_check_bem=0;
do_sources=0;
do_sources_tf=0;
do_sources_scouts_tf=0;
do_spatial_reduction=0;
do_subjects_averaging=0;        averaging_filename='timefreq_morlet_wmne_s500_teta_mu_beta1_beta2_zscore';
do_group_analysis=0;
do_group_analysis_atlas=0;
do_group_analysis_tf=0;
do_group_analysis_scouts_tf=0;
do_process_stats_sources=0;           process_result_string='wmne_s500.mat';     % substring used to get and process specific results file
do_process_stats_scouts_tf=0;         process_result_string='timefreq_morlet_wmne_teta_mu_beta1_beta2_69scouts_zscore.mat';     % substring used to get and process specific results file
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T ==================================================================================================================================
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
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end




if do_csd
%     apply laplacian
  for subj=1:length(subjects_list)
    for cond=1:length(conditions_list)
        setname=[subjects_list{subj} '_',analysis_name '_'  conditions_list{cond} '.set'];
        fullsetname=fullfile([epochs_path,'_csd'],setname,'');       
        eeglab_subject_csd(project_settings, fullsetname, [epochs_path,'_csd'], nch_eeg);
    end
  end

end





% versione pi� figa perch� usa direttamente il nome del file e non la
% condizione (� pi� generale, puoi usarla anche per il gruppo o mettere degli OR ed accorpare livelli tipo gruppi)
if do_factors
    for subj=1:length(subjects_list)
        for cond=1:length(conditions_list)
            setname=[subjects_list{subj} '_',analysis_name '_'  conditions_list{cond} '.set'];
            fullsetname=fullfile(epochs_path,setname,'');
            if strfind(fullsetname,'twalker')
                    eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'translating');
                    eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'walker');                    
            end
            
            if strfind(fullsetname,'cwalker')
                    eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'centered');
                    eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'walker');                    
            end

            if strfind(fullsetname,'tscrambled')
                    eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'translating');
                    eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'scrambled');                    
            end
            
            if strfind(fullsetname,'cscrambled')
                    eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'centered');
                    eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'scrambled');                            
            end
            
        end
    end
    
% versione con le condizioni    
% for subj=1:length(subjects_list)
%         for cond=1:length(conditions_list)
%             setname=[subjects_list{subj} '_',analysis_name '_'  conditions_list{cond} '.set'];
%             fullsetname=fullfile(epochs_path,setname,'');
%             switch conditions_list{cond}
%                 case'twalker'
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'translating');
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'walker');                    
% 
%                 case'cwalker'
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'centered');
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'walker');                    
% 
%                 case'tscrambled'
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'translating');
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'scrambled');                    
% 
%                 case'cscrambled'
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'motion', 'centered');
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'shape', 'scrambled');                            
%             end
%         end
%     end    
    
    
    
    
    
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% group analysis

%%%%%%%%%%%%%%%%%%%%%%%%%%%% preliminary steps

% create an STUDY for the group analysis using the datasets of single subjects and conditions 
if do_study
    pre_epoching_suffix='';
    eeglab_study_create(project_settings,protocol_name, subjects_list, conditions_list, analysis_name,  pre_epoching_suffix, epochs_path);
end

% create study design(s) to compare groups, conditions and - in general - different levels of user defined factors
if do_design
    eeglab_study_define_design(project_settings,fullfile(epochs_path, [protocol_name, '.study']), designs_list);
end

% compute measure for all datasets to be considered in a STUDY design (allowing statistical comparisons) 
if do_study_compute_channels_measures   
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));
        eeglab_study_compute_channels_measures(project_settings, fullfile(epochs_path, [protocol_name, '.study']), sel_des,  timeout_analysis_interval, freqout_analysis_interval, 'ALL','on');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% statistical analyses

%%%%%%%%%%%%%%%%%%%%%%%%%%%% erp analysis

% anaylyzes and plots of erp curve for all time points
if do_study_plot_roi_erp_curve
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-erp_curve','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_erp_curve(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,  [], [],study_ls,num_permutations,correction,[],200,plot_dir,paired_list{sel_des},stat_method,display_only_significant,display_compact_plots_erp, compact_display_h0_erp,compact_display_v0_erp,compact_display_sem_erp,compact_display_stats_erp,display_single_subjects,compact_display_xlim_erp,compact_display_ylim_erp);
    end
end

% analyzes and plots of erp curve for time windows of the selected design
if do_study_plot_roi_erp_curve_tw
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-erp_curve_tw','-',datestr(now,30)]);
        mkdir(plot_dir);        
        eeglab_study_plot_roi_erp_curve(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,  time_windows_list{sel_des}, time_windows_names{sel_des},study_ls,num_permutations,correction,[],200,plot_dir,paired_list{sel_des},stat_method,display_only_significant,display_compact_plots_erp, compact_display_h0_erp,compact_display_v0_erp,compact_display_sem_erp,compact_display_stats_erp,display_single_subjects,compact_display_xlim_erp,compact_display_ylim_erp); 
    end
end

% analyzes and plots of erp topographical maps for time windows of the selected design
if do_study_plot_erp_topo_tw
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-erp_topo','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_erp_topo_tw(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des, time_windows_list{sel_des},time_windows_names{sel_des},study_ls,num_permutations,correction,[-3,3],plot_dir,paired_list{sel_des},stat_method);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% ersp analysis

% anaylyzes and plots of ersp time frequency distribution for all time-frequency points
if do_study_plot_roi_ersp_tf    
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];    
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_tf','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_tf(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,2,[],[],[],[],[120],plot_dir,paired_list{sel_des},stat_method,freq_scale);
    end                           
end

% anaylyzes and plots of ersp time frequency distribution for all seletced time-frequency bins
if do_study_plot_roi_ersp_tf_tw_fb && length(frequency_bands_list)>1   
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];    
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_tf_tw_fb','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_tf(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,study_ls,num_permutations,correction,[-3,3],[min(timeout_analysis_interval),max(timeout_analysis_interval)],[min(freqout_analysis_interval),max(freqout_analysis_interval)],1,1,time_windows_list{sel_des},time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,0,plot_dir,paired_list{sel_des},stat_method,freq_scale);
    end                           
end

% anaylyzes and plots of ersp curve of a frequency band for all time-frequency points
if do_study_plot_roi_ersp_curve_fb
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_curve','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_curve_fb(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,  [], [],frequency_bands_list,...
        frequency_bands_names,study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)],...
        200,plot_dir,paired_list{sel_des},stat_method,display_only_significant,...
        display_compact_plots_ersp_curve_fb, compact_display_h0_ersp_curve_fb,compact_display_v0_ersp_curve_fb,compact_display_sem_ersp_curve_fb,compact_display_stats_ersp_curve_fb,...
        display_single_subjects,compact_display_xlim_ersp_curve_fb,compact_display_ylim_ersp_curve_fb);
    end                           
end

% anaylyzes and plots of ersp curve of a frequency band for all time windows
if do_study_plot_roi_ersp_curve_tw_fb
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs) 
        sel_des=list_sel_designs(sel_designs(design_num));        
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_curve_tw','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_roi_ersp_curve_fb(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des,roi_list,roi_names,time_windows_list{sel_des}, ...
        time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,  study_ls,num_permutations,correction,[min(timeout_analysis_interval),max(timeout_analysis_interval)]...
        ,200,plot_dir,paired_list{sel_des},stat_method,display_only_significant,...    
        display_compact_plots_ersp_curve_fb, compact_display_h0_ersp_curve_fb,compact_display_v0_ersp_curve_fb,compact_display_sem_ersp_curve_fb,compact_display_stats_ersp_curve_fb,...
        display_single_subjects,compact_display_xlim_ersp_curve_fb,compact_display_ylim_ersp_curve_fb);
    
    
  
    
    
    
    
    
    end                           
end


% analyzes and plots of ersp topographical maps for the selected bands in the time windows of the selected design
if do_study_plot_ersp_topo_tw_fb
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs)
        sel_des=list_sel_designs(sel_designs(design_num));
        plot_dir=fullfile(results_path,stat_analysis_suffix,[design_names{sel_des},'-ersp_tf_topo','-',datestr(now,30)]);
        mkdir(plot_dir);
        eeglab_study_plot_ersp_topo_tw_fb(project_settings,fullfile(epochs_path, [protocol_name, '.study']), sel_des, time_windows_list{sel_des},time_windows_names{sel_des},frequency_bands_list,frequency_bands_names,study_ls,num_permutations,correction,[-3,3],plot_dir,paired_list{sel_des},stat_method);        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%% export to R
if do_eeglab_study_export_ersp_tf_r
    list_sel_designs=[2,8,9];
    sel_designs=[1:3];
    for design_num=1:length(sel_designs)
        sel_des=list_sel_designs(sel_designs(design_num));
        eeglab_study_export_tf_r(project_settings, fullfile(epochs_path, [protocol_name, '.study']), sel_des, export_r_bands, tf_path);
    end
end