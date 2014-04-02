function [STUDY, EEG] = eeglab_study_plot_roi_tf(settings_path,study_path, design_num, design_time_windows_list,frequency_bands_list)

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
	
%     switch show_statistics
%         case 'on'
%             STUDY = pop_statparams(STUDY, 'condstats',show_statistics, 'alpha',study_ls,'naccu',num_permutations,'method', stat_method,'mcorrect',correction);
%         case 'off'
%             STUDY = pop_statparams(STUDY, 'condstats',show_statistics);
%     end
%     %settaggio parametri plot serie temporale erp di ciascuna roi
%     STUDY = pop_erpparams(STUDY, 'ylim',ylim_plot,'averagechan','on','filter',filter_freq,'topotime',[],'plotconditions','together','timerange', time_range);
%     totroi=length(roi_list);
%     %per ogni roi plotta la serie temporale dell'erp
%     for nroi=1:totroi
%         STUDY = std_erpplot(STUDY,ALLEEG,'channels',roi_list{nroi});
%     end
STUDY = pop_statparams(STUDY, 'condstats','on', 'alpha',study_ls,'naccu',num_permutations,'method', stat_method,'mcorrect',correction);



        
    for nwindow=1:length(design_time_windows_list)
        for nband=1:length(frequency_bands_list)
                STUDY = pop_erspparams(STUDY, 'topotime',design_time_windows_list{nwindow} ,'topofreq', frequency_bands_list(nband,:));
                STUDY = std_erspplot(STUDY,ALLEEG,'channels',{STUDY.changrp.name});        
        end
        
        
    end