%====================================================================================================================================
% PROJECT SETTINGS: 

use_same_montage=1;
default_anatomy='MNI_Colin27';

start_experiment_trigger_value = 0;
% pause_trigger_value = 2;                    % start: pause, feedback and rest period
% resume_trigger_value = 3;                   % end: pause, feedback and rest period


valid_marker={'65280','65290','65291','65300','65301','65302','65320','65322','65381','65382','65383','65384','65385','65386','65387','65388','65389','65390','65391','65392','65393','65394','65395','65396','65397','65398','65399','65400','65401','65402','65403','65404','65405','65406','65407','65408','65409','65410','65411','65412','65413','65414','65415','65416','65417','65418','65419','65420','65421','65422','65423','65424','65425','65426','65427','65428','65429','65430','65431','65432','65433','65434','65435','65436','65437','65438','65439','65440','65481','65482','65483','65484','65487','65488','65489','65490','65499','65500','65501','65502'};
import_marker={'65280','65290','65291','65300','65301','65302','65320','65322','65381','65382','65383','65384','65385','65386','65387','65388','65389','65390','65391','65392','65393','65394','65395','65396','65397','65398','65399','65400','65401','65402','65403','65404','65405','65406','65407','65408','65409','65410','65411','65412','65413','65414','65415','65416','65417','65418','65419','65420','65421','65422','65423','65424','65425','65426','65427','65428','65429','65430','65431','65432','65433','65434','65435','65436','65437','65438','65439','65440','65481','65482','65483','65484','65487','65488','65489','65490','65499','65500','65501','65502'};

polygraphic_channels={{65,66,'DVEOG'};{67,68,'DFDR'};{69,70,'NDFDR'};{71,72,'DTA'}};


% conditions: marker codes & name
mrkcode_cond={{'22_203_42' '22_204_42' '22_207_42' '22_208_42'... 
               '22_203_41' '22_204_41' '22_207_41' '22_208_41'...   
              };... M		      
              {'22_201_42' '22_202''22_209_42' '22_210_42' '22_219_42' '22_220_42' '22_221_42' '22_222_42'...
              '22_201_41' '22_202''22_209_41' '22_210_41' '22_219_41' '22_220_41' '22_221_41' '22_222_41'...              
              };...MM              
              {'22_201_42' '22_203_42' '22_207_42' '22_209_42' '22_219_42' '22_221_42'...
              '22_201_41' '22_203_41' '22_207_41' '22_209_41' '22_219_41' '22_221_41'...              
              };... 100              
              {'22_202_42' '22_204_42' '22_208_42' '22_210_42' '22_220_42' '22_222_42'...
              '22_202_41' '22_204_41' '22_208_41' '22_210_41' '22_220_41' '22_222_41'...
              };... 300
              {'22_203_42' '22_207_42'...
              '22_203_41' '22_207_41'...
              };... M-100
              {'22_201_42' '22_209''22_219_42' '22_221_42'...
              '22_201_41' '22_209''22_219_41' '22_221_41'...
              };... MM-100
              {'22_204_42' '22_208'...
              '22_204_41' '22_208'...
              };... M-300
              {'22_202_42' '22_210_42' '22_220_42' '22_222_42'...              
              '22_202_41' '22_210_41' '22_220_41' '22_222_41'
              };... MM-300
              {'22_203_42' '22_204_42' '22_207_42' '22_208_42' };... M-R
		      {'22_201_42' '22_202''22_209_42' '22_210_42' '22_219_42' '22_220_42' '22_221_42' '22_222_42'};...MM-R 
              {'22_201_42' '22_203_42' '22_207_42' '22_209_42' '22_219_42' '22_221_42'};... 100-R
              {'22_202_42' '22_204_42' '22_208_42' '22_210_42' '22_220_42' '22_222_42'};... 300-R              
              
              {'22_203_42' '22_207_42'};... M-100-R
              {'22_201_42' '22_209''22_219_42' '22_221_42'};... MM-100-R
              
              {'22_204_42' '22_208_42'};... M-300-R
              {'22_202_42' '22_210_42' '22_220_42' '22_222_42'};... MM-300-R   
              
              {'22_203_41' '22_204_41' '22_207_41' '22_208_41' };... M-W
		      {'22_201_41' '22_202''22_209_41' '22_210_41' '22_219_41' '22_220_41' '22_221_41' '22_222_41'};...MM-W 
              {'22_201_41' '22_203_41' '22_207_41' '22_209_41' '22_219_41' '22_221_41'};... 100-W
              {'22_202_41' '22_204_41' '22_208_41' '22_210_41' '22_220_41' '22_222_41'};... 300-W              
              
              {'22_203_41' '22_207_41'};... M-100-W
              {'22_201_41' '22_209''22_219_41' '22_221_41'};... MM-100-W
              
              {'22_204_41' '22_208_41'};... M-300-W
              {'22_202_41' '22_210_41' '22_220_41' '22_222_41'}... MM-300-W   
               
              
              {'22_201_42' '22_209_42'...
              '22_201_41' '22_209_41'...
              };... MM-note-100

              {'22_202_42' '22_210_42' ...              
              '22_202_41' '22_210_41'...
              };... MM-note-300
              
              
              {'22_219_42' '22_221_42'...
               '22_219_41' '22_221_41'...
              };... MM-wn-100

              {'22_220_42' '22_222_42'...              
               '22_220_41' '22_222_41'
              };... MM-wn-300
              
              {'22_201_42' '22_209_42'...
              };... MM-note-100-R

              {'22_202_42' '22_210_42' ...
              };... MM-note-300-R
              
              
              {'22_219_42' '22_221_42'...
              };... MM-wn-100-R

              {'22_220_42' '22_222_42'...
              };... MM-wn-300-R
              
              
              {'22_201_41' '22_209_41'...
              };... MM-note-100-W

              {'22_202_41' '22_210_41'...
              };... MM-note-300-W
              
              
              {'22_219_41' '22_221_41'...
              };... MM-wn-100-W

              {'22_220_41' '22_222_41'
              };... MM-wn-300-W
              
              };


