function [STUDY, EEG] = eeglab_study_plot_roi_tf_curve2(settings_path,study_path, design_num, roi_list, roi_names,frequency_bands_list,frequency_bands_names ,time_windows_design,time_windows_design_names, study_ls,num_permutations,correction,timerange,masked_times_max,plot_dir,paired,stat_method) 
% function [STUDY, EEG] = eeglab_study_plot_roi_tf_curve(settings_path,study_path, design_num, roi_list, roi_names,frequency_bands_list,frequency_bands_names ,study_ls,num_permutations,correction,timerange,num_grouped_times, time_windows_design,masked_times_max,plot_dir)

% function [STUDY, EEG] = eeglab_study_plot_roi_tf_curve(settings_path,study_path, design_num, roi_list, roi_names,frequency_bands_list,frequency_bands_names ,study_ls,num_permutations,correction)
% calculates and displayes ersp for a single roi in a frequancy band as a time series for a STUDY (i.e. for a group of subjects) with statistical comparisons based on the factors in the selected design.
% settings_path is the full path of the file containing the project configurations.
% study_path is the full path of the file containing the study to be analyzed.
% design_num is the number of the STUDY design to be processed.
% roi_list is the the cell array containing the list of channels for each roi. 
% roi_names is the cell array containing the list of the roi names.
% frequency_bands_list is the list of frequancy bands (a cell array of vectors [fmin fmax] for each band)
% frequency_bands_names is the list (cell array) of names for all frequency
% bands.
% study_ls is the level of significance for the statistical analysis.
% num_permutations is the number of permutations performed in the statistical analysis.
% correction is the statistical correction for multiple comparisons ('bonferoni', 'holms', 'fdr').
% timerange is the range of times to be represented
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
   
    % set representation to time-frequency representation
    STUDY = pop_erspparams(STUDY, 'topotime',[] ,'topofreq', [],'timerange',timerange);
    
    % select the study design for the analyses
    STUDY = std_selectdesign(STUDY, ALLEEG, design_num);
    
    study_des = STUDY.design(design_num);
%     save(fullfile(plot_dir,'study_des.mat'),'study_des');
    ersp_curve_stat.study_des=study_des;  
    ersp_curve_stat.roi_names=roi_names;
    ersp_curve_stat.roi_names=frequency_bands_names;          
    
    name_f1=STUDY.design(design_num).variable(1).label;
    name_f2=STUDY.design(design_num).variable(2).label;
    
    levels_f1=STUDY.design(design_num).variable(1).value;
    levels_f2=STUDY.design(design_num).variable(2).value;

    
    % for each roi in the list     
    for nroi = 1:length(roi_names)
        roi_channels=roi_list{nroi};
        roi_name=roi_names{nroi};
        STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off','method', stat_method);
        
        % calculate ersp in the channels corresponding to the selected roi	
        [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');
       
        % averaging channels in the roi     
        for nf1=1:length(levels_f1)
            for nf2=1:length(levels_f2)
                ersp_roi{nf1,nf2}=squeeze(mean(ersp{nf1,nf2},3));
            end
        end
       
        for nband=1:length(frequency_bands_list)
            
            fmin=frequency_bands_list{nband}(1);
            fmax=frequency_bands_list{nband}(2);
            sel_freqs = freqs >= fmin & freqs <= fmax;
            
            % selecting and averaging powers in a frequency band 
            for nf1=1:length(levels_f1)
               for nf2=1:length(levels_f2)
                    ersp_curve{nf1,nf2}=squeeze((mean(ersp_roi{nf1,nf2}(sel_freqs,:,:),1)));
               end
            end
            
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
                            M=ersp_curve{nf1,nf2};                         
                            M2(nwin,:)=mean(M(sel_times,:),1);
                       end
                       ersp_curve{nf1,nf2}=M2;
                   end
                end
           end
            
            % calculate statistics        
            [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp_curve,'groupstats','on','condstats','on','mcorrect','none','threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired);          
            for ind = 1:length(pcond),  pcond{ind}  =  abs(pcond{ind}) ; end;
            for ind = 1:length(pgroup),  pcond{ind}  =  abs(pgroup{ind}) ; end;
            for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end;
           
            times_plot=times;
            
          
           
            if ~isempty(time_windows_design)                
                times_plot=1:size(ersp_curve{1},1);                
                eeglab_study_roi_tf_tw_fb_curve_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, ersp_curve, times_plot, frequency_bands_names{nband},time_windows_design_names, pcond, pgroup, pinter,study_ls,correction,plot_dir);
            else
                if ~ isempty(masked_times_max)
                    [pcond, pgroup, pinter] = eeglab_study_roi_curve_maskp(pcond, pgroup, pinter,times_plot, masked_times_max);              
                end
                eeglab_study_roi_tf_curve_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, ersp_curve, times_plot, frequency_bands_names{nband}, pcond, pgroup, pinter,study_ls,correction,plot_dir)
            end
              
              
              ersp_curve_stat(nroi).frequency_band(nband).roi_channels=roi_channels;
              ersp_curve_stat(nroi).frequency_band(nband).roi_name=roi_name;
              ersp_curve_stat(nroi).frequency_band(nband).frequency_band_name=frequency_bands_names{nband};
              ersp_curve_stat(nroi).frequency_band(nband).ersp_curve=ersp_curve;
              ersp_curve_stat(nroi).frequency_band(nband).times=times;          
              ersp_curve_stat(nroi).frequency_band(nband).pcond=pcond;
              ersp_curve_stat(nroi).frequency_band(nband).pgroup=pgroup;
              ersp_curve_stat(nroi).frequency_band(nband).pinter=pinter;
              save(fullfile(plot_dir,'ersp_curve-stat.mat'),'ersp_curve_stat'); 

        end
    end
end