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
%=====================================================================================================================================================================

% to be edited according to calling PC local file system
os = system_dependent('getos');
if  strncmp(os,'Linux',2)
    local_projects_data_path='/data/projects';
    eegtools_svn_local_path='/data/behavior_lab_svn/behaviourPlatform/EEG_Tools';
    plugins_path='/data/matlab_toolbox';
else
    local_projects_data_path='G:\';
    eegtools_svn_local_path='G:\behaviourPlatform_svn\EEG_Tools';
    plugins_path='G:\groups\behaviour_lab\Projects\EEG_tools\matlab_toolbox';
end

%=====================================================================================================================================================================
% PROJECT DATA 
%=====================================================================================================================================================================
project_folder='moving_scrambled_walker';      ... must correspond to 'local_projects_data_path' subfolder name
conf_file_name='project_config_alberto_cleanica.m';
project_settings=fullfile(eegtools_svn_local_path, project_folder, conf_file_name);
%=====================================================================================================================================================================
% load: 1) project configuration file, 2) global & project paths
%=====================================================================================================================================================================
[path,name_noext,ext] = fileparts(project_settings);
addpath(path);    eval(name_noext);

global_scripts_path=fullfile(eegtools_svn_local_path, 'global_scripts');
addpath(global_scripts_path);
define_paths    
%=====================================================================================================================================================================
%  OVERRIDE
%=====================================================================================================================================================================
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
...subjects_list={'alessandra_finisguerra'};   ... for debugging
...subjects_list={'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'}; ... for debugging
numsubj=length(subjects_list);
stat_correction = 'fdr';
stat_threshold = 0.05;
%==================================================================================
% ======= SOURCES PARAMS ==========================================================
sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
source_orient='fixed';      % possible values are: fixed, loose
%depth_weighting='nodepth'; % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
downsample_atlasname='s500';

% ======= TF PARAMS ===================================================================
brainstorm_analysis_times=[]; ... {{'t-4', '-0.4, -0.304', 'mean'; 't-3', '-0.3, -0.204', 'mean'; 't-2', '-0.2, -0.104', 'mean'; 't-1', '-0.1, -0.004', 'mean'; 't1', '0.0, 0.096', 'mean'; 't2', '0.1, 0.1960', 'mean'; 't3', '0.2, 0.2960', 'mean'; 't4', '0.3, 0.3960', 'mean'; 't5', '0.4, 0.4960', 'mean'; 't6', '0.5, 0.5960', 'mean'; 't7', '0.6, 0.696', 'mean'; 't8', '0.7, 0.796', 'mean'; 't9', '0.8, 0.896', 'mean'; 't10', '0.9, 0.996', 'mean'}};
zscore_overwriting=1; ... 1: calculate zscore and overwrite tf result file, 0: calculate zscore and create new tf result zscore file, -1: do not calculate zscore
% ======= MULTIPLE CORRECTION PARAMS ==============================================
StatThreshOptions.Control = 'space';
StatThreshOptions.Correction = stat_correction;
StatThreshOptions.pThreshold = stat_threshold;
bst_set('StatThreshOptions', StatThreshOptions);
%==================================================================================
% OPERATIONS LIST
%==================================================================================
do_brainstorm_import_averaging=0;
do_brainstorm_averaging_main_effects=0;
do_common_noise_estimation=0;   ... possible if baseline correction was calculated using all the conditions pre-stimulus
do_bem=0;
do_check_bem=0;
do_sources=0;
do_sources_tf=0;
do_sources_scouts_tf=0;
do_sources_export2spm8=1;
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
%  S T A R T 
%=====================================================================================================================================================================
%=====================================================================================================================================================================
strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end
%==================================================================================
% START BRAINSTORM & select protocol or create if it does not exist
%==================================================================================
strpath = path;
if strfind(strpath, path2shadowing_functions)
    rmpath(path2shadowing_functions); % eeglab shadows the matlab standard fminsearch function => I remove this path if present
end

if ~brainstorm('status')
    brainstorm nogui
end
if isempty(bst_get('Protocol', db_folder_name)) 
    iProtocol = brainstorm_protocol_create(db_folder_name, brainstorm_db_path, default_anatomy_dir);
else
    iProtocol = brainstorm_protocol_open(db_folder_name);