condition_names={'M' 'MM'... 
                '100' '300'... 
                'M-100' 'MM-100' 'M-300'        'MM-300'...
                'M-R' 'MM-R'    '100-R'         '300-R' 'M-100-R' 'MM-100-R' 'M-300-R' 'MM-300-R'... 
                'M-W' 'MM-R'    '100-W'         '300-W' 'M-100-W' 'MM-100-W' 'M-300-W' 'MM-300-W'...                
                'MM-note-100'   'MM-note-300'   'MM-wn-100' 'MM-wn-300'...
                'MM-note-100-R' 'MM-note-300-R' 'MM-wn-100-R' 'MM-wn-300-R'...
                'MM-note-100-W' 'MM-note-300-W' 'MM-wn-100-W' 'MM-wn-300-W'                
                };
name_cond=condition_names;  ... backcompatibility

% if do_factors
%     for subj=1:length(subjects_list)
%         for cond=1:length(condition_names)
%             setname=[subjects_list{subj} , pre_epoching_input_file_name,'_' , condition_names{cond} '.set'];
%             fullsetname=fullfile(epochs_path,setname,'');
%             if strfind(fullsetname,'M')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'CueVsImperative', 'Match');                    
%             end
%             
%             if strfind(fullsetname,'MM')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'CueVsImperative', 'Mismatch');                    
%             end
%                         
%             if strfind(fullsetname,'100')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Anticipation', '100');
%             end
% 
%             if strfind(fullsetname,'300')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Anticipation', '300');
%             end
%             
%             if strfind(fullsetname,'-R')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Response', 'Right');
%             end
%             
%             
%             if strfind(fullsetname,'-W')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Response', 'Wrong');
%             end
%             
%             if strfind(fullsetname,'-note')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Cue', 'Note');
%             end
%             
%             if strfind(fullsetname,'passive')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Status', 'Passive');
%             end
%             
%             if strfind(fullsetname,'active')
%                     eeglab_subject_add_factor(project_settings,fullsetname, 'Status', 'Active');
%             end
%             
%         end
%     end
% 
% end






