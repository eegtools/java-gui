function [STUDY, EEG] = eeglab_study_plot_roi_erp(study_path, design_num, roi_list, roi_names, design_time_windows_list,show_statistics,time_range,study_ls, settings_path,lm)

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
	
    switch show_statistics
        case 'on'
            STUDY = pop_statparams(STUDY, 'condstats',show_statistics, 'groupstats',show_statistics,'alpha',study_ls,'naccu',num_permutations,'method', stat_method,'mcorrect',correction);
        case 'off'
            STUDY = pop_statparams(STUDY, 'condstats',show_statistics);
    end
    %settaggio parametri plot serie temporale erp di ciascuna roi
    STUDY = pop_erpparams(STUDY, 'ylim',ylim_plot,'averagechan','on','filter',filter_freq,'topotime',[],'plotconditions','together','timerange', time_range);
    totroi=length(roi_list);
    
    if lm
        %per ogni roi plotta la serie temporale dell'erp
        for nroi=1:totroi
%             STUDY = std_erpplot_lm(STUDY,ALLEEG,'channels',roi_list{nroi}, 'plotstderr','on');
            aa=STUDY.design(design_num).variable.value;
            nleg=[aa];
            [STUDY erpdata erptimes pgroup pcond pinter] =std_erpplot_lm(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on')
            std_plotcurve_lm( erptimes, erpdata,'plotconditions','together','plotdiff','on','legend',nleg,'filter',10,'ylim',ylim_plot,'condstats',pcond,'threshold',study_ls', 'plotstderr','on')
            title(['ERP  in the ' roi_names{nroi}])
            
        end
    end
    if ~lm
        %per ogni roi plotta la serie temporale dell'erp
        for nroi=1:totroi
%             STUDY = std_erpplot(STUDY,ALLEEG,'channels',roi_list{nroi});
            aa=STUDY.design(design_num).variable.value;
            nleg=[aa];
            [STUDY erpdata erptimes pgroup pcond pinter] =std_erpplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on')
            std_plotcurve( erptimes, erpdata,'plotconditions','together','plotdiff','on','legend',nleg,'filter',10,'ylim',ylim_plot,'condstats',pcond,'threshold',study_ls')
            title(['ERP  in the ' roi_names{nroi}])
        end        
    end
    
    % std_plotcurve(erptimes, erpdata,'plotstderr','on', 'plotconditions','together','filter',filter_freq,'legend','on')

        
    for nwindow=1:length(design_time_windows_list)
        STUDY = pop_erpparams(STUDY, 'averagechan','off','topotime',  design_time_windows_list{nwindow} );
        STUDY = std_erpplot(STUDY,ALLEEG,'channels',{STUDY.changrp.name});
    end
    
    