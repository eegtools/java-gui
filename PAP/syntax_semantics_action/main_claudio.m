% to be edited according to calling PC local file system
local_projects_data_path='G:\';
svn_local_path='G:\behaviourPlatform_svn\EEG_Tools';
plugins_path='G:\groups\behaviour_lab\Projects\EEG_tools\matlab_toolbox';
global_scripts_path='G:\behaviourPlatform_svn\EEG_Tools\global_scripts';
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
protocol_name='syntax_semantics_action';                ... must correspond to brainstorm db name
project_folder='syntax_semantics_action';               ... must correspond to 'local_projects_data_path' subfolder name
db_folder_name='bst_db';                                ... must correspond to db folder name contained in 'project_folder'    
analysis_name='OCICA_250';                              ... subfolder containing the current analysis type (refers to EEG device input data type)
pre_epoching_suffix='_raw_ica_clean';
conf_file_name='project_config.m';                      ...configuration file name

%create a cell array of strings  (the names of the subjects)






%#######################################################################################
%EEGLAB settings
%
interpolate_channels=[];
reference_channels={'TP9', 'TP10'};

healthy_subjects=[1:2,4:20];
% healthy_subjects=1;
tsub=length(healthy_subjects);
subjects_list = cell(tsub,1);

for i=1:8
    subjects_list{i} = ['Syntax_AC000' num2str(healthy_subjects(i))];
end

for i=9:tsub
    subjects_list{i} = ['Syntax_AC00' num2str(healthy_subjects(i))];