add_factor_bck_list={...
                    {{'M'},'CueVsImperative','Match'};...
                    {{'MM'},'CueVsImperative','Mismatch'};...
                    {{'100'},'Anticipation','100'};...
                    {{'300'},'Anticipation','300'};...
                    {{'-note'},'Cue','Note'};...
                    {{'-wn'},'Cue','WhiteNoise'};...    
                    {{'passive'},'Status','Passive'};...    
                    {{'active'},'Status','Active'};...
                    {{'M','passive'},'CueVsImperativeWithinPassive','Match'};...
                    {{'MM','passive'},'CueVsImperativeWithinPassive','Mismatch'};...
                    {{'100','passive'},'AnticipationWithinPassive','100'};...
                    {{'300', 'passive'},'AnticipationWithinPassive','300'};...
                    {{'-note','passive'},'CueWithinPassive','Note'};...
                    {{'-wn','passive'},'CueWithinPassive','WhiteNoise'};...                        
                    {{'M','active'},'CueVsImperativeWithinActive','Match'};...
                    {{'MM','active'},'CueVsImperativeWithinActive','Mismatch'};...
                    {{'100','active'},'AnticipationWithinActive','100'};...
                    {{'300', 'active'},'AnticipationWithinActive','300'};...
                    {{'-note','active'},'CueWithinActive','Note'};...
                    {{'-wn','active'},'CueWithinActive','WhiteNoise'}...
};





% group_list={
%     {'2 carol active-Deci' '3 andre active second-Deci' '3 andre active-Deci'    '4 julian active-Deci'    'Hadassa_active-Deci'    'Viviane_active-Deci'    'alexander_active-Deci'...    
%     'claudia_active-Deci'    'claudia_active_bis-Deci'    'dorine_active-Deci'    'elbert_active-Deci'    'elena_active-Deci'    'laura_active-Deci'    'maggie_active-Deci'...
%      'reinoud_active-Deci'    'stein_active-Deci'    'sunjin_active-Deci'    'susan_active-Deci'    'tomas_active-Deci'};...
%      
%     {   '2 carol passive-Deci'    '3 andre passive-Deci'    '4 julian passive-Deci'    'Hadassa_passive-Deci'    'Viviane_passive-Deci'    'alexander_passive-Deci'    'claudia_passive-Deci'...
%     'claudia_passive_bis-Deci'    'dorine_passive-Deci'    'elbert_passive-Deci'    'elena_passive-Deci'    'laura_passive-Deci'    'maggie_passive-Deci'    'maggie_passive2-Deci'...
%     'reinoud_passive-Deci'    'stein_passive-Deci'    'stein_passive2-Deci'    'sunjin_passive-Deci'    'susan_passive-Deci'    'tomas_passive-Deci'    'tomas_passive2-Deci'}
%     };
% 
% group_names={'Active', 'Passive'};
% 

group_list={{ '2 carol active-Deci'    '2 carol passive-Deci'    '3 andre active second-Deci'    '3 andre active-Deci'    '3 andre passive-Deci'    '4 julian active-Deci'    '4 julian passive-Deci'...
    'Hadassa_active-Deci'    'Hadassa_passive-Deci'    'Viviane_active-Deci'    'Viviane_passive-Deci'    'alexander_active-Deci'    'alexander_passive-Deci'    'claudia_active-Deci'...
    'claudia_active_bis-Deci'    'claudia_passive-Deci'    'claudia_passive_bis-Deci'    'dorine_active-Deci'    'dorine_passive-Deci'    'elbert_active-Deci'    'elbert_passive-Deci'...
    'elena_active-Deci'    'elena_passive-Deci'    'laura_active-Deci'    'laura_passive-Deci'    'maggie_active-Deci'    'maggie_passive-Deci'    'maggie_passive2-Deci'    'reinoud_active-Deci'...
    'reinoud_passive-Deci'    'stein_active-Deci'    'stein_passive-Deci'    'stein_passive2-Deci'    'sunjin_active-Deci'    'sunjin_passive-Deci'    'susan_active-Deci'    'susan_passive-Deci'...
    'tomas_active-Deci'    'tomas_passive-Deci'    'tomas_passive2-Deci'}};

% group_list={{ '2 carol active-Deci'    '2 carol passive-Deci'   }};

%  '3 andre active second-Deci'    '3 andre active-Deci'
group_names={'All'};


