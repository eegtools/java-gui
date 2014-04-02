%====================================================================================================================================
% PROJECT SETTINGS: 


use_same_montage=1;
default_anatomy='MNI_Colin27';












%#######################################################################################
%EEGLAB settings

%
interpolate_channels=[];
reference_channels=[];

%create a cell array of strings  (the names of the subjects)
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
numsubj=length(subjects_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert names of conditions

% conditions: marker codes & name
valid_marker={'S193' 'S194' 'S230' 'S235' 'S236' 'S240' 'S245' 'S246' 'S185' 'S186' 'S205' 'S235' 'S245' 'S206' 'S236' 'S246' 'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11' 'S 12' 'S 13' 'S 14' 'S 15' 'S 16' 'S 17' 'S 18' 'S 19' 'S 20' 'S201' 'S205' 'S240' 'S245' 'S206' 'S230' 'S235' 'S236', 'S246'};
% conditions: marker codes & name
mrkcode_cond={'S  1' 'S  2' 'S  3' 'S  4'};
conditions_list={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};
numcond=length(conditions_list);
name_cond=conditions_list;

designs_list={{{'cwalker' 'twalker' 'cscrambled' 'tscrambled'}};...all
              {{{'tscrambled' 'twalker'} {'cscrambled' 'cwalker'}}};... motion
              {{{'cscrambled' 'tscrambled'} {'cwalker' 'twalker'}}};... shape
              {{'tscrambled' 'twalker'}};...  
              {{'cscrambled' 'cwalker'}};...              
              {{'cwalker' 'twalker'}};...
              {{'cscrambled' 'tscrambled'}}...
          
};
numdes=length(designs_list);
design_names={'all','motion','shape','shape_within_translating','shape_within_centered','motion_within_walker','motion_within_scrambled','shape','moto-shape-interaction','mixed'};

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
% roi proposte da Alessandro
roi_list={{'F5','F7','AF7'}; ... left IFG
          {'F6','F8','AF8'}; ... right IFG
          {'FC3','FC5'}; ... l PMD
          {'FC4','FC6'}; ... r PMD    
          {'C3','Cz','C4'}; ...
          {'CP3','CP5','C5'}; ...left IPL
          {'CP4','CP6','C6'}; ... right IPL
          {'T7','TP7','CP5'}; ... left pSTS
          {'T8','TP8','CP6'}; ... right pSTS          
          {'P7','PO7','PO9','TP9','TP7'}; ... left EBA_MT
          {'P8','PO8','PO10','TP10','TP8'}; ... left EBA_MT
          {'O1','PO3','Oz'}; ... left occipital          
          {'O2','PO4','Oz'}; ... right occipital 
          {'O1'}; ...
          {'O2'}; ...
          {'Oz'}; ...
          {'CP3'}; ... 
          {'CP4'}; ... 
          {'CP1'}; ... 
          {'CPz'}; ... 
          {'CP2'}; ... 
          {'P7'}; ... 
          {'P8'}; ... 
          {'P5'}; ... 
          {'P6'}; ... 
          {'P3'}; ... 
          {'P4'}; ...
          {'Pz'}; ...
          {'C3'}; ... 
          {'Cz'}; ... 
          {'C4'}; ... 
          {'FC3'}; ... 
          {'FC4'}; ...          
          {'F3'}; ... 
          {'F4'} ...
          
};
roi_names={'left-ifg','right-ifg','left-pmd','right-pmd','C','left-ipl','right-ipl','left-psts','right-psts','left-eba-mt','right-eba-mt','left occipital','right occipital','O1','O2','Oz', 'CP3','CP4','CP1','CPz','CP2','P7','P8','P5','P6','P3','P4','Pz', 'C3','Cz','C4','FC3','FC4','F3','F4'};


% roi_list={ {'Pz'};... 
% };
% roi_names={'Pz'};

numroi=length(roi_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% insert parameters for ERP and TF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% analysis in the STUDY
%frequency (Hz) of low-pass filter to be applied (only for visualization) of ERP data
filter_freq=10;
%y limits (uV)for the representation of ERP
ylim_plot=[-2.5 2.5];
% for each design of interest, time limits (ms) of the time windws applied for topographycal representations
time_windows_list={{[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]};... %p100, p1, n170, p2, p3, n4
                   {[80 120];[100 130];[140 190];[180 240];[250 350];[400 600]}... %p100, p1, n170, p2, p3, n4
           };
time_windows_names={{'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'};... 
                    {'80-120';'100-130';'140-190';'180-240';'250-350';'400-600'}... 
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
time_range=[-200 1000];
% level of significance applied in ERP statistical analysis NaN plots
% p-values
study_ls=NaN;
% number of permutations applied in ERP statistical analysis
num_permutations=5000;
% method applied in ERP statistical analysis
stat_method='bootstrap';%'permutation';
% multiple comparison correction applied in ERP statistical analysis
correction='fdr';%'holms';

% frequency_bands_list={[4,8];[8,12];[14,20];[20,32]};
% frequency_bands_names={'theta','mu-alpha','beta1','beta2'};

frequency_bands_list={[8,12]};
frequency_bands_names={'mu-alpha'};

freq_scale='linear';   %'log'|'linear'


export_r_bands=[];
for nband=1:length(frequency_bands_names)
    export_r_bands(nband).freq=frequency_bands_list{nband};
    export_r_bands(nband).name=frequency_bands_names{nband};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% end EEGLAB settings





















































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

%number of cycles for the wavelet trasnform at the lowest frequency
mcw=1;

%wavelet cycles increase with frequency beginning at mcw
icw=0.5;

%maximum frequency (Hz) for the time frequency representation
mfw=45;

%padratio, zero padding to improve frequency resolution: for the hen cycles~=0, frequency spacing is divided by padratio.
prat=16;

% epochs start latency
epo_st=-0.4;
% epochs end latency
epo_end=3;

% baseline correction start latency
bc_st=-200;
% baseline correction end latency
bc_end=-12;
%%%%% end epoching settings

tmin_analysis=-200;
tmax_analysis=800;
ts_analysis=8;
padratio=16;

fmin_analysis=4;
fmax_analysis=32;
fs_analysis=0.5;



timeout_analysis_interval=[tmin_analysis:ts_analysis:tmax_analysis];
freqout_analysis_interval=[fmin_analysis:fs_analysis:fmax_analysis];


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
