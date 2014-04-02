%====================================================================================================================================
% PROJECT SETTINGS: 
db_folder_name='bst_db_cleanica';                                ... must correspond to db folder name contained in 'project_folder'    
analysis_name='raw_bc2';    





start_experiment_trigger_value = 1;
pause_trigger_value = 2;                    % start: pause, feedback and rest period
resume_trigger_value = 3;                   % end: pause, feedback and rest period
end_experiment_trigger_value = 4;
videoend_trigger_value = 5;
question_trigger_value = 6;
AOCS_audio_trigger_value = 7;
AOIS_audio_trigger_value = 8;
cross_trigger_value = 9;


acquisition_system='BIOSEMI';



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

%(temptative,approximated)latencies at which tf is computed
tout=[-250:10:850];

%alpha (confidence levels) for bootstrap statistics (evaluate significant variations in power or inter trial coherence) 
tfsig=0.05;

% BRAINSTORM
std_loose_value=0.2;

sources_norm='wmne';        % possible values are: wmne, dspm, sloreta
source_orient='fixed';      % possible values are: fixed, loose
loose_value=0.2;
%depth_weighting='nodepth'; % optional parameter, actually it is enabled for wmne and dspm and disabled for sloreta
standard_brainstorm_analysis_bands={{'teta', '4, 8', 'mean'; 'mu', '8, 13', 'mean'; 'beta1', '14, 20', 'mean'; 'beta2', '20, 32', 'mean'}};
standard_brainstorm_analysis_times={{'t-4', '-0.4000, -0.3040', 'mean'; 't-3', '-0.3000, -0.2040', 'mean'; 't-2', '-0.2000, -0.1040', 'mean'; 't-1', '-0.1000, -0.0040', 'mean'; 't1', '0.0000, 0.0960', 'mean'; 't2', '0.1000, 0.1960', 'mean'; 't3', '0.2000, 0.2960', 'mean'; 't4', '0.3000, 0.3960', 'mean'; 't5', '0.4000, 0.4960', 'mean'; 't6', '0.5000, 0.5960', 'mean'; 't7', '0.6000, 0.6960', 'mean'; 't8', '0.7000, 0.7960', 'mean'; 't9', '0.8000, 0.8960', 'mean'; 't10', '0.9000, 0.9960', 'mean'}};
downsample_atlasname='s3000';

bem_file_name='headmodel_surf_openmeeg.mat';

use_same_montage=1;
default_anatomy='MNI_Colin27';




%#######################################################################################
%EEGLAB settings

%%%%% import settings
interpolate_channels=[];
reference_channels=[];
polygraphic_channels={{65,66,'DVEOG'};{67,68,'DFDR'};{69,70,'NDFDR'};{71,72,'DTA'}};
final_muscles_channels=[66 67 68];
final_muscles_channels_label={'DFDR' 'NDFDR' 'DTA'};
emg_output_postfix_name = '_observation_emg';
% channels_number
nch_eeg=64;

% sampling frequency in Hz
fs=256;

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

%FURTHER EMG FILTER
% lower frequency
ff1_emg=5;
% higher frequency
ff2_emg=100;

% first EOG-related channel
cheog1=nch_eeg+1;
% second EOG-related channel
cheog2=nch_eeg+2;
%%%%% end import settings

%%%%% epoching settings


epo_st=-1;% epochs start latency
epo_end=3;% epochs end latency

bc_st=-900;% baseline correction start latency
bc_end=-512;% baseline correction end latency

bc_st_point=1;
bc_end_point=round((bc_end-bc_st)/(1000/fs));

bc_emg_st_point=1;
bc_emg_end_point=round((bc_end-bc_st)/(1000/fs));

baseline_analysis_interval=[bc_st bc_end];
baseline_analysis_interval_point=[bc_st_point bc_end_point];

%%%%% end epoching settings

tmin_analysis=bc_st;
tmax_analysis=epo_end*1000;
ts_analysis=8;

fmin_analysis=4;
fmax_analysis=32;
fs_analysis=0.5;
padratio=16;



timeout_analysis_interval=[tmin_analysis:ts_analysis:tmax_analysis];
freqout_analysis_interval=[fmin_analysis:fs_analysis:fmax_analysis];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert names of conditions
% all markers imported 
import_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46' '1' '2' '3' '4' '5' '6' '7' '8' '9' '50' '60' '70' '80'};
% conditions: marker codes & name
valid_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46'};


% conditions: marker codes & name
mrkcode_cond={{'11' '12' '13' '14' '15' '16'};... 
		   {'21' '22' '23' '24' '25' '26'};... 
		   {'31' '32' '33' '34' '35' '36'};...
		   {'41' '42' '43' '44' '45' '46'};...
};





group_names={'AC', 'CC'};
between_design_list={{'AC', 'CC'}; 
                     {'AC'};
                     {'CC'};
                    };
between_design_list={};
                
between_numdes=length(between_design_list);
between_design_names={'AC-CC','AC','CC'};

condition_names={'control' 'AO' 'AOCS' 'AOIS'};
within_design_list={ ...
              {'control' 'AO' 'AOCS' 'AOIS'};...all
              {'AO' 'control'};...
              {'AOCS' 'control'};...
              {'AO' 'AOCS' 'AOIS'};...
              {'AOCS' 'AO'};...
              {'AOIS' 'AO'};...              
              {'AOCS' 'AOIS'};...
              {{'AO' 'AOCS' 'AOIS'} {'control'}}... motion          
};
within_numdes=length(within_design_list);
within_design_names={'all_conditions','AO_ctrl','AOCS_ctrl','sound_effect','AOCS_AO','AOIS_AO', 'AOCS_AOIS','allactions_ctrl'};


