% List of open inputs
nrun = 1; % enter the number of runs here
jobfile = { '/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/moving_scrambled_walker/batches/4mm/OCICA_250_cleanica/wmne_free_vol/MOTION_wmne_free_vol_P100_2ttest_job.m' '/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/moving_scrambled_walker/batches/4mm/OCICA_250_cleanica/wmne_free_vol/MOTION_wmne_free_vol_N200_2ttest_job.m' '/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/moving_scrambled_walker/batches/4mm/OCICA_250_cleanica/wmne_free_vol/MOTION_wmne_free_vol_P330_2ttest_job.m' '/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/moving_scrambled_walker/batches/4mm/OCICA_250_cleanica/wmne_free_vol/MOTION_wmne_free_vol_N400_2ttest_job.m' '/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/moving_scrambled_walker/batches/4mm/OCICA_250_cleanica/wmne_free_vol/MOTION_wmne_free_vol_P500_2ttest_job.m' '/data/behavior_lab_svn/behaviourPlatform/EEG_Tools/moving_scrambled_walker/batches/4mm/OCICA_250_cleanica/wmne_free_vol/MOTION_wmne_free_vol_N600_2ttest_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
addpath(genpath('/data/matlab_toolbox/spm8'));
spm('defaults', 'FMRI');
spm_jobman('serial', jobs, '', inputs{:});

exit
