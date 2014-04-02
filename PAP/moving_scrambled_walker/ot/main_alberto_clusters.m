% to be edited according to calling PC configuration ==============================
local_projects_data_path='/data/projects';
svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
plugins_path='/data/matlab';
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
protocol_name='moving_scrambled_walker';     ... must correspond to brainstorm db name & 'local_projects_data_path' subfolder name
subjects_list={'projection_cluster_2_allcentered', 'projection_cluster_3_allcentered', 'projection_cluster_4_allcentered', 'projection_cluster_5_allcentered' 'projection_cluster_6_allcentered', 'projection_cluster_7_allcentered', 'projection_cluster_8_allcentered', 'projection_cluster_9_allcentered', 'projection_cluster_10_allcentered', 'projection_cluster_11_allcentered');
numsubj=length(subjects_list);
analysis_name='OCICA_250';                  ... subfolder containing the current analysis type (refers to EEG device input data type)
%==================================================================================
% ======= SOURCES PARAMS ==========================================================
sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
source_orient='fixed';      % possible values are: fixed, loose
loose_value=0.2;
%depth_weighting='nodepth'; % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
downsample_atlasname='s500';
process_result_string='wmne_s500.mat';     % substring used to get and process specific results file
% ======= TF PARAMS ===================================================================
brainstorm_analysis_bands={{'teta', '4, 8', 'mean'; 'mu', '8, 13', 'mean'; 'beta1', '14, 20', 'mean'; 'beta2', '20, 32', 'mean'}};
brainstorm_analysis_times=[]; ... {{'t-4', '-0.4, -0.304', 'mean'; 't-3', '-0.3, -0.204', 'mean'; 't-2', '-0.2, -0.104', 'mean'; 't-1', '-0.1, -0.004', 'mean'; 't1', '0.0, 0.096', 'mean'; 't2', '0.1, 0.1960', 'mean'; 't3', '0.2, 0.2960', 'mean'; 't4', '0.3, 0.3960', 'mean'; 't5', '0.4, 0.4960', 'mean'; 't6', '0.5, 0.5960', 'mean'; 't7', '0.6, 0.696', 'mean'; 't8', '0.7, 0.796', 'mean'; 't9', '0.8, 0.896', 'mean'; 't10', '0.9, 0.996', 'mean'}};
zscore_overwriting=1; ... 1: calculate zscore and overwrite tf result file, 0: calculate zscore and create new tf result zscore file, -1: do not calculate zscore
% ======= MULTIPLE CORRECTION PARAMS ==============================================
StatThreshOptions.Control = 'space';
StatThreshOptions.Correction = 'fdr';
StatThreshOptions.pThreshold = 0.05;
bst_set('StatThreshOptions', StatThreshOptions);
%==================================================================================
% ======= OPERATIONS LIST =========================================================
do_epochs=0;
do_tf=0;
do_brainstorm_import_averaging=0;
do_brainstorm_averaging_main_effects=0;
do_common_noise_estimation=0; ... possible if baseline correction was calculated using all the conditions pre-stimulus
do_bem=0;
do_check_bem=0;
do_sources=0;
do_spatial_reduction=0;
do_subjects_averaging=1;     averaging_filename='timefreq_morlet_wmne_teta_mu_beta1_beta2_zscore';
do_group_analysis=0;
do_group_analysis_atlas=0;
do_process_results=0;
do_sources_tf=0;
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%======================== S T A R T ==================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%=====================================================================================================================================================================
addpath(svn_local_path);
define_paths    
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions); % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end

if do_epochs
    arr_vhdr=cell(1,numsubj);
    for nsubj=1:numsubj
        arr_vhdr{nsubj}=[subjects_list{nsubj} '_' analysis_name '.vhdr'];
    end
    % do preprocessing up to epochs: avgref, epochs, rmbase: create one trails dataset for each condition
    for subj=1:length(arr_vhdr)
        epoching_subject_msw(fullfile(vhdr_path, arr_vhdr{subj}), epochs_path, eeglab_channels_file, project_settings);
    end
end
%==================================================================================
if do_tf
    cnt=1;
    arr_epochs_sets=cell(1,numsubj*length(name_cond));
    for nsubj=1:numsubj
        for cond=1:length(name_cond)
            arr_epochs_sets{cnt}=[subjects_list{nsubj} '_' analysis_name '_' name_cond{cond} '.set'];
            cnt=cnt+1;
        end
    end    
    %for each epochs set file (subject and condition) calculate and save time frequency representation of all channels 
    for nset=1:length(arr_epochs_sets)
        tf_set([epochs_path arr_epochs_sets{nset}], tf_path, project_settings);
    end