% for each design of interest, time limits (ms) of the time windws applied for topographycal representations
% time_windows_list={{[500 1000];[1000 1500];[1700 2000];[2000 2300];[2300 2600]};... 
%                    {[500 1000];[1000 1500];[1700 2000];[2000 2300];[2300 2600]};... 
%                    {[500 1000];[1000 1500];[1700 2000];[2000 2300];[2300 2600]};...
%                    {[500 1000];[1000 1500];[1700 2000];[2000 2300];[2300 2600]};...
%                    {[1700 2000];[2000 2300];[2300 2600]};...
%                    {[1700 2000];[2000 2300];[2300 2600]};...
%                    {[1700 2000];[2000 2300];[2300 2600]};...
%                    {[500 1000];[1000 1500];[1700 2100];[2000 2300];[2300 2600]}...
%            };
time_windows_list={{[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]};... 
                   {[0 750] [750 1500] [1700 3000] [0 3000]}... 
           };       
       
% time_windows_names={{'500 1000';'1000 1500';'1700 2000';'2000 2300';'2300 2600'};... 
%                     {'500 1000';'1000 1500';'1700 2000';'2000 2300';'2300 2600'};... 
%                     {'500 1000';'1000 1500';'1700 2000';'2000 2300';'2300 2600'};...
%                     {'500 1000';'1000 1500';'1700 2000';'2000 2300';'2300 2600'};...
%                     {'1700 2000';'2000 2300';'2300 2600'};...
%                     {'1700 2000';'2000 2300';'2300 2600'};...
%                     {'1700 2000';'2000 2300';'2300 2600'};...
%                     {'500 1000';'1000 1500';'1700 2000';'2000 2300';'2300 2600'}...
%            }; 
time_windows_names={{'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'};... 
                    {'0 750' '750 1500' '1700 3000' '0 3000'}... 
           }; 

numcond=length(condition_names);
name_cond=condition_names;  ... backcompatibility

paired_list={{'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'};...
             {'on','on'}...
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert rois for the analysis in EEGLAB
roi_list={{'F5','F7','AF7','FT7'}; ... left IFG
          {'F6','F8','AF8','FT8'}; ... right IFG
          {'FC3','FC5'}; ... l PMD
          {'FC4','FC6'}; ... r PMD    
          {'C3'}; ...       iM1 hand
          {'C4'}; ...       cM1 hand
          {'Cz'}; ...       SMA
          {'CP3','CP5','P3','P5'}; ... left IPL
          {'CP4','CP6','P4','P6'}; ... right IPL
          {'CP3','P3','CP1','P1'}; ... left SPL
          {'CP4','P4','CP2','P2'}; ... right SPL
          {'T7','TP7','CP5','P5'}; ... left pSTS
          {'T8','TP8','CP6','P6'}; ... right pSTS          
          {'O1','PO3','POz','Oz'}; ... left occipital          
          {'O2','PO4','POz','Oz'} ... right occipital 
};
numroi=length(roi_list);
roi_names={'left-ifg','right-ifg','left-PMd','right-PMd','left-SM1','right-SM1','SMA','left-ipl','right-ipl','left-spl','right-spl','left-sts','right-sts','left-occipital','right-occipital'};



roi_list={{'FC3','FC5'}; ... l PMD
          {'FC4','FC6'}; ... r PMD    
          {'C3'}; ...       iM1 hand
          {'C4'}; ...       cM1 hand
          {'Cz'}; ...       SMA
};
numroi=length(roi_list);
roi_names={'left-PMd','right-PMd','left-SM1','right-SM1','SMA'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert parameters for ERP and TF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% analysis in the STUDY
%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
filter_freq=10;
%y limits (uV)for the representation of ERP
ylim_plot=[-2.5 2.5];
      


% for each design of interest, perform or not statistical analysis of erp
show_statistics_list={'on','on','on','on','on','on','on','on'};   
% time range for erp representation
time_range=[tmin_analysis tmax_analysis];
% level of significance applied in ERP statistical analysis
study_ls=0.025; ...0.01;
% the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark) 
display_only_significant='off'; %on
% display (curve) plots with different conditions/groups on the same plots 
display_compact_plots='on';
% display patterns of the single subjcts (keeping the average pattern)
display_single_subjects='off';
% display parameters for compact plots
compact_display_h0='on';
compact_display_v0='on';
compact_display_sem='off';
compact_display_stats='on';


% number of permutations applied in ERP statistical analysis
num_permutations=5000;
% method applied in ERP statistical analysis
stat_method='bootstrap';
% multiple comparison correction applied in ERP statistical analysis
correction='fdr'; 


frequency_bands_list={[4,8];[8,12];[14,20];[20,32]};
frequency_bands_names={'theta','mu','beta1','beta2'};

% frequency_bands_list={[4,8];[8,12]};
% frequency_bands_names={'theta','mu'};

freq_scale='linear';   %'log'|'linear'

export_r_bands=[];
for nband=1:length(frequency_bands_names)
    export_r_bands(nband).freq=frequency_bands_list{nband};
    export_r_bands(nband).name=frequency_bands_names{nband};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% end EEGLAB settings


