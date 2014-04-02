%  project
%           file system links
%           task
%           import    
%           eegdata
%           preproc
%           epoching
%           groups
%           design
%           stats
%           postprocess
%           results_display
%           export
%           brainstorm

% ======================================================================================================
% PATHS
% ======================================================================================================
project_folder='moving_scrambled_walker';         ... must correspond to 'local_projects_data_path' subfolder name
analysis_name='OCICA_250';                        ... subfolder containing the current analysis type (refers to EEG device input data type)


% ======================================================================================================
% TASK
% ======================================================================================================


% ======================================================================================================
% IMPORT
% ======================================================================================================
project.import.interpolate_channels=[];
project.import.reference_channels=[];
%project.import.polygraphic_channels={{65,66,'DVEOG'};{67,68,'DFDR'};{69,70,'NDFDR'};{71,72,'DTA'}};
%project.import.final_muscles_channels=[66 67 68];
%project.import.final_muscles_channels_label={'DFDR' 'NDFDR' 'DTA'};
%project.import.emg_output_postfix_name = '_observation_emg';
project.import.acquisition_system='BRAINVISION';
project.import.import_marker={'S193' 'S194' 'S230' 'S235' 'S236' 'S240' 'S245' 'S246' 'S185' 'S186' 'S205' 'S235' 'S245' 'S206' 'S236' 'S246' 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 18' 'S 19' 'S 20' 'S201' 'S205' 'S240' 'S245' 'S206' 'S230' 'S235' 'S236', 'S246'};    % all markers imported 

% ======================================================================================================
% EEGDATA
% ======================================================================================================
project.eegdata.nch=64;         % channels_number
project.eegdata.fs=250;         % sampling frequency in Hz
project.eegdata.eeglab_channels_file_name='standard-10-5-cap385.elp';       % channels file name
project.eegdata.brainstorm_channels_file_name='brainstorm_channel.pos';

% ======================================================================================================
% PREPROCESSING
% ======================================================================================================
% GLOBAL FILTER
project.preproc.ff1_global=0.16;        % lower frequency in Hz
project.preproc.ff2_global=100;         % higher frequency

%FURTHER EEG FILTER
project.preproc.ff1_eeg=0.16;           % lower frequency
project.preproc.ff2_eeg=45;             % higher frequency

%FURTHER EOG FILTER
project.preproc.ff1_eog=0.16;           % lower frequency
project.preproc.ff2_eog=8;              % higher frequency

%FURTHER EMG FILTER
project.preproc.ff1_emg=5;              % lower frequency
project.preproc.ff2_emg=100;            % higher frequency
project.preproc.cheog1=nch_eeg+1;       % first EOG-related channel
project.preproc.cheog2=nch_eeg+2;       % second EOG-related channel

% ======================================================================================================
% EPOCHING
% ======================================================================================================

% secs
project.epoching.epo_st.s=-0.4;             % epochs start latency
project.epoching.epo_end.s=3;             % epochs end latency
project.epoching.bc_st.s=-0.2;            % baseline correction start latency
project.epoching.bc_end.s=-0.012;         % baseline correction end latency

% ms
%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.epoching.bc_st.ms=project.epoching.bc_st.s/1000;            % baseline correction start latency
project.epoching.bc_end.ms=project.epoching.bc_end.s/1000;           % baseline correction end latency
project.epoching.epo_st.ms=project.epoching.epo_st.s/1000;             % epochs start latency
project.epoching.epo_end.ms=project.epoching.epo_end.s/1000;             % epochs end latency
%  ********* /DERIVED DATA *****************************************************************

% point
project.epoching.bc_emg_st_point=round((project.epoching.bc_st.s-project.epoching.epo_st.s)/(1000/project.eegdata.fs));
project.epoching.bc_emg_end_point=round((project.epoching.epo_end-project.epoching.epo_st.s)/(1000/project.eegdata.fs));

% markers
project.epoching.mrkcode_cond={'S  1' 'S  2' 'S  3' 'S  4'};
project.epoching.valid_marker={'S193' 'S194' 'S230' 'S235' 'S236' 'S240' 'S245' 'S246' 'S185' 'S186' 'S205' 'S235' 'S245' 'S206' 'S236' 'S246' 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 18' 'S 19' 'S 20' 'S201' 'S205' 'S240' 'S245' 'S206' 'S230' 'S235' 'S236', 'S246'};     % conditions: marker codes & name

% ======================================================================================================
% DESIGN
% ======================================================================================================
project.design.group_names={'control'};
project.design.between_design_list={{'CC'}};
                
project.design.between_numdes=length(between_design_list);
project.design.between_design_names={'CC'};

project.design.condition_names={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};
project.design.numcond=length(project.design.condition_names);

project.design.within_design_list={ ...
               {{'cwalker' 'twalker' 'cscrambled' 'tscrambled'}};...all
              {{{'tscrambled' 'twalker'} {'cscrambled' 'cwalker'}}};... motion
              {{{'cscrambled' 'tscrambled'} {'cwalker' 'twalker'}}};... shape
              {{'tscrambled' 'twalker'}};...  
              {{'cscrambled' 'cwalker'}};...              
              {{'cwalker' 'twalker'}};...
              {{'cscrambled' 'tscrambled'}}...
};
project.design.within_numdes=length(project.design.within_design_list);

project.design.within_design_names={'all','motion','shape','shape_within_translating','shape_within_centered','motion_within_walker','motion_within_scrambled'};
project.design.paired_list={ ...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'}...
};

project.design.name_cond=project.design.condition_names;  ... backcompatibility
    
project.design.name_maineffects={'centered', 'translating', 'scrambled', 'walker'};
project.design.num_contrasts=6;

% ======================================================================================================
% GROUPS
% ======================================================================================================

project.subjects.groups={{'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'} ...
            };

project.subjects.list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
project.subjects.numsubj=length(project.subjects.list);

% ======================================================================================================
% STATS
% ======================================================================================================

% ERP
project.stats.erp.pvalue=0.025; ...0.01;                % level of significance applied in ERP statistical analysis
project.stats.erp.num_permutations=5000;                % number of permutations applied in ERP statistical analysis
project.stats.eeglab.erp.method='bootstrap';            % method applied in ERP statistical analysis
project.stats.eeglab.erp.correction='bonferroni';              % multiple comparison correction applied in ERP statistical analysis

% ERSP
project.stats.ersp.pvalue=0.025; ...0.01;               % level of significance applied in ERSP statistical analysis
project.stats.ersp.num_permutations=5000;               % number of permutations applied in ERP statistical analysis
project.stats.eeglab.ersp.method='bootstrap';           % method applied in ERP statistical analysis
project.stats.eeglab.ersp.correction='bonferroni';             % multiple comparison correction applied in ERP statistical analysis

% BRAINSTORM
project.stats.brainstorm.pvalue=0.025; ...0.01;         % level of significance applied in ERSP statistical analysis
project.stats.brainstorm.correction='fdr';              % multiple comparison correction applied in ERP statistical analysis

% SPM
project.stats.spm.pvalue=0.05; ...0.01;                % level of significance applied in ERSP statistical analysis
project.stats.spm.correction='fwe';             % multiple comparison correction applied in ERP statistical analysis

% for each design of interest, perform or not statistical analysis of erp
project.stats.show_statistics_list={'on','on','on','on','on','on','on','on'};   

% ======================================================================================================
% POSTPROCESS
% ======================================================================================================

project.postprocess.erp.design(1).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(1).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(1).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(1).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(1).time_windows(5)=struct('name','N600','min',550, 'max',800);

project.postprocess.erp.design(2).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(2).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(2).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(2).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(2).time_windows(5)=struct('name','N600','min',550, 'max',800);

project.postprocess.erp.design(3).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(3).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(3).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(3).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(3).time_windows(5)=struct('name','N600','min',550, 'max',800);

project.postprocess.erp.design(4).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(4).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(4).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(4).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(4).time_windows(5)=struct('name','N600','min',550, 'max',800);

project.postprocess.erp.design(5).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(5).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(5).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(5).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(5).time_windows(5)=struct('name','N600','min',550, 'max',800);

project.postprocess.erp.design(6).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(6).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(6).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(6).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(6).time_windows(5)=struct('name','N600','min',550, 'max',800);

project.postprocess.erp.design(7).time_windows(1)=struct('name','N200','min',200, 'max',230);
project.postprocess.erp.design(7).time_windows(2)=struct('name','P330','min',300, 'max',360);
project.postprocess.erp.design(7).time_windows(3)=struct('name','N400','min',390, 'max',450);
project.postprocess.erp.design(7).time_windows(4)=struct('name','P500','min',450, 'max',550);
project.postprocess.erp.design(7).time_windows(5)=struct('name','N600','min',550, 'max',800);


project.postprocess.ersp.frequency_bands(1)=struct('name','teta','min',4,'max',8);
project.postprocess.ersp.frequency_bands(2)=struct('name','mu','min',8,'max',12);
project.postprocess.ersp.frequency_bands(3)=struct('name','beta1','min',14, 'max',20);
project.postprocess.ersp.frequency_bands(4)=struct('name','beta2','min',20, 'max',32);

project.postprocess.roi_list={ ...
                                {'F5','F7','AF7','FT7','F6','F8','AF8','FT8'};                          ... IFG       
                                {'FC3','FC5','FC4','FC6'};                                              ... PMD
                                {'CP3','CP5','P5','P3','CP4','CP6','P6','P4'};                          ... IPL
                                {'CP3','P3','CP1','P1','CP4','P4','CP2','P2'};                          ... SPL          
                                {'T7','TP7','CP5','P5','T8','TP8','CP6','P6'};                          ... pSTS           
                                {'P7','PO7','P5','TP7','P8','PO8','P6','TP8'};                          ... EBA_MT          
                                {'O1','PO3','Oz','POz','O2','PO4'};                                     ... occipital                               
};
project.postprocess.numroi=length(roi_list);
project.postprocess.roi_names={'ifg','pmd','ipl','spl','psts','eba-mt','occipital'};


%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.eeglab.frequency_bands_list={ ...
    [project.postprocess.ersp.frequency_bands(1).min,project.postprocess.ersp.frequency_bands(1).max]; ... 
    [project.postprocess.ersp.frequency_bands(2).min,project.postprocess.ersp.frequency_bands(2).max]; ...
    [project.postprocess.ersp.frequency_bands(3).min,project.postprocess.ersp.frequency_bands(3).max]; ...
    [project.postprocess.ersp.frequency_bands(4).min,project.postprocess.ersp.frequency_bands(4).max]; ...
    };
project.postprocess.eeglab.frequency_bands_names={project.postprocess.ersp.frequency_bands(1).name,project.postprocess.ersp.frequency_bands(2).name,project.postprocess.ersp.frequency_bands(3).name,project.postprocess.ersp.frequency_bands(4).name};
%  ********* /DERIVED DATA  *****************************************************************


% ERP
project.postprocess.erp.tmin_analysis.s=project.epoching.epo_st.s;
project.postprocess.erp.tmax_analysis.s=project.epoching.epo_end.s;
project.postprocess.erp.ts_analysis.s=0.008;
project.postprocess.erp.timeout_analysis_interval.s=[project.postprocess.erp.tmin_analysis.s:project.postprocess.erp.ts_analysis.s:project.postprocess.erp.tmax_analysis.s];


%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.erp.tmin_analysis.ms=project.postprocess.erp.tmin_analysis.s/1000;
project.postprocess.erp.tmax_analysis.ms=project.postprocess.erp.tmax_analysis.s/1000;
project.postprocess.erp.ts_analysis.ms=project.postprocess.erp.ts_analysis.s/1000;
project.postprocess.erp.timeout_analysis_interval.ms=project.postprocess.erp.timeout_analysis_interval.s/1000;
%  ********* /DERIVED DATA  *****************************************************************


% ERSP
project.postprocess.ersp.tmin_analysis.s=project.epoching.epo_st.s;
project.postprocess.ersp.tmax_analysis.s=project.epoching.epo_end.s;
project.postprocess.ersp.ts_analysis.s=0.008;
project.postprocess.ersp.timeout_analysis_interval.s=[project.postprocess.ersp.tmin_analysis.s:project.postprocess.ersp.ts_analysis.s:project.postprocess.ersp.tmax_analysis.s];


%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.ersp.tmin_analysis.ms=project.postprocess.ersp.tmin_analysis.s/1000;
project.postprocess.ersp.tmax_analysis.ms=project.postprocess.ersp.tmax_analysis.s/1000;
project.postprocess.ersp.ts_analysis.ms=project.postprocess.ersp.ts_analysis.s/1000;
project.postprocess.ersp.timeout_analysis_interval.ms=project.postprocess.ersp.timeout_analysis_interval.ms/1000;
%  ********* /DERIVED DATA  *****************************************************************


project.postprocess.ersp.fmin_analysis=4;
project.postprocess.ersp.fmax_analysis=32;
project.postprocess.ersp.fs_analysis=0.5;
project.postprocess.ersp.padratio=16;

project.postprocess.ersp.timeout_analysis_interval.ms=[project.postprocess.ersp.tmin_analysis:project.postprocess.ersp.ts_analysis:project.postprocess.ersp.tmax_analysis];
project.postprocess.ersp.freqout_analysis_interval.ms=[project.postprocess.ersp.fmin_analysis:project.postprocess.ersp.fs_analysis:project.postprocess.ersp.fmax_analysis];


%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.postprocess.ersp.timeout_analysis_interval.s=project.postprocess.ersp.timeout_analysis_interval.ms*1000;
project.postprocess.ersp.freqout_analysis_interval.s=project.postprocess.ersp.freqout_analysis_interval.ms*1000;
%  ********* /DERIVED DATA  *****************************************************************


% ======================================================================================================
% RESULTS DISPLAY
% ======================================================================================================
% insert parameters for ERP and TF analysis in the STUDY

%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
project.results_display.filter_freq=10;
%y limits (uV)for the representation of ERP
project.results_display.ylim_plot=[-2.5 2.5];
      
project.results_display.erp.time_range.s=[project.postprocess.erp.tmin_analysis.s project.postprocess.erp.tmax_analysis.s];       % time range for erp representation
project.results_display.ersp.time_range.s=[project.postprocess.ersp.tmin_analysis.s project.postprocess.ersp.tmax_analysis.s];       % time range for erp representation

%  ********* DERIVED DATA : DO NOT EDIT *****************************************************************
project.results_display.erp.time_range.s=project.results_display.erp.time_range.ms/1000;
project.results_display.ersp.time_range.s=project.results_display.ersp.time_range.ms/1000;
%  ********* /DERIVED DATA  *****************************************************************

project.results_display.display_only_significant='off'; %on             % the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark)
project.results_display.compact_plots='on';                             % display (curve) plots with different conditions/groups on the same plots
project.results_display.single_subjects='off';                          % display patterns of the single subjcts (keeping the average pattern)
project.results_display.compact_h0='on';                                % display parameters for compact plots
project.results_display.compact_v0='on';
project.results_display.compact_sem='off';
project.results_display.compact_stats='on';

project.results_display.freq_scale='linear';   %'log'|'linear'

% ======================================================================================================
% EXPORT
% ======================================================================================================
export.r.bands=[];
for nband=1:length(project.postprocess.frequency_bands_names)
    export.r.bands(nband).freq=project.postprocess.frequency_bands_list{nband};
    export.r.bands(nband).name=project.postprocess.frequency_bands_names{nband};
end

export.brainstorm.temporal_downsampling=1;
export.brainstorm.spatial_downsampling=2;

% ======================================================================================================
% BRAINSTORM
% ======================================================================================================
project.brainstorm.db_name='healthy_action_observation_sound';                  ... must correspond to brainstorm db name

project.brainstorm.sources.sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
project.brainstorm.sources.source_orient='fixed';      % possible values are: fixed, loose
project.brainstorm.sources.loose_value=0.2;
project.brainstorm.sources.depth_weighting='nodepth';   % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
project.brainstorm.sources.downsample_atlasname='s3000';

project.brainstorm.analysis_bands={{ ...
                    project.postprocess.ersp.frequency_bands(1).name, [num2str(project.postprocess.ersp.frequency_bands(1).min) ', ' num2str(project.postprocess.ersp.frequency_bands(1).max)], 'mean'; ...
                    project.postprocess.ersp.frequency_bands(2).name, [num2str(project.postprocess.ersp.frequency_bands(2).min) ', ' num2str(project.postprocess.ersp.frequency_bands(2).max)], 'mean'; ...
                    project.postprocess.ersp.frequency_bands(3).name, [num2str(project.postprocess.ersp.frequency_bands(3).min) ', ' num2str(project.postprocess.ersp.frequency_bands(3).max)], 'mean'; ...
                    project.postprocess.ersp.frequency_bands(4).name, [num2str(project.postprocess.ersp.frequency_bands(4).min) ', ' num2str(project.postprocess.ersp.frequency_bands(4).max)], 'mean' ...
                                  }};
                                  
project.brainstorm.analysis_times={{'t-4', '-0.4000, -0.3040', 'mean'; 't-3', '-0.3000, -0.2040', 'mean'; 't-2', '-0.2000, -0.1040', 'mean'; 't-1', '-0.1000, -0.0040', 'mean'; 't1', '0.0000, 0.0960', 'mean'; 't2', '0.1000, 0.1960', 'mean'; 't3', '0.2000, 0.2960', 'mean'; 't4', '0.3000, 0.3960', 'mean'; 't5', '0.4000, 0.4960', 'mean'; 't6', '0.5000, 0.5960', 'mean'; 't7', '0.6000, 0.6960', 'mean'; 't8', '0.7000, 0.7960', 'mean'; 't9', '0.8000, 0.8960', 'mean'; 't10', '0.9000, 0.9960', 'mean'}};

project.brainstorm.surf_bem_file_name='headmodel_surf_openmeeg.mat';
project.brainstorm.vol_bem_file_name='headmodel_vol_openmeeg.mat';
project.brainstorm.use_same_montage=1;
project.brainstorm.default_anatomy='MNI_Colin27';

% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================
% ======================================================================================================