end
%==================================================================================
%=====  START BRAINSTORM & select protocol or create if do not exist ==============
%==================================================================================
strpath = path;
if strfind(strpath, path2shadowing_functions)
    rmpath(path2shadowing_functions); % eeglab shadows the matlab standard fminsearch function => I remove this path if present
end

if ~brainstorm('status')
    brainstorm nogui
end
if isempty(bst_get('Protocol', protocol_name)) 
    iProtocol = brainstorm_protocol_create(protocol_name, brainstorm_db_path, default_anatomy);
else
    iProtocol = brainstorm_protocol_open(protocol_name);
end
%==================================================================================
% import EEGLAB epochs into BRAINSTORM and do averaging
if do_brainstorm_import_averaging
    % for each epochs set file (subject and condition) perform: import, averaging, channelset, 
    for nsubj=1:numsubj
        brainstorm_subject_importepochs_averaging(protocol_name, epochs_path, subjects_list{nsubj}, analysis_name, brainstorm_channels_file, project_settings);
    end
    rename_string=['cd ' brainstorm_data_path ';' 'for s in *; do for cond in cscrambled cwalker tscrambled twalker; do mv $s/$cond/data_average* $s/$cond/data_average.mat; done; done'];
    system(rename_string);
    db_reload_database(iProtocol);
end
%==================================================================================
% do averaging of main effects...average n-conditions epochs and create a new condition
if do_brainstorm_averaging_main_effects
    for nsubj=1:numsubj
        brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'walker', project_settings, 'cwalker','twalker');
        brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'scrambled', project_settings, 'cscrambled','tscrambled');
        brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'centered', project_settings, 'cwalker','cscrambled');
        brainstorm_subject_average_conditions(protocol_name, subjects_list{nsubj}, 'translating', project_settings, 'twalker','tscrambled');
    end
end    
%==================================================================================
% common noise estimation, calculated with the 4 basic conditions recordings and then copied to the other ones (main effects).
if do_common_noise_estimation
    for nsubj=1:numsubj
        brainstorm_subject_noise_estimation(protocol_name, subjects_list{nsubj}, project_settings);
    end    
end
%==================================================================================
% BEM calculation over first subject (and first condition) and copy to all subjects
if do_bem
    brainstorm_subject_bem(protocol_name, subjects_list{1}, project_settings);
end
%==================================================================================
% check if all subjects have BEM file. if not, copy it from first subject to remaining ones
if do_check_bem
    ProtocolSubjects = bst_get('ProtocolSubjects');
    subj1_name=ProtocolSubjects.Subject(1).Name;
    src_file=fullfile(brainstorm_data_path, subj1_name,'@default_study', bem_file_name);

    for nsubj=2:numsubj
        dest_file=fullfile(brainstorm_data_path, subjects_list{nsubj},'@default_study', bem_file_name);
        if ~filexist(dest_file)
            system(['cp ' src_file ' ' dest_file]);
        end
    end
    db_reload_database(iProtocol);
end
%==================================================================================
% sources calculation over full Vertices (15000) surface
if do_sources
    % perform sources processing over subject/condition/data_average.mat
    sources_results=cell(numsubj,num_contrasts);
    
    for nsubj=1:numsubj
        % 4 conditions
        for cond=1:length(name_cond)
            cond_input_file=fullfile(name_cond{cond}, 'data_average.mat');
            sources_results{nsubj,cond} = brainstorm_subject_sources(protocol_name, subjects_list{nsubj}, cond_input_file, sources_norm, project_settings, source_orient, loose_value);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            cond_input_file=fullfile(name_maineffects{mcond}, 'data_average.mat');
            sources_results{nsubj,totcond} = brainstorm_subject_sources(protocol_name, subjects_list{nsubj}, cond_input_file, sources_norm, project_settings, source_orient, loose_value);
        end        
    end
