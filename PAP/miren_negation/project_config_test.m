%====================================================================================================================================
% PROJECT SETTINGS: 
analysis_name='raw';                             ... subfolder containing the current analysis type (refers to EEG device input data type)
db_folder_name='miren_negation';                  ... must correspond to brainstorm db name

acquisition_system='BRAINAMP';
polygraphic_channels=[];

electrodes2discard={'HEOG','RM','VEOG'};



nch_eeg=28;
% sampling frequency
fs=500;

% GLOBAL FILTER
% lower frequency in Hz
ff1_global=0.16;
% higher frequency
ff2_global=100;

%FURTHER EEG FILTER
% lower frequency
ff1_eeg=0.16;
% higher frequency
ff2_eeg=45;

%FURTHER EOG FILTER
% lower frequency
ff1_eog=0.16;
% higher frequency
ff2_eog=8;

% first EOG-related channel
cheog1=17;
% second EOG-related channel
cheog2=31;


start_pause_trigger=10;
end_pause_trigger=11;

%#######################################################################################
%EEGLAB settings

%
interpolate_channels=[];
reference_channels=[];

%create a cell array of strings  (the names of the subjects)
subjects_list={'MIREN_MU000004','MIREN_MU000006','MIREN_MU000007','MIREN_MU000008','MIREN_MU000009','MIREN_MU000010','MIREN_MU000011','MIREN_MU000012','MIREN_MU000013','MIREN_MU000014','MIREN_MU000015','MIREN_MU000016','MIREN_MU000017','MIREN_MU000018','MIREN_MU000019','MIREN_MU000020','MIREN_MU000021','MIREN_MU000022','MIREN_MU000023'};
...subjects_list={'MIREN_MU000006','MIREN_MU000007','MIREN_MU000008','MIREN_MU000009','MIREN_MU000010','MIREN_MU000011','MIREN_MU000012','MIREN_MU000013','MIREN_MU000014','MIREN_MU000015','MIREN_MU000016','MIREN_MU000017','MIREN_MU000018','MIREN_MU000019','MIREN_MU000020','MIREN_MU000021','MIREN_MU000022','MIREN_MU000023'};
numsubj=length(subjects_list);
group_list={{'MIREN_MU000004','MIREN_MU000006','MIREN_MU000007','MIREN_MU000008','MIREN_MU000009','MIREN_MU000010','MIREN_MU000011','MIREN_MU000012','MIREN_MU000013','MIREN_MU000014','MIREN_MU000015','MIREN_MU000016','MIREN_MU000017','MIREN_MU000018','MIREN_MU000019','MIREN_MU000020','MIREN_MU000021','MIREN_MU000022','MIREN_MU000023'}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert names of conditions

% conditions: marker codes & name
import_marker={'S  1' 'S  2' 'S  3' 'S  4' 'S201' 'S202'};

% conditions: marker codes & name
mrkcode_cond={'S  1' 'S  2' 'S  3' 'S  4'};
conditions_names={'abstract_pos' 'abstract_neg' 'action_pos' 'action_neg'};
numcond=length(conditions_names);
name_cond=conditions_names;

num_des=3;

within_design_names={'sem x synt','semantic', 'syntactic'};
% factor1_list={ ...
%               {{'abstract_pos' 'abstract_neg'} {'action_pos' 'action_neg'}};  ... abstract vs action
%               {{'abstract_pos' 'action_pos'} {'abstract_neg' 'action_neg'}};  ... pos vs neg
%               {'abstract_pos' 'abstract_neg'};...                             ... pos vs neg within abstract
%               {'action_pos' 'action_neg'};...                                 ... pos vs neg within action
%               {'abstract_pos' 'action_pos'};...                               ... action vs abstract within pos
%               {'abstract_neg' 'action_neg'}...                                ... action vs abstract within neg
% };
% num_factor1=length(factor1_list);
% factor1_names={'abstract vs action','pos vs neg','pos vs neg within abstract','pos vs neg within action','action vs abstract within pos','action vs abstract within neg'};

factor2_list=[];
name_maineffects={'abstract', 'action', 'pos', 'neg'};
num_contrasts=6;

group_names={'monolingual'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert rois for the analysis in EEGLAB


% roi_list={ ...
%           {'Fz'}; ... 
%           {'F7'}; ...
%           {'FC5'}; ...
%           {'FC1'}; ...
%           {'C3'}; ...
%           {'CP5'}; ...
%           {'Cz'}; ...
%           {'F8'}; ...
%           {'FC6'}; ...          
%           {'FC2'}; ...
%           {'C4'}; ...
%           {'CP6'} ...
% };

roi_list={ ...
          {'C3'}; ...
          {'C4'} ...
};


...roi_names={'Fz','F7','FC5','FC1','C3','CP5','Cz','F8','FC6','FC2','C4','CP6'};
roi_names={'C3','C4'};

numroi=length(roi_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert parameters for ERP and TF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% analysis in the STUDY
%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
filter_freq=10;
%y limits (uV)for the representation of ERP
ylim_plot=[-2.5 2.5];
% for each design of interest, time limits (ms) of the time windws applied for topographycal representations

%time_windows={[100 120];[200 230];[300 360];[390 450];[450 550];[550 800]};
brainstorm_time_windows={ ... 
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        {[0.1 0.12];[0.2 0.228];[0.3 0.36];[0.388 0.448];[0.448 0.548];[0.548 0.8]}; ...
                        };
brainstorm_time_windows_names={{'P100';'N200';'P330';'N400';'P500';'N600'};... 
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                                {'P100';'N200';'P330';'N400';'P500';'N600'};...
                               };
                    

time_windows_list={ ...
                    {[0 1400];[0 700];[700 1400]};... 
                    {[0 1400];[0 700];[700 1400]};...
                    {[0 1400];[0 700];[700 1400]}...
           };

time_windows_names={ ...
                    {'all';'0-700';'700-1400'};... 
                    {'all';'0-700';'700-1400'};... 
                    {'all';'0-700';'700-1400'}... 
                   };


paired_list={{'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'}...
         };
                
                
% for each design of interst, perform or not statistical analysis of erp
show_statistics_list={'on','on','on','on','on','on','on'};   
% time range for erp representation
time_range=[-1000 1400];
% level of significance applied in ERP statistical analysis NaN plots
% p-values
study_ls=0.05;%0.00156;%0.005;%0.005;%NaN%
% the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark) 
display_only_significant='on'; %on
% display patterns of the single subjcts (keeping the average pattern)
display_single_subjects='on';

% display (curve) plots with different conditions/groups on the same plots 
display_compact_plots='off';
% display parameters for compact plots
compact_display_h0='on';
compact_display_v0='on';
compact_display_sem='off';
compact_display_stats='on';
compact_display_xlim=[];
compact_display_ylim=[];

compact_display_xlim=[];
compact_display_ylim=[];

% number of permutations applied in ERP statistical analysis
num_permutations=5000;
% method applied in ERP statistical analysis
stat_method='bootstrap';%'permutation';
% multiple comparison correction applied in ERP statistical analysis
correction='fdr';%'holms';

frequency_bands_list={[4,8];[8,13];[14,20];[20,32]};
frequency_bands_names={'theta','mu-alpha','beta1','beta2'};

% frequency_bands_list={[8,13]};
% frequency_bands_names={'mu-alpha'};

% frequency_bands_list={[14,20];[20,32]};
% frequency_bands_names={'beta1','beta2'};


frequency_bands_list={[8,13]};
frequency_bands_names={'mu-alpha'};
% 

freq_scale='linear';   %'log'|'linear'


export_r_bands=[];
for nband=1:length(frequency_bands_names)
    export_r_bands(nband).freq=frequency_bands_list{nband};
    export_r_bands(nband).name=frequency_bands_names{nband};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end EEGLAB settings

% epochs start latency
epo_st=-1.90;
% epochs end latency
epo_end=1.4;

% baseline correction start latency
bc_st=-1900;
% baseline correction end latency
bc_end=-400;


bc_st_point=1;
bc_end_point=round((bc_end-bc_st)/(1000/fs));



% channels file name
eeglab_channels_file_name='standard-10-5-cap385.elp';
brainstorm_channels_file_name='brainstorm_channel.pos';

%number of cycles for the wavelet trasnform at the lowest frequency
mcw=1;

%wavelet cycles increase with frequency beginning at mcw
icw=0.5;

%maximum frequency (Hz) for the time frequency representation
mfw=45;

%padratio, zero padding to improve frequency resolution: for the hen cycles~=0, frequency spacing is divided by padratio.
prat=16;

%%%% end epoching settings

tmin_analysis=-1900;
tmax_analysis=1400;
ts_analysis=8;


fmin_analysis=4;
fmax_analysis=32;
fs_analysis=0.5;

padratio=16;

timeout_analysis_interval=[tmin_analysis:ts_analysis:tmax_analysis];
freqout_analysis_interval=[fmin_analysis:fs_analysis:fmax_analysis];

baseline_analysis_interval=[bc_st bc_end];
baseline_analysis_interval_point=[bc_st_point bc_end_point];

%alpha (confidence levels) for bootstrap statistics (evaluate significant variations in power or inter trial coherence) 
tfsig=0.05;

% BRAINSTORM

use_same_montage=1;
default_anatomy='MNI_Colin27';

std_loose_value=0.2;

sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
source_orient='free';      % possible values are: fixed, loose
loose_value=0.2;
%depth_weighting='nodepth'; % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
standard_brainstorm_analysis_bands={{'teta', '4, 8', 'mean'; 'mu', '8, 13', 'mean'; 'beta1', '14, 20', 'mean'; 'beta2', '20, 32', 'mean'}};
standard_brainstorm_analysis_times={{'t-4', '-0.4000, -0.3040', 'mean'; 't-3', '-0.3000, -0.2040', 'mean'; 't-2', '-0.2000, -0.1040', 'mean'; 't-1', '-0.1000, -0.0040', 'mean'; 't1', '0.0000, 0.0960', 'mean'; 't2', '0.1000, 0.1960', 'mean'; 't3', '0.2000, 0.2960', 'mean'; 't4', '0.3000, 0.3960', 'mean'; 't5', '0.4000, 0.4960', 'mean'; 't6', '0.5000, 0.5960', 'mean'; 't7', '0.6000, 0.6960', 'mean'; 't8', '0.7000, 0.7960', 'mean'; 't9', '0.8000, 0.8960', 'mean'; 't10', '0.9000, 0.9960', 'mean'}};
standard_downsample_atlasname='s3000';

surf_bem_file_name='headmodel_surf_openmeeg.mat';
vol_bem_file_name='headmodel_vol_openmeeg.mat';

export_spm_voldownsampling=4;
export_spm_timedownsampling=1;