end
numsubj=length(subjects_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert names of conditions

% conditions: marker codes & name
valid_marker={'S193' 'S194' 'S230' 'S235' 'S236' 'S240' 'S245' 'S246' 'S185' 'S186' 'S205' 'S235' 'S245' 'S206' 'S236' 'S246' 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 18' 'S 19' 'S 20' 'S201' 'S205' 'S240' 'S245' 'S206' 'S230' 'S235' 'S236', 'S246'};
% conditions: marker codes & name
mrkcode_cond={{'S193'};... syntax_1fm
		      {'S194'};... syntax_2fm
		      {'S230' 'S235' 'S236'};... control_syntax_1fm
              {'S240' 'S245' 'S246'};... control_syntax_2fm              
              {'S185'};... semantics_1fm
              {'S186'};... semantics_2fm
              {'S205' 'S235' 'S245'};... control_semantics_1fm
              {'S206' 'S236' 'S246'};... control_semantics_2fm              
              { 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 18' 'S 19' 'S 20'};... 'control_scenario'              
              {'S201'};... control_scenario_lf               
              {'S205' 'S240' 'S245'};... control_scenario_mf_1f controllo dello scenario corrispondente al primo frame di (qualunque) matipolazione              
              {'S206' 'S230' 'S235' 'S236' 'S246'};... control_scenario_mf_2f controllo dello scenario corrispondente al secondo frame di (qualunque) manipolazione
              {'S205''S245''S230' 'S235' 'S236'} ... all_controls
              % questi si riferiscono a tutti i controlli del primo frame
              % indipendentemente dal tipo di manipolazione%
       

};

conditions_list={'syntax_1fm' 'syntax_2fm' 'control_syntax_1fm' 'control_syntax_2fm' 'semantics_1fm' 'semantics_2fm' 'control_semantics_1fm' 'control_semantics_2fm' 'all_controls'};
% conditions_list={'syntax_1fm' 'syntax_2fm' 'control_syntax_1fm' 'control_syntax_2fm' 'semantics_1fm' 'semantics_2fm' 'control_semantics_1fm' 'control_semantics_2fm' 'control_scenario' 'control_scenario_lf' 'control_scenario_mf_1f' 'control_scenario_mf_2f' 'all_controls'};
numcond=length(conditions_list);
designs_list={{'syntax_1fm' 'control_syntax_1fm'};...
              {'syntax_2fm' 'control_syntax_2fm'};...
              {'semantics_1fm' 'control_semantics_1fm'};...
              {'semantics_2fm' 'control_semantics_2fm'};...              
              {'control_scenario' 'control_scenario_mf_1f' 'control_scenario_lf'};...              
              {'control_scenario' 'control_scenario_mf_2f' 'control_scenario_lf'};...
              {'all_controls' 'semantics_1fm' 'syntax_1fm'}...
              % aggiungere in questo modo un design aggiuntivo che faccia%
              % un plot con la condizione di controllo e le due violazioni%
              % mettere il flag su 1 (do_design) nello script%
              % main_claudio_termocamera%
};
numdes=length(designs_list);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert rois for the analysis in EEGLAB
 
%roi_list={{'F7','F3','FC5','FC1','C3'}; ... LEFT ANTERIOR(LA)
          %{'F8','F4','FC6','FC2','C4'}; ... RIGHT ANTERIOR(RA)
          %{'Fz','Cz'}; ... MIDLINE ANTERIOR(MA)
          %{'CP1','CP5','P3','P7','PO9','O1'}; ... LEFT POSTERIOR(LP)
          %{'CP2','CP6','P4','P8','PO10','O2'}; ... LEFT POSTERIOR(RP)
          %{'Pz','Oz'} ... MIDLINE POSTERIOR(MP)
          
          %{'TP9','T7'}; ... LEFT TEMPORO-PARIETAL(LTP)
          %{'TP10','T8'}; ... RIGHT TEMPORO-PARIETAL(RTP)
          
%};

% altra suddivisione in ROi, 4 parti (left-right anterior; left-right
% posterior con linea centrale comune sia a dx che a sx
%roi_list={{'F7','F3','FC5','FC1','C3', 'T7','Fz','Cz'}; ... LEFT ANTERIOR
          %{'F8','F4','FC6','FC2','C4', 'T8','Fz','Cz'}; ... RIGHT ANTERIOR
          %{'T7','C3','Cz','CP1','CP5','TP9','P7','P3','Pz','Oz','O1','P09'}; ...LEFT POSTERIOR
          %{'CP2','CP6','P4','P8','PO10','O2','0z','Pz','Cz','C4','T8','TP10'}; ... RIGHT POSTERIOR
    
          
%};
%%% roi proposte da Alessandro
roi_list={{'F7','F3','FC5','FC1'}; ... LEFT ANTERIOR
          {'F8','F4','FC6','FC2'}; ... RIGHT ANTERIOR
          {'CP1','CP5','P7','P3'}; ...LEFT POSTERIOR
          {'CP2','CP6','P4','P8'}; ... RIGHT POSTERIOR
    
          
};
numroi=length(roi_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert parameters for ERP analysis
%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
filter_freq=10;
%y limits (uV)for the representation of ERP
ylim_plot=[-2.5 2.5];
% for each design of interest, time limits (ms) of the time windws applied for topographycal representations
time_windows_list={{[100 250];[300 600];[500 800];};... time window of syntax
                  { [100 250];[300 600];[500 800];};... time window of semantics
                  {[300 600]; [500 800]; [600 800]; [600 1000]; [350 600]; [150 350]; [200 400]}... time window of both
           }; 
% for each design of interst, perform or not statistical analysis of erp
show_statistics_list={'on','on','off'};   
% time range for erp representation
time_range=[-200 1000];
% level of significance applied in ERP statistical analysis
study_ls=0.01;
% number of permutations applied in ERP statistical analysis
num_permutations=100;
% method applied in ERP statistical analysis
stat_method='permutation';
% multiple comparison correction applied in ERP statistical analysis
correction='bonferroni';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end EEGLAB settings





























%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert parameters for BRAINSTORM
 
stat_correction = 'fdr';
stat_threshold = 0.01;
%==================================================================================
% ======= SOURCES PARAMS ==========================================================
sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
source_orient='fixed';      % possible values are: fixed, loose
loose_value=0.2;
%depth_weighting='nodepth'; % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
downsample_atlasname='s500';
% ======= TF PARAMS ===================================================================
brainstorm_analysis_bands={{'teta', '4, 8', 'mean'; 'mu', '8, 13', 'mean'; 'beta1', '14, 20', 'mean'; 'beta2', '20, 32', 'mean'}};
brainstorm_analysis_times=[]; ... {{'t-4', '-0.4, -0.304', 'mean'; 't-3', '-0.3, -0.204', 'mean'; 't-2', '-0.2, -0.104', 'mean'; 't-1', '-0.1, -0.004', 'mean'; 't1', '0.0, 0.096', 'mean'; 't2', '0.1, 0.1960', 'mean'; 't3', '0.2, 0.2960', 'mean'; 't4', '0.3, 0.3960', 'mean'; 't5', '0.4, 0.4960', 'mean'; 't6', '0.5, 0.5960', 'mean'; 't7', '0.6, 0.696', 'mean'; 't8', '0.7, 0.796', 'mean'; 't9', '0.8, 0.896', 'mean'; 't10', '0.9, 0.996', 'mean'}};
zscore_overwriting=1; ... 1: calculate zscore and overwrite tf result file, 0: calculate zscore and create new tf result zscore file, -1: do not calculate zscore
% ======= MULTIPLE CORRECTION PARAMS ==============================================
StatThreshOptions.Control = 'space';
StatThreshOptions.Correction = stat_correction;
StatThreshOptions.pThreshold = stat_threshold;
% bst_set('StatThreshOptions', StatThreshOptions);
%==================================================================================
% ======= OPERATIONS LIST =========================================================
do_import2eeglab=0;
do_subject_ica=0;
do_subject_copyset=0;
do_lastframe=0;
do_epochs=0;
do_subject_merge_conditions=0;

do_study=0;
do_design=0;
do_study_invert_polarity=0;
do_study_invert_polarity2=0;
do_study_compute_channels_measures=0;
do_study_plot_roi_erp=1;
do_eeglab_study_export_erp_r=0;



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
addpath(global_scripts_path);
define_paths    
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end


if do_import2eeglab
    arr_vhdr=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_import2eeglab{nsubj}=[subjects_list{nsubj} '_' analysis_name '.vhdr'];
    end
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(arr_import2eeglab)
        EEG = eeglab_subject_import_event(fullfile(vhdr_path, arr_import2eeglab{subj}), epochs_path, project_settings, 'BRAINAMP', 32,'all',interpolate_channels,reference_channels);
    end 
end

if do_subject_ica
    arr_subject_ica=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_subject_ica{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw' '.set'];
    end
    
    for subj=1:numsubj
        EEG = eeglab_subject_ica(fullfile(epochs_path, arr_subject_ica{subj}), epochs_path, 32, 'runica',project_settings);
    end 
    
    
end


if do_subject_copyset
    
    arr_subject_ica=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_subject_ica{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw' '.set'];
    end
    
    arr_subject_copyset=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_subject_copyset{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw_ica' '.set'];
    end

    for subj=1:length(arr_subject_copyset)
        EEG=pop_loadset(fullfile(epochs_path, arr_subject_copyset{subj}));
        EEG = pop_saveset( EEG, 'filename',arr_subject_ica{subj},'filepath',epochs_path);
    end 
    
end

if do_lastframe
    for nsubj=1:numsubj
        arr_subject_epochs{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw_ica_clean' '.set'];
    end
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(subjects_list)
        eeglab_subject_add_eve1_pre_eve2(fullfile(epochs_path,  arr_subject_epochs{subj}),  'S200','S254', 1500,'S201',  project_settings);
    end
    
    
    
end


if do_epochs
    
    for nsubj=1:numsubj
        arr_subject_epochs{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw_ica_clean' '.set'];
    end
    
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:numsubj
        eeglab_subject_epoching_baseline_remove(fullfile(epochs_path,  arr_subject_epochs{subj}),epochs_path, project_settings);
    end
end


if do_subject_merge_conditions
     

     for nsubj=1:numsubj
        arr_subject_input1{nsubj}=[subjects_list{nsubj} '_' analysis_name pre_epoching_suffix '_' conditions_list{3} '.set'];
        arr_subject_input2{nsubj}=[subjects_list{nsubj} '_' analysis_name pre_epoching_suffix '_' conditions_list{7} '.set'];
        arr_subject_output{nsubj}=[subjects_list{nsubj} '_' analysis_name pre_epoching_suffix '_' conditions_list{length(conditions_list)} '.set'];
     end
    
     % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for nsubj=1:numsubj
        eeglab_subject_merge_conditions(fullfile(epochs_path,  arr_subject_input1{nsubj}),...
                                        fullfile(epochs_path, arr_subject_input2{nsubj}),... 
                                        fullfile(epochs_path, arr_subject_output{nsubj}), project_settings);
    end
     

end




if do_study
    pre_epoching_suffix='_raw_ica_clean';
    eeglab_study_create(project_settings,protocol_name, subjects_list, conditions_list, analysis_name,  pre_epoching_suffix, epochs_path);
end

if do_design
    eeglab_study_define_design(project_settings,fullfile(epochs_path, [protocol_name, '.study']), designs_list);
end


if do_study_invert_polarity
    eeglab_study_invert_polarity(project_settings,fullfile(epochs_path, [protocol_name, '.study']));
end

if do_study_invert_polarity2
    arr_subject_inv={};
    num2invert=[12];
    subjects_invert=subjects_list(num2invert);
    numsubinv=length(subjects_invert);
    nset=1;
    for nsubj=1:numsubinv
        for ncond=1:numcond
            arr_subject_inv{nset}=[ subjects_invert{nsubj} '_' analysis_name '_raw_ica_clean_' conditions_list{ncond}  '.set'] ;
            aa=arr_subject_inv{nset};
            nset=nset+1;
        end
    end
    for nset=1:length(arr_subject_inv)
        EEG = pop_loadset('filename',arr_subject_inv{nset},'filepath',epochs_path);
        EEG.data=-EEG.data;
        EEG = pop_saveset( EEG, 'filename',EEG.filename,'filepath',EEG.filepath);   
    end
end

if do_study_compute_channels_measures   
    tot_des=size(designs_list,1);
    for design_num=1:tot_des %for design_num=7%1:tot_des 
        eeglab_study_compute_channels_measures(project_settings,fullfile(epochs_path, [protocol_name, '.study']), design_num, 'ERP');
    end
end

if do_study_plot_roi_erp
    %lista di design da selezionare nello studio
    list_sel_designs=[1,3,7];
    %lista di design da selezionare nelle liste di project_config (per
    %graficare solo alcuni design modificare solo questo)
    sel_designs=[1, 2];
    for design_num=1:length(sel_designs)        
        eeglab_study_plot_roi_erp(project_settings,fullfile(epochs_path, [protocol_name, '.study']), list_sel_designs(sel_designs(design_num)), roi_list,time_windows_list{sel_designs(design_num)}, show_statistics_list{sel_designs(design_num)});

    end
end

if do_eeglab_study_export_erp_r
    eeglab_study_export_erp_r(project_settings,fullfile(epochs_path, [protocol_name, '.study']), subjects_list, conditions_list, epochs_path, erp_path,analysis_name,pre_epoching_suffix)
end