end
%==================================================================================
% spatial dimensionality reduction: downsampling to user-generated atlas composed by hundreds of scouts
if do_spatial_reduction
    if ~do_sources
        % reconstruct output source relative paths.
        src_name=['results_' sources_norm];
        if (strcmp(source_orient, 'loose'))
            dest_name=[src_name '_loose'];
        end 
        sources_results=cell(numsubj,num_contrasts);
        for nsubj=1:numsubj
            for cond=1:length(name_cond)
                sources_results{nsubj,cond} = fullfile(subjects_list{nsubj}, name_cond{cond}, [src_name '.mat']);
            end
            for mcond=1:length(name_maineffects)
                totcond=mcond+length(name_cond);
                sources_results{nsubj,totcond} = fullfile(subjects_list{nsubj}, name_maineffects{mcond}, [src_name '.mat']);
            end
        end
    end
    
    % call brainstorm_downsample_result
    for nsubj=1:numsubj
        % 4 basic conditions
        for cond=1:length(name_cond)
            brainstorm_downsample_result(protocol_name, sources_results{nsubj,cond}, downsample_atlasname);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            brainstorm_downsample_result(protocol_name, sources_results{nsubj,totcond}, downsample_atlasname);
        end        
    end    
end
%==================================================================================
% sources time-frequency calculation: 100ms time windows & four freq bands
% temporary over-ride
name_cond={'cwalker','cscrambled'};
name_maineffects={};
sources_norm=[sources_norm '_s500'];

if do_sources_tf
    if ~do_sources
        % reconstruct output source relative paths.
        src_name=['results_' sources_norm];
        if (strcmp(source_orient, 'loose'))
            dest_name=[src_name '_loose'];
        end 
        sources_results=cell(numsubj,num_contrasts);
        for nsubj=1:numsubj
            for cond=1:length(name_cond)
                sources_results{nsubj,cond} = fullfile(subjects_list{nsubj}, name_cond{cond}, [src_name '.mat']);
            end
            for mcond=1:length(name_maineffects)
                totcond=mcond+length(name_cond);
                sources_results{nsubj,totcond} = fullfile(subjects_list{nsubj}, name_maineffects{mcond}, [src_name '.mat']);
            end
        end
    end
    
    % call brainstorm_sources_tf
    for nsubj=1:numsubj
        % 4 basic conditions
        for cond=1:length(name_cond)
            brainstorm_subject_sources_tf_timewnd_freqbands(protocol_name, sources_results{nsubj,cond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            brainstorm_subject_sources_tf_timewnd_freqbands(protocol_name, sources_results{nsubj,totcond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
        end        
    end    
end
%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
% group analysis
%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
% GROUP AVERAGING
%==================================================================================
if do_subjects_averaging
    brainstorm_group_average_cond_results(protocol_name, subjects_list, {'cwalker','cscrambled'}, averaging_filename);
end
%==================================================================================
% STATS
%==================================================================================
% all sources
results=cell(1,num_contrasts);
if do_group_analysis
     results{1} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','cscrambled',sources_norm,1,subjects_list);
%      results{2} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'twalker','tscrambled',sources_norm,1,subjects_list);
%      results{3} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','twalker',sources_norm,1,subjects_list);
%      results{4} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cscrambled','tscrambled',sources_norm,1,subjects_list);
%      results{5} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'walker','scrambled',sources_norm,1,subjects_list);
%      results{6} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'centered','translating',sources_norm,1,subjects_list);
end
%==================================================================================
% atlas
results_atlas=cell(1,num_contrasts);
if do_group_analysis_atlas
     results_atlas{1} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','cscrambled',[sources_norm '_' downsample_atlasname] ,1,subjects_list);
     results_atlas{2} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'twalker','tscrambled',[sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{3} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cwalker','twalker',[sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{4} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'cscrambled','tscrambled',[sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{5} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'walker','scrambled',[sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{6} = brainstorm_group_stats_2cond_pairedttest(protocol_name, 'centered','translating',[sources_norm '_' downsample_atlasname],1,subjects_list);
end
%==================================================================================
% TF all sources

%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
% parse results
if do_process_results
    all_group_results = bst_get('Study', -2); ... bst_get('Study', '@inter/brainstormstudy.mat');
    num_stats=length(all_group_results.Stat);
    for res=1:num_stats
       filename=all_group_results.Stat(res).FileName;
       if findstr(filename, process_result_string)
           disp(['@@@@@@@@@@@@@@@@' filename]);
           brainstorm_process_result(protocol_name, filename, StatThreshOptions);
       end
    end
end