design_list_bck={...
                 {'CueVsImperative'  {'Match','Mismatch'}  '' {}   'CueVsImperative'};...
                 {'Anticipation'  {'100','300'}  '' {}   'Anticipation'};...
                 {'CueVsImperative'  {'Match','Mismatch'}  'Anticipation' {'100','300'}   'CueVsImperativeVsAnticipation'};...
                 {'Cue'  {'Note','WhiteNoise'}  '' {}   'Cue'};...
                 {'Cue'  {'Note','WhiteNoise'}  'Anticipation'  {'100','300'}   'CueVsAnticipation'};...
                 {'Status'  {'Passive','Active'}  'CueVsImperative'  {'Match','Mismatch'}   'StatusVsCueVsImperative'};...
                 {'Status'  {'Passive','Active'}  'Anticipation'  {'100','300'}   'StatusVsAnticipation'};...
                 {'CueVsImperativeWithinPassive'  {'Match','Mismatch'}  '' {}   'CueVsImperativeWithinPassive'};...
                 {'AnticipationWithinPassive'  {'100','300'}  '' {}   'AnticipationWithinPassive'};...
                 {'CueVsImperativeWithinPassive'  {'Match','Mismatch'}  'AnticipationWithinPassive' {'100','300'}   'CueVsImperativeVsAnticipationWithinPassive'};...
                 {'CueWithinPassive'  {'Note','WhiteNoise'}  '' {}   'CueWithinPassive'};...
                 {'CueWithinPassive'  {'Note','WhiteNoise'}  'AnticipationWithinPassive'  {'100','300'}   'CueVsAnticipationWithinPassive'};...
                 {'CueVsImperativeWithinActive'  {'Match','Mismatch'}  '' {}   'CueVsImperativeWithinActive'};...
                 {'AnticipationWithinActive'  {'100','300'}  '' {}   'AnticipationWithinActive'};...
                 {'CueVsImperativeWithinActive'  {'Match','Mismatch'}  'AnticipationWithinActive' {'100','300'}   'CueVsImperativeVsAnticipationWithinActive'};...
                 {'CueWithinActive'  {'Note','WhiteNoise'}  '' {}   'CueWithinActive'};...
                 {'CueWithinActive'  {'Note','WhiteNoise'}  'AnticipationWithinActive'  {'100','300'}   'CueVsAnticipationWithinActive'}...
                 };

numdes=length(design_list_bck);

% design_list_bck={ ...
%               {'Status' '' 'Status'}
%               
% };


% % design_list_bck={ ...
% %               {'CueVsImperative' '' 'CueVsImperative'};...
% %               {'Anticipation' '' 'Anticipation'};...
% %                        
% % };


design_pairing_list_bck={ ...
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};... 
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};... 
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};...      
              {'on'  'on'};... 
              {'on'  'on'}...                  
};





design_names={};
for ndes=1:numdes
    design_names{ndes}=design_list_bck{ndes}{5};
end



roi_list={{'F7','F3','FC5','FC1','C3'}; ... LEFT ANTERIOR(LA)
          {'F8','F4','FC6','FC2','C4'}; ... RIGHT ANTERIOR(RA)
          {'Fz','Cz'}; ... MIDLINE ANTERIOR(MA)
          {'CP1','CP5','P3','P7','PO7','O1'}; ... LEFT POSTERIOR(LP)
          {'CP2','CP6','P4','P8','PO8','O2'}; ... RIGHT POSTERIOR(RP)
          {'Pz','Oz'} ... MIDLINE POSTERIOR(MP)
          
          {'TP7','T7'}; ... LEFT TEMPORO-PARIETAL(LTP)
          {'TP8','T8'}; ... RIGHT TEMPORO-PARIETAL(RTP)
          
};


roi_names={'LA','RA','MA','LP','RP','MP','LTP','RTP'};

numroi=length(roi_list);


%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
filter_freq=10;
%y limits (uV)for the representation of ERP
ylim_plot=[-2.5 2.5];



% channels_number
nch_eeg=64;


% sampling frequency
fs=250;

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
ff2_eog=20;

%FURTHER EMG FILTER
% lower frequency
ff1_emg=5;
% higher frequency
ff2_emg=100;



% first EOG-related channel
cheog1=1;
% second EOG-related channel
cheog2=2;

% epochs start latency
epo_st=-1.5;
% epochs end latency
epo_end=3;

% baseline correction start latency
bc_st=-1400;
% baseline correction end latency
bc_end=-4;