end
%==================================================================================
% import EEGLAB epochs into BRAINSTORM and do averaging
if do_brainstorm_import_averaging
    % for each epochs set file (subject and condition) perform: import, averaging, channelset, 
    for nsubj=1:numsubj
        brainstorm_subject_importepochs_averaging(project_settings, db_folder_name, epochs_path, subjects_list{nsubj}, analysis_name, brainstorm_channels_path);
    end
    db_reload_database(iProtocol);
end
%==================================================================================
% do averaging of main effects...average n-conditions epochs and create a new condition
if do_brainstorm_averaging_main_effects
    for nsubj=1:numsubj
        brainstorm_subject_average_conditions(project_settings, db_folder_name, subjects_list{nsubj}, 'walker', 'cwalker','twalker');
        brainstorm_subject_average_conditions(project_settings, db_folder_name, subjects_list{nsubj}, 'scrambled', 'cscrambled','tscrambled');
        brainstorm_subject_average_conditions(project_settings, db_folder_name, subjects_list{nsubj}, 'centered', 'cwalker','cscrambled');
        brainstorm_subject_average_conditions(project_settings, db_folder_name, subjects_list{nsubj}, 'translating', 'twalker','tscrambled');
    end
end    
%==================================================================================
% common noise estimation, calculated with the 4 basic conditions recordings and then copied to the other ones (main effects).
if do_common_noise_estimation
    for nsubj=1:numsubj
        brainstorm_subject_noise_estimation(project_settings, db_folder_name, subjects_list{nsubj});
    end    
end
%==================================================================================
% BEM calculation over first subject (and first condition) and copy to all subjects
if do_bem
    brainstorm_subject_bem(project_settings, db_folder_name, subjects_list{1},'model_type', 2);
