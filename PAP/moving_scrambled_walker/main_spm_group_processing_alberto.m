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
local_projects_data_path='/media/data/EEG';
eegtools_svn_local_path='/media/data/EEG/EEG_Tools';
plugins_path='/mnt/behaviour_lab/Projects/EEG_tools/matlab_toolbox';

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
%subjects_list={'alessandra_finisguerra'};   ... for debugging
% subjects_list={'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'}; ... for debugging
numsubj=length(subjects_list);
stat_correction = 'fdr';
stat_threshold = 0.05;
%==================================================================================
% OPERATIONS LIST
%==================================================================================
do_model=0;
do_pairwise_stats=1;
%=====================================================================================================================================================================
%=====================================================================================================================================================================
%  S T A R T 
%=====================================================================================================================================================================
%=====================================================================================================================================================================strpath = path;
if ~strfind(strpath, path2shadowing_functions)
    addpath(path2shadowing_functions);      % eeglab shadows the fminsearch function => I add its path in case I previously removed it
end

if do_model
    postfix_name='results_wmne_N200.nii';
    spm_glmflex_create_2x2_within(project_settings, subjects_list, spmsources_path, postfix_name, spmstats_path) 
end


if do_pairwise_stats
    
    for tw=1:length(time_windows_names_short{1})
        postfix_name=['results_' sources_norm '_' time_windows_names_short{1}{tw} '.nii'];      ... conditions_list={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};
        
        
        spm_stats_job_create_2ttest(project_settings, subjects_list, 1, 'cwalker','cscrambled', spmsources_path, postfix_name, fullfile(global_spm_templates_path, 'stats_2ttest_job.m'), fullfile(global_spm_templates_path,'start_template.m'), batches_path); 
    end
end