interpolate_channels=[];
reference_channels=[];


bc_st_point=1;
bc_end_point=round((bc_end-bc_st)/(1000/fs));

bc_emg_st_point=1;
bc_emg_end_point=round((bc_end-bc_st)/(1000/fs));

baseline_analysis_interval=0;
baseline_analysis_interval_point=[bc_st_point bc_end];
%%%%% end epoching settings

%per erp
tmin_analysis=-1500;
tmax_analysis=2996;


ts_analysis=20;

fmin_analysis=4;
fmax_analysis=32;
fs_analysis=1;
padratio=2;



timeout_analysis_interval=[tmin_analysis:ts_analysis:tmax_analysis];
freqout_analysis_interval=[fmin_analysis:fs_analysis:fmax_analysis];



%       'baseline'  = Spectral baseline end-time (in ms). NaN --> no baseline is used. 
%                     A [min max] range may also be entered
%                     You may also enter one row per region for baseline
%                     e.g. [0 100; 300 400] considers the window 0 to 100 ms and
%                     300 to 400 ms This parameter validly defines all baseline types 
%                     below. Again, [NaN] Prevent baseline subtraction.     
baseline=NaN;     
     
                
% for each design of interst, perform or not statistical analysis of erp
show_statistics_list={'on','on','on','on','on','on','on','on','on','on','on','on','on','on','on','on','on','on','on','on','on'};   
% time range for erp representation
time_range=[-200 1000];
% level of significance applied in ERP statistical analysis NaN plots
% p-values
study_ls=0.001;%0.0071;%0.00156;%0.00156;%0.005;%0.005;%NaN%
% the threshold is always set, however you can choose to display only the significant p values or all the p values (in the curve plots the threshold is added as a landmark) 
display_only_significant='on'; %on
% display patterns of the single subjcts (keeping the average pattern)
display_single_subjects='off';



ersp_mode='dB';% 'Pfu';  %%%%%%%%%% dB decibel, Pfu, (A-R)/R * 100 = (A/R-1) * 100 = (10^.(ERSP/10)-1)*100 variazione percentuale definita da pfursheller






% display (curve) plots with different conditions/groups on the same plots 
display_compact_plots_erp='off';
% display parameters for compact plots
compact_display_h0_erp='on';
compact_display_v0_erp='on';
compact_display_sem_erp='off';
compact_display_stats_erp='on';
compact_display_xlim_erp=[];
compact_display_ylim_erp=[];


% display (curve) plots with different conditions/groups on the same plots 
display_compact_plots_ersp_curve_fb='on';
% display parameters for compact plots
compact_display_h0_ersp_curve_fb='on';
compact_display_v0_ersp_curve_fb='on';
compact_display_sem_ersp_curve_fb='off';
compact_display_stats_ersp_curve_fb='on';
compact_display_xlim_ersp_curve_fb=[];
compact_display_ylim_ersp_curve_fb=[];



% number of permutations applied in ERP statistical analysis
num_permutations=20000;%10000;
% method applied in ERP statistical analysis
stat_method='bootstrap';%'permutation';
% multiple comparison correction applied in ERP statistical analysis
correction='fdr';%'none';'fdr';%'holms';

frequency_bands_list={[4,8];[8,12];[14,20];[20,32]};
frequency_bands_names={'theta','mu-alpha','beta1','beta2'};

% frequency_bands_list={[8,13]};
% frequency_bands_names={'mu-alpha'};

% frequency_bands_list={[14,20];[20,32]};
% frequency_bands_names={'beta1','beta2'};


% frequency_bands_list={[4,8]};
% frequency_bands_names={'theta'};
% 

freq_scale='linear';   %'log'|'linear'


export_r_bands=[];
for nband=1:length(frequency_bands_names)
    export_r_bands(nband).freq=frequency_bands_list{nband};
    export_r_bands(nband).name=frequency_bands_names{nband};
end



































% channels file name
eeglab_channels_file_name='standard-10-5-cap385.elp';
brainstorm_channels_file_name='brainstorm_channel.pos';
eeglab_cluster_projection_channels_file='cluster_projection_channel_locations.loc';
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
standard_downsample_atlasname='s3000';

bem_file_name='headmodel_surf_openmeeg.mat';