end
%==================================================================================
% check if all subjects have BEM file. if not, copy it from first subject to remaining ones
if do_check_bem
    ProtocolSubjects = bst_get('ProtocolSubjects');
    subj1_name=ProtocolSubjects.Subject(1).Name;
    src_file=fullfile(brainstorm_data_path, subj1_name,'@default_study', bem_file_name);

    for nsubj=2:numsubj
        dest_file=fullfile(brainstorm_data_path, subjects_list{nsubj},'@default_study', bem_file_name);
        if ~file_exist(dest_file)
            copyfile(src_file, dest_file);
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
            sources_results{nsubj,cond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'wmne', 'orient', 'free', 'tag', 'vol', 'headmodelfile', vol_bem_file_name);
            sources_results{nsubj,cond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'wmne', 'orient', 'fixed', 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
            sources_results{nsubj,cond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'wmne', 'loose_value', 0.2, 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
            sources_results{nsubj,cond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'sloreta', 'orient', 'free', 'tag', 'vol', 'headmodelfile', vol_bem_file_name);
            sources_results{nsubj,cond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'sloreta', 'orient', 'fixed', 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
            sources_results{nsubj,cond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'sloreta', 'loose_value', 0.2, 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            cond_input_file=fullfile(name_maineffects{mcond}, 'data_average.mat');
            sources_results{nsubj,totcond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'wmne', 'orient', 'free', 'tag', 'vol', 'headmodelfile', vol_bem_file_name);
            sources_results{nsubj,totcond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'wmne', 'orient', 'fixed', 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
            sources_results{nsubj,totcond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'wmne', 'loose_value', 0.2, 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
            sources_results{nsubj,totcond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'sloreta', 'orient', 'free', 'tag', 'vol', 'headmodelfile', vol_bem_file_name);
            sources_results{nsubj,totcond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'sloreta', 'orient', 'fixed', 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
            sources_results{nsubj,totcond} = brainstorm_subject_sources(project_settings, db_folder_name, subjects_list{nsubj}, cond_input_file, 'norm', 'sloreta', 'loose_value', 0.2, 'tag', 'surf', 'headmodelfile', surf_bem_file_name);
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
            brainstorm_downsample_result(db_folder_name, sources_results{nsubj,cond}, downsample_atlasname);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            brainstorm_downsample_result(db_folder_name, sources_results{nsubj,totcond}, downsample_atlasname);
        end        
    end    
end
%==================================================================================
% sources time-frequency calculation: four freq bands, temporary over-ride
% output : [timefreq_morlet_' source_norm band_desc '_zscore.mat']
if do_sources_tf
    name_cond={'cwalker','cscrambled'};
    name_maineffects={};
    sources_norm=[sources_norm '_s3000'];    
        
    if ~do_sources
        % reconstruct output source relative paths.
        src_name=['results_' sources_norm];
        if (strcmp(source_orient, 'loose'))
            dest_name=[src_name '_loose'];
        end 
        sources_results=cell(numsubj,num_contrasts);
        for nsubj=1:numsubj
            for cond=1:length(name_cond)
                sources_tf_results{nsubj,cond} = fullfile(subjects_list{nsubj}, name_cond{cond}, [src_name '.mat']);
            end
            for mcond=1:length(name_maineffects)
                totcond=mcond+length(name_cond);
                sources_tf_results{nsubj,totcond} = fullfile(subjects_list{nsubj}, name_maineffects{mcond}, [src_name '.mat']);
            end
        end
    end
    
    % call brainstorm_sources_tf
    for nsubj=1:numsubj
        % 4 basic conditions
        for cond=1:length(name_cond)
            brainstorm_subject_sources_tf_timewnd_freqbands(db_folder_name, sources_tf_results{nsubj,cond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            brainstorm_subject_sources_tf_timewnd_freqbands(db_folder_name, sources_tf_results{nsubj,totcond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
        end        
    end    
end
%==================================================================================
% scouts time-frequency calculation: four freq bands, temporary over-ride
% output: [timefreq_morlet_' source_norm band_desc '_69scouts_zscore.mat']
if do_sources_scouts_tf
    name_cond={'cwalker','cscrambled'};
    name_maineffects={};
    % sources_norm=[sources_norm '_s500'];

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
            brainstorm_subject_sources_scouts_tf_moving_scrambled_walker(db_folder_name, sources_results{nsubj,cond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
        end
        % main effects
        for mcond=1:length(name_maineffects)
            totcond=mcond+length(name_cond);
            brainstorm_subject_sources_scouts_tf_moving_scrambled_walker(db_folder_name, sources_results{nsubj,totcond},brainstorm_analysis_times, brainstorm_analysis_bands, zscore_overwriting, project_settings);
        end        
    end    
end
%==================================================================================
if do_sources_export2spm8
    % export sources results over subject/condition

    tag_list={'wmne | fixed | surf', 'wmne | free | vol', 'wmne | loose | 0.2 | surf', 'sloreta | fixed | surf', 'sloreta | free | vol', 'sloreta | loose | 0.2 | surf'};
    %name_cond={'cwalker'};subjects_list={'alessandra_finisguerra'};time_windows_names_short={{'N200'}};time_windows_sec={{[0.200 0.230]}};time_windows_list={{[200 230]}};
    
    spmsources_path=fullfile(spmsources_path, '2mm', analysis_name);
    
    for t=1:length(tag_list)
        tag=tag_list{t};
        file_tag=strrep(tag, ' | ', '_');
        file_tag=strrep(file_tag, '.', '')
        
        input_file='data_average.mat';
        for cond=1:length(name_cond)
           cond_files=brainstorm_results_get_from_subjectslist_by_tag('', subjects_list, name_cond{cond}, input_file, tag);
           for s=1:length(cond_files)
                for tw=1:length(brainstorm_time_windows{1})
                     output_tag=[subjects_list{s} '_' analysis_name '_' name_cond{cond} '_' file_tag '_' brainstorm_time_windows_names{1}{tw}];
                     brainstorm_subject_sources_export2spm_volume(project_settings, db_folder_name, cond_files{s}, spmsources_path, brainstorm_time_windows{1}{tw},  output_tag, 'voldownsample', 2); ... 'alessandra_finisguerra_centered_N200')
                end
           end
        end

        for mcond=1:length(name_maineffects)
            cond_files=brainstorm_results_get_from_subjectslist_by_tag('', subjects_list, name_maineffects{mcond}, input_file, tag);
            for s=1:length(subjects_list)
                for tw=1:length(brainstorm_time_windows{1})
                    output_tag=[subjects_list{s} '_' analysis_name '_' name_maineffects{mcond} '_' file_tag '_' brainstorm_time_windows_names{1}{tw}];
                    brainstorm_subject_sources_export2spm_volume(project_settings, db_folder_name, cond_files{s}, spmsources_path, brainstorm_time_windows{1}{tw},  output_tag, 'voldownsample', 2); ... 'alessandra_finisguerra_centered_N200')
                end
            end
        end
    end
end
%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
% GROUP ANALYSIS
%==================================================================================
%==================================================================================
%==================================================================================
%==================================================================================
% GROUP AVERAGING
%==================================================================================
if do_subjects_averaging
    brainstorm_group_average_cond_results(db_folder_name, subjects_list, {'cwalker','cscrambled'}, averaging_filename);
end
%==================================================================================
%==================================================================================
% STATS
%==================================================================================
%==================================================================================
% all sources
results=cell(1,num_contrasts);
if do_group_analysis
     results{1} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','cscrambled',['results_' sources_norm],1,subjects_list);
%      results{2} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'twalker','tscrambled',['results_' sources_norm],1,subjects_list);
%      results{3} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','twalker',['results_' sources_norm],1,subjects_list);
%      results{4} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cscrambled','tscrambled',['results_' sources_norm],1,subjects_list);
%      results{5} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'walker','scrambled',['results_' sources_norm],1,subjects_list);
%      results{6} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'centered','translating',['results_' sources_norm],1,subjects_list);
end
%==================================================================================
% atlas
results_atlas=cell(1,num_contrasts);
if do_group_analysis_atlas
     results_atlas{1} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','cscrambled',['results_' sources_norm '_' downsample_atlasname] ,1,subjects_list);
     results_atlas{2} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'twalker','tscrambled',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{3} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','twalker',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{4} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cscrambled','tscrambled',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{5} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'walker','scrambled',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
     results_atlas{6} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'centered','translating',['results_' sources_norm '_' downsample_atlasname],1,subjects_list);
end
%==================================================================================
% TF all sources
results_scouts_tf=cell(1,num_contrasts);
if do_group_analysis_tf
    file_input='timefreq_morlet_wmne_s3000_teta_mu_beta1_beta2_zscore';
    results_scouts_tf{1} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','cscrambled', file_input ,1,subjects_list);
%     results_scouts_tf{2} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'twalker','tscrambled',file_input,1,subjects_list);
%     results_scouts_tf{3} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','twalker',file_input,1,subjects_list);
%     results_scouts_tf{4} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cscrambled','tscrambled',file_input,1,subjects_list);
%     results_scouts_tf{5} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'walker','scrambled',file_input,1,subjects_list);
%     results_scouts_tf{6} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'centered','translating',file_input,1,subjects_list);
end
%==================================================================================
% TF 69 scouts
results_scouts_tf=cell(1,num_contrasts);
if do_group_analysis_scouts_tf
    file_input='timefreq_morlet_wmne_teta_mu_beta1_beta2_69scouts_zscore';
    results_scouts_tf{1} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','cscrambled', file_input ,1,subjects_list);
%     results_scouts_tf{2} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'twalker','tscrambled',file_input,1,subjects_list);
%     results_scouts_tf{3} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cwalker','twalker',file_input,1,subjects_list);
%     results_scouts_tf{4} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'cscrambled','tscrambled',file_input,1,subjects_list);
%     results_scouts_tf{5} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'walker','scrambled',file_input,1,subjects_list);
%     results_scouts_tf{6} = brainstorm_group_stats_2cond_pairedttest(db_folder_name, 'centered','translating',file_input,1,subjects_list);
end
%==================================================================================
%==================================================================================
% PARSE RESULTS
%==================================================================================
%==================================================================================
% parse sources results
if do_process_stats_sources
    all_group_results = bst_get('Study', -2); ... bst_get('Study', '@inter/brainstormstudy.mat');
    num_stats=length(all_group_results.Stat);
    for res=1:num_stats
       filename=all_group_results.Stat(res).FileName;
       if findstr(filename, process_result_string)
           disp(['@@@@@@@@@@@@@@@@' filename]);
           brainstorm_process_result(db_folder_name, filename, StatThreshOptions);
       end
    end
end
%==================================================================================
%==================================================================================
% parse scouts TF results
if do_process_stats_scouts_tf
    process_result_string='130614';
    all_group_results = bst_get('Study', -2); ... bst_get('Study', '@inter/brainstormstudy.mat');
    num_stats=length(all_group_results.Stat);
    for res=1:num_stats
       filename=all_group_results.Stat(res).FileName;
       if findstr(filename, process_result_string)
           disp(['@@@@@@@@@@@@@@@@' filename]);
           brainstorm_process_stats_scout_time_freq(db_folder_name, filename, StatThreshOptions, [-400:4:350]);
       end
    end
end
