% to be edited according to calling PC local file system
local_projects_data_path='G:\';
svn_local_path='G:\behaviourPlatform_svn\EEG_Tools';
plugins_path='G:\groups\behaviour_lab\Projects\EEG_tools\matlab_toolbox';
global_scripts_path='G:\behaviourPlatform_svn\EEG_Tools\global_scripts';

rmpath('C:\Users\User\Matlab-work\Toolbox\EEGLAB\functions\octavefunc\signal');
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

protocol_name='perception_action_musicians';                ... must correspond to brainstorm db name
project_folder='perception_action_musicians';               ... must correspond to 'local_projects_data_path' subfolder name
db_folder_name='bst_db';                                ... must correspond to db folder name contained in 'project_folder'    
analysis_name='';   
acquisition_system='BIOSEMI';... subfolder containing the current analysis type (refers to EEG device input data type)

conf_file_name='project_config.m';                      ...configuration file name


addpath(global_scripts_path);
define_paths  

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert names of conditions
conditions_list={'syntax_1fm' 'syntax_2fm' 'control_syntax_1fm' 'control_syntax_2fm' 'semantics_1fm' 'semantics_2fm' 'control_semantics_1fm' 'control_semantics_2fm' 'control_scenario' 'control_scenario_mf_1f' 'control_scenario_mf_2f'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stat_correction = 'fdr';
stat_threshold = 0.05;
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
do_import2eeglab=1;
do_correct_eve_type=1;
do_subject_ica=0;
do_subject_copyset=0;

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
  
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end


if do_import2eeglab
    arr_import2eeglab=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_import2eeglab{nsubj}=[subjects_list{nsubj}  analysis_name '.bdf'];
    end
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(arr_import2eeglab)
%         EEG = eeglab_subject_import_event(fullfile(bdf_path, arr_import2eeglab{subj}), epochs_path, 'BIOSEMI', 64,'all',interpolate_channels,reference_channels, project_settings);
        
       eeglab_subject_import_event(fullfile(bdf_path, arr_import2eeglab{subj}), epochs_path, acquisition_system, nch_eeg, [],[],[],polygraphic_channels, project_settings);

    
    
    end 
end

if do_correct_eve_type
    arr_subject_correct_eve_type=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_subject_correct_eve_type{nsubj}=[subjects_list{nsubj} analysis_name '_raw' '.set'];
    end
    
    for subj=1:numsubj
        EEG = eeglab_subject_correct_event_code_biosemi(fullfile(epochs_path, arr_subject_correct_eve_type{subj}));
    end 
    

end

if do_subject_ica
    arr_subject_ica=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_subject_ica{nsubj}=[subjects_list{nsubj} analysis_name '_raw' '.set'];
    end
    
    for subj=1:numsubj
        EEG = eeglab_subject_ica(fullfile(epochs_path, arr_subject_ica{subj}), epochs_path, nch_eeg, 'cudaica',project_settings);
    end 
    
    
end


 

% if do_subject_copyset
%     
%     arr_subject_ica=cell(1,numsubj);
%     for nsubj=1:numsubj
%         arr_subject_ica{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw' '.set'];
%     end
%     
%     arr_subject_copyset=cell(1,numsubj);
%     for nsubj=1:numsubj
%         arr_subject_copyset{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw_ica' '.set'];
%     end
% 
%     for subj=1:length(arr_subject_copyset)
%         EEG=pop_loadset(fullfile(epochs_path, arr_subject_copyset{subj}));
%         EEG = pop_saveset( EEG, 'filename',arr_subject_ica{subj},'filepath',epochs_path);
%     end 
%     
% end

% if do_epochs
%     % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
%     for subj=1:length(subjects_list)
%         eeglab_subject_epoching(fullfile(epochs_path, [subjects_list{subj} pre_epochs_input '.set']), project_settings);
%     end
% end
% 

% if do_subject_epochs_ica
%     arr_subject_epochs_ica=cell(1,numsubj);
%     for nsubj=1:length(subjects_list)
%         for ncond=1:length(conditions_list)
%             arr_subject_epochs_ica{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw_ica_' conditions_list{ncond} '.set'];
%         end
%     end
% end
% 

% epoch (which stimuli and how grouped?)

% create single subject study

% export erp (and possibly ersp)

%source analysis?


% if do_epochs
%     arr_vhdr=cell(1,numsubj);
%     for nsubj=1:numsubj
%         arr_vhdr{nsubj}=[subjects_list{nsubj} '_' analysis_name '.vhdr'];
%     end
%     % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
%     for subj=1:length(arr_vhdr)
%         epoching_subject_msw(fullfile(vhdr_path, arr_vhdr{subj}), epochs_path, eeglab_channels_file, project_settings);
%     end
% end
% %==================================================================================
% if do_tf
%     cnt=1;
%     arr_epochs_sets=cell(1,numsubj*length(conditions_list));
%     for nsubj=1:numsubj
%         for cond=1:length(conditions_list)
%             arr_epochs_sets{cnt}=[subjects_list{nsubj} '_' analysis_name '_' conditions_list{cond} '.set'];
%             cnt=cnt+1;
%         end
%     end    
%     %for each epochs set file (subject and condition) calculate and save time frequency representation of all channels 
%     for nset=1:length(arr_epochs_sets)
%         tf_set([epochs_path arr_epochs_sets{nset}], tf_path, project_settings);
%     end
% end
%==================================================================================
%=====  START BRAINSTORM & select protocol or create if do not exist ==============
%==================================================================================
% strpath = path;
% if strfind(strpath, path2shadowing_functions)
%     rmpath(path2shadowing_functions); % eeglab shadows the matlab standard fminsearch function => I remove this path if present
% end
% 
% if ~brainstorm('status')
%     brainstorm nogui
% end
% if isempty(bst_get('Protocol', protocol_name)) 
%     iProtocol = brainstorm_protocol_create(protocol_name, brainstorm_db_path, default_anatomy);
% else
%     iProtocol = brainstorm_protocol_open(protocol_name);
% end
% %==================================================================================
% % import EEGLAB epochs into BRAINSTORM and do averaging
% if do_brainstorm_import_averaging
%     % for each epochs set file (subject and condition) perform: import, averaging, channelset, 
%     for nsubj=1:numsubj
%         brainstorm_subject_importepochs_averaging(protocol_name, epochs_path, subjects_list{nsubj}, analysis_name, brainstorm_channels_file, project_settings);
%     end
%     db_reload_database(iProtocol);
% end
% %==================================================================================
% % do averaging of main effects...average n-conditions epochs and create a new condition
% if do_brainstorm_averaging_main_effects
%     for nsubj=1:numsubj
%         brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'walker', project_settings, 'cwalker','twalker');
%         brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'scrambled', project_settings, 'cscrambled','tscrambled');
%         brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'centered', project_settings, 'cwalker','cscrambled');
%         brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'translating', project_settings, 'twalker','tscrambled');
%     end
% end    
% %==================================================================================
% % common noise estimation, calculated with the 4 basic conditions recordings and then copied to the other ones (main effects).
% if do_common_noise_estimation
%     for nsubj=1:numsubj
%         brainstorm_subject_noise_estimation(protocol_name, subjects_list{nsubj}, project_settings);
%     end    
% end
% %==================================================================================
% % BEM calculation over first subject (and first condition) and copy to all subjects
% if do_bem
%     brainstorm_subject_bem(protocol_name, subjects_list{1}, project_settings);
% end
% %==================================================================================
% % check if all subjects have BEM file. if not, copy it from first subject to remaining ones
% if do_check_bem
%     ProtocolSubjects = bst_get('ProtocolSubjects');
%     subj1_name=ProtocolSubjects.Subject(1).Name;
%     src_file=fullfile(brainstorm_data_path, subj1_name,'@default_study', bem_file_name);
% 
%     for nsubj=2:numsubj
%         dest_file=fullfile(brainstorm_data_path, subjects_list{nsubj},'@default_study', bem_file_name);
%         if ~filexist(dest_file)
%             system(['cp ' src_file ' ' dest_file]);
%         end
%     end
%     db_reload_database(iProtocol);
% end
% %==================================================================================
% % sources calculation over full Vertices (15000) surface
% if do_sources
%     % perform sources processing over subject/condition/data_average.mat
%     sources_results=cell(numsubj,num_contrasts);
%     
%     for nsubj=1:numsubj
%         % 4 conditions
%         for cond=1:length(conditions_list)
%             cond_input_file=fullfile(conditions_list{cond}, 'data_average.mat');
%             sources_results{nsubj,cond} = brainstorm_subject_sources(protocol_name, subjects_list{nsubj}, cond_input_file, sources_norm, project_settings, source_orient, loose_value);
%         end
%         % main effects
%         for mcond=1:length(name_maineffects)
%             totcond=mcond+length(conditions_list);
%             cond_input_file=fullfile(name_maineffects{mcond}, 'data_average.mat');
%             sources_results{nsubj,totcond} = brainstorm_subject_sources(protocol_name, subjects_list{nsubj}, cond_input_file, sources_norm, project_settings, source_orient, loose_value);
%         end        
%     end
% end
% %==================================================================================
% % spatial dimensionality reduction: downsampling to user-generated atlas composed by hundreds of scouts
% if do_spatial_reduction
%     if ~do_sources
%         % reconstruct output source relative paths.
%         src_name=['results_' sources_norm];
%         if (strcmp(source_orient, 'loose'))
%             dest_name=[src_name '_loose'];
%         end 
%         sources_results=cell(numsubj,num_contrasts);
%         for nsubj=1:numsubj
%             for cond=1:length(conditions_list)
%                 sources_results{nsubj,cond} = fullfile(subjects_list{nsubj}, conditions_list{cond}, [src_name '.mat']);
%             end
%             for mcond=1:length(name_maineffects)
%                 totcond=mcond+length(conditions_list);
%                 sources_results{nsubj,totcond} = fullfile(subjects_list{nsubj}, name_maineffects{mcond}, [src_name '.mat']);
%             end
%         end
%     end
%     
%     % call brainstorm_downsample_result
%     for nsubj=1:numsubj
%         % 4 basic conditions
%         for cond=1:length(conditions_list)
%             brainstorm_downsample_result(protocol_name, sources_results{nsubj,cond}, downsample_atlasname);
%         end
%         % main effects
%         for mcond=1:length(name_maineffects)
%             totcond=mcond+length(conditions_list);
%             brainstorm_downsample_result(protocol_name, sources_results{nsubj,totcond}, downsample_atlasname);
%         end        
%     end    
% end
% %==================================================================================
% % sources time-frequency calculation: four freq bands, temporary over-ride
% % output : [timefreq_morlet_' source_norm band_desc '_zscore.mat']
% if do_sources_tf
%     conditions_list={'cwalker','cscrambled'};
%     name_maineffects={};
%     sources_norm=[sources_norm '_s3000'];    
%         
%     if ~do_sources
%         % reconstruct output source relative paths.
%         src_name=['results_' sources_norm];
%         if (strcmp(source_orient, 'loose'))
%             dest_name=[src_name '_loose'];
%         end 
%         sources_results=cell(numsubj,num_contrasts);
%         for nsubj=1:numsubj
%             for cond=1:length(conditions_list)
%                 sources_tf_results{nsubj,cond} = fullfile(subjects_list{nsubj}, conditions_list{cond}, [src_name '.mat']);
%             end
%             for mcond=1:length(name_maineffects)
%                 totcond=mcond+length(conditions_list);
%                 sources_tf_results{nsubj,totcond} = fullfile(subjects_list{nsubj}, name_maineffects{mcond}, [src_name '.mat']);
%             end
%         end
%     end
%     
%     % call brainstorm_sources_tf
%     for nsubj=1:numsubj
%         % 4 basic conditions
%         for cond=1:length(conditions_list)
%             brainstorm_subject_sources_tf_timewnd_freqbands(protocol_name, sources_tf_results{nsubj,cond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
%         end
%         % main effects
%         for mcond=1:length(name_maineffects)
%             totcond=mcond+length(conditions_list);
%             brainstorm_subject_sources_tf_timewnd_freqbands(protocol_name, sources_tf_results{nsubj,totcond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
%         end        
%     end    
% end
% %==================================================================================
% % scouts time-frequency calculation: four freq bands, temporary over-ride
% % output: [timefreq_morlet_' source_norm band_desc '_69scouts_zscore.mat']
% if do_sources_scouts_tf
%     conditions_list={'cwalker','cscrambled'};
%     name_maineffects={};
%     % sources_norm=[sources_norm '_s500'];
% 
%     if ~do_sources
%         % reconstruct output source relative paths.
%         src_name=['results_' sources_norm];
%         if (strcmp(source_orient, 'loose'))
%             dest_name=[src_name '_loose'];
%         end 
%         sources_results=cell(numsubj,num_contrasts);
%         for nsubj=1:numsubj
%             for cond=1:length(conditions_list)
%                 sources_results{nsubj,cond} = fullfile(subjects_list{nsubj}, conditions_list{cond}, [src_name '.mat']);
%             end
%             for mcond=1:length(name_maineffects)
%                 totcond=mcond+length(conditions_list);
%                 sources_results{nsubj,totcond} = fullfile(subjects_list{nsubj}, name_maineffects{mcond}, [src_name '.mat']);
%             end
%         end
%     end
%     
%     % call brainstorm_sources_tf
%     for nsubj=1:numsubj
%         % 4 basic conditions
%         for cond=1:length(conditions_list)
%             brainstorm_subject_sources_scouts_tf_moving_scrambled_walker(protocol_name, sources_results{nsubj,cond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
%         end
%         % main effects
%         for mcond=1:length(name_maineffects)
%             totcond=mcond+length(conditions_list);
%             brainstorm_subject_sources_scouts_tf_moving_scrambled_walker(protocol_name, sources_results{nsubj,totcond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
%         end        
%     end    
% end
% %==================================================================================
% %==================================================================================
% %==================================================================================
% %==================================================================================
% % GROUP ANALYSIS
% %==================================================================================
% %==================================================================================
% %==================================================================================
% %==================================================================================
% % GROUP AVERAGING
% %==================================================================================
% if do_subjects_averaging
%     brainstorm_group_average_cond_results(protocol_name, subjects_list, {'cwalker','cscrambled'}, averaging_filename);
% end
% %==================================================================================
% %==================================================================================
% % STATS
% %==================================================================================
% %==================================================================================
% % all sources
% results=cell(1,num_contrasts);
% if do_group_analysis
%      results{1} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','cscrambled',['results_' sources_norm],1,subjects_list);
% %      results{2} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'twalker','tscrambled',['results_' sources_norm],1,subjects_list);
% %      results{3} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','twalker',['results_' sources_norm],1,subjects_list);
% %      results{4} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cscrambled','tscrambled',['results_' sources_norm],1,subjects_list);
% %      results{5} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'walker','scrambled',['results_' sources_norm],1,subjects_list);
% %      results{6} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'centered','translating',['results_' sources_norm],1,subjects_list);
% end
% %==================================================================================
% % atlas
% results_atlas=cell(1,num_contrasts);
% if do_group_analysis_atlas
%      results_atlas{1} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','cscrambled',['results_' sources_norm '_' downsample_atlasname] ,1,subjects_list);
%      results_atlas{2} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'twalker','tscrambled',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
%      results_atlas{3} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','twalker',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
%      results_atlas{4} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cscrambled','tscrambled',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
%      results_atlas{5} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'walker','scrambled',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
%      results_atlas{6} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'centered','translating',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
% end
% %==================================================================================
% % TF all sources
% results_scouts_tf=cell(1,num_contrasts);
% if do_group_analysis_tf
%     file_input='timefreq_morlet_wmne_s3000_teta_mu_beta1_beta2_zscore';
%     results_scouts_tf{1} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','cscrambled', file_input ,1,subjects_list);
% %     results_scouts_tf{2} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'twalker','tscrambled',file_input,1,subjects_list);
% %     results_scouts_tf{3} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','twalker',file_input,1,subjects_list);
% %     results_scouts_tf{4} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cscrambled','tscrambled',file_input,1,subjects_list);
% %     results_scouts_tf{5} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'walker','scrambled',file_input,1,subjects_list);
% %     results_scouts_tf{6} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'centered','translating',file_input,1,subjects_list);
% end
% %==================================================================================
% % TF 69 scouts
% results_scouts_tf=cell(1,num_contrasts);
% if do_group_analysis_scouts_tf
%     file_input='timefreq_morlet_wmne_teta_mu_beta1_beta2_69scouts_zscore';
%     results_scouts_tf{1} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','cscrambled', file_input ,1,subjects_list);
% %     results_scouts_tf{2} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'twalker','tscrambled',file_input,1,subjects_list);
% %     results_scouts_tf{3} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','twalker',file_input,1,subjects_list);
% %     results_scouts_tf{4} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cscrambled','tscrambled',file_input,1,subjects_list);
% %     results_scouts_tf{5} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'walker','scrambled',file_input,1,subjects_list);
% %     results_scouts_tf{6} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'centered','translating',file_input,1,subjects_list);
% end
% %==================================================================================
% %==================================================================================
% % PARSE RESULTS
% %==================================================================================
% %==================================================================================
% % parse sources results
% if do_process_stats_sources
%     all_group_results = bst_get('Study', -2); ... bst_get('Study', '@inter/brainstormstudy.mat');
%     num_stats=length(all_group_results.Stat);
%     for res=1:num_stats
%        filename=all_group_results.Stat(res).FileName;
%        if findstr(filename, process_result_string)
%            disp(['@@@@@@@@@@@@@@@@' filename]);
%            brainstorm_process_result(protocol_name, filename, StatThreshOptions);
%        end
%     end
% end
% %==================================================================================
% %==================================================================================
% % parse scouts TF results
% if do_process_stats_scouts_tf
%     process_result_string='130614';
%     all_group_results = bst_get('Study', -2); ... bst_get('Study', '@inter/brainstormstudy.mat');
%     num_stats=length(all_group_results.Stat);
%     for res=1:num_stats
%        filename=all_group_results.Stat(res).FileName;
%        if findstr(filename, process_result_string)
%            disp(['@@@@@@@@@@@@@@@@' filename]);
%            brainstorm_process_stats_scout_time_freq(protocol_name, filename, StatThreshOptions, [-400:4:350]);
%        end
%     end
% end
