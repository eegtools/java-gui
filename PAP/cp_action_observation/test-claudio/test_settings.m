use_same_montage=1;
default_anatomy='MNI_Colin27';


% conditions: marker codes & name
mrkcode_cond={{'11' '12'  '13' '14' '15' '16'};... 
		   {'21' '22'  '23' '24' '25' '26'};... 
		   {'31' '32'  '33' '34' '35' '36'};...
		   {'41' '42'  '43' '44' '45' '46'};...
};
name_cond={'control' 'AO' 'AOCS' 'AOIS'};

mrkcode_cond2={{'60'};{'70'}};
name_cond2={'CS','IS'};

name_maineffects={'walker' 'scrambled' 'centered' 'translating'};
num_contrasts=6;            % 4 basic conditions contrast + 2 main effects contrast
tot_number_conditions=8;    % 4 basic conditions + 4 main effects condition (walker, translating, centered, scrambled)

% channels_number
nch_eeg=64;

% sampling frequency
fs=250;

% lower frequency
ff1=0.16;
% higher frequency
ff2=45;

% first EOG-related channel
cheog1=nch_eeg+1;
% second EOG-related channel
cheog2=nch_eeg+2;

% epochs start latency
epo_st=-0.4;
% epochs end latency
epo_end=3;

% baseline correction start latency
bc_st=-400;
% baseline correction end latency
bc_end=-12;

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
