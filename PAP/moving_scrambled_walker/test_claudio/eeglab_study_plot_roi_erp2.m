function [STUDY, EEG] = eeglab_study_plot_roi_erp2(settings_path,study_path, design_num, roi_list , roi_names,time_windows_design,time_windows_design_names, study_ls,num_permutations,correction,filter, masked_times_max,plot_dir,paired,stat_method)

% function [STUDY, EEG] = eeglab_study_plot_roi_erp(settings_path,study_path, design_num, roi_list, roi_names,study_ls,num_permutations,correction,filter)
% calculates and displays erp for a single roi in a STUDY (i.e. for a group of subjects) with statistical comparisons based on the factors in the selected design.
% settings_path is the full path of the file containing the project configurations.
% study_path is the full path of the file containing the study to be analyzed.
% design_num is the number of the STUDY design to be processed.
% roi_list is the the cell array containing the list of channels for each roi. 
% roi_names is the cell array containing the list of the roi names.
% study_ls is the level of significance for the statistical analysis.
% num_permutations is the number of permutations performed in the statistical analysis.
% correction is the statistical correction for multiple comparisons ('bonferoni', 'holms', 'fdr').
% filter is the frequency for the low-pass filter applied (ONLY FOR REPRESENTATION, NOT FOR STATISTICS) to the erp pattern. 
% masked_times_max is a time threshold: only times > masked_times_max will be considered for statistics on time-frequency representation.

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
    
     study_des = STUDY.design(design_num);     
%     save(fullfile(plot_dir,'study_des.mat'),'study_des');
     erp_curve_stat.study_des=STUDY.design(design_num);
     erp_curve_stat.roi_names=roi_names;     

    name_f1=STUDY.design(design_num).variable(1).label;
    name_f2=STUDY.design(design_num).variable(2).label;
    
    levels_f1=STUDY.design(design_num).variable(1).value;
    levels_f2=STUDY.design(design_num).variable(2).value;


    % set representation to time-frequency representation
    STUDY = pop_erpparams(STUDY, 'topotime',[] ,'plotgroups','apart' ,'plotconditions','apart','averagechan','on','method', stat_method);

   
     % for each roi in the list     
    for nroi = 1:length(roi_names)
        roi_channels=roi_list{nroi};
        roi_name=roi_names{nroi};
        STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off');
        [STUDY erp_curve times]=std_erpplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');
        
        
          if ~isempty(time_windows_design) 
               M=[];
               M2=[];
               % selecting and averaging powers in a time window 
                for nf1=1:length(levels_f1)
                   for nf2=1:length(levels_f2)
                       for nwin=1:length(time_windows_design)                           
                            tmin=time_windows_design{nwin}(1);
                            tmax=time_windows_design{nwin}(2);
                            sel_times = times >= tmin & times <= tmax ;    
                            M=erp_curve{nf1,nf2};                         
                            M2(nwin,:)=mean(M(sel_times,:),1);
                       end
                       erp_curve{nf1,nf2}=M2;
                   end
                end
           end
        
        
        % calculate statistics        
        [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(erp_curve,'groupstats','on','condstats','on','mcorrect','none','threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired);          
        for ind = 1:length(pcond),  pcond{ind}  =  abs(pcond{ind}) ; end;
        for ind = 1:length(pgroup),  pcond{ind}  =  abs(pgroup{ind}) ; end;
        for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end
        
        times_plot=times;
        
         if ~isempty(time_windows_design)                
                times_plot=1:size(erp_curve{1},1);                
                eeglab_study_roi_erp_tw_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, erp_curve, times_plot,time_windows_design_names, pcond, pgroup, pinter,study_ls,correction,plot_dir);
%                 eeglab_study_roi_erp_tw_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, erp_curve, times,time_windows_design,time_windows_design_names, pcond, pgroup, pinter,study_ls, correction,filter, plot_dir)
                %                 eeglab_study_roi_erp_graph(STUDY, design_num, roi_names{nroi}, name_f1, name_f2, levels_f1,levels_f2, erp_curve, times_plot, pcond, pgroup, pinter,study_ls,correction,filter,plot_dir)
         else
                if ~ isempty(masked_times_max)
                    [pcond, pgroup, pinter] = eeglab_study_roi_curve_maskp(pcond, pgroup, pinter,times_plot, masked_times_max);              
                end
                eeglab_study_roi_erp_graph(STUDY, design_num, roi_names{nroi}, name_f1, name_f2, levels_f1,levels_f2, erp_curve, times, pcond, pgroup, pinter,study_ls,correction,filter,plot_dir)
            
         end
              
        
       
        erp_curve_stat(nroi).roi_channels=roi_channels;
        erp_curve_stat(nroi).roi_name=roi_name;
        erp_curve_stat(nroi).erp=erp_curve;
        erp_curve_stat(nroi).times=times;        
        erp_curve_stat(nroi).pcond=pcond;
        erp_curve_stat(nroi).pgroup=pgroup;
        erp_curve_stat(nroi).pinter=pinter;        
    end
    save(fullfile(plot_dir,'erp_curve-stat.mat'),'erp_curve_stat');

end