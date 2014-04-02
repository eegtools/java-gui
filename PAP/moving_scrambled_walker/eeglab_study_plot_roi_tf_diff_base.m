function [STUDY, EEG] = eeglab_study_plot_roi_tf_diff_base(settings_path,study_path, design_num, design_time_windows_list,frequency_bands_list,roi_list,nroi)

% load configuration file
[path,name_noext,ext] = fileparts(settings_path);
addpath(path);    eval(name_noext);

[study_path,study_name_noext,study_ext] = fileparts(study_path);    

% start EEGLab
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

% load the study and working with the study structure 
[STUDY ALLEEG] = pop_loadstudy( 'filename',[study_name_noext study_ext],'filepath',study_path);

% select the study design for the analyses
STUDY = std_selectdesign(STUDY, ALLEEG, design_num);
figure();

STUDY = pop_erspparams(STUDY, 'topotime',[] ,'topofreq', []);
[STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');

%number of levels of factor 1 and 2
[nl_f1,nl_f2]=size(ersp);



end