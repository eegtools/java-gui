%====================================================================================================================================
% PROJECT SETTINGS: 



use_same_montage=1;
default_anatomy='MNI_Colin27';

% name_maineffects={'walker' 'scrambled' 'centered' 'translating'};
num_contrasts=6;            % 4 basic conditions contrast + 2 main effects contrast
tot_number_conditions=8;    % 4 basic conditions + 4 main effects condition (walker, translating, centered, scrambled)


% sampling frequency
fs=250;

% lower frequency
ff1=0.1;
% higher frequency
ff2=45;

% first EOG-related channel
cheog1=1;
% second EOG-related channel
cheog2=2;

% epochs start latency
epo_st=-0.4;
% epochs end latency
epo_end=1;

% baseline correction start latency
bc_st=-400;
% baseline correction end latency
bc_end=-4;

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













%#######################################################################################
%EEGLAB settings

%
interpolate_channels=[];
reference_channels={'TP9', 'TP10'};

%create a cell array of strings  (the names of the subjects)

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
name_cond=conditions_list;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert parameters for ERP and TF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% analysis in the STUDY
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

frequency_bands_list=[[4,8];[8,12];[14,20];[20,32]];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% end EEGLAB settings

