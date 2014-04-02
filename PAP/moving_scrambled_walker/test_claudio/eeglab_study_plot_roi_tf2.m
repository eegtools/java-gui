function [STUDY, EEG] = eeglab_study_plot_roi_tf2(settings_path,study_path, design_num, design_time_windows_list,frequency_bands_list,roi_list)

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
    nn=1;
% plot average time frequency representation for each roi in roi_list and each condition in designs_list{design_num}
%     subplot(length(roi_list),length(designs_list{design_num}{1}),1);
    for nroi=1:length(roi_list)
        all_ersp=[];
        STUDY = pop_erspparams(STUDY, 'topotime',[] ,'topofreq', []);
        [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');
         for ncond=1:length(designs_list{design_num}{1})
            all_ersp(ncond,:,:,:,:)=ersp{ncond};           
         end
         % avaraging channels of the roi
         all_ersp_cond=squeeze(mean(all_ersp,4));          
         for ncond=1:length(designs_list{design_num}{1})                          
             ersp_cond=squeeze(all_ersp_cond(ncond,:,:,:));
             pvals = std_stat({ ersp_cond zeros(size(ersp_cond)) }', 'method', 'permutation', 'condstats', 'on', 'mcorrect', 'fdr');
             tmpersp = mean(ersp_cond,3); % average ERSP for all subjects
             tmpersp(pvals{1} > 0.05) = 0; % zero out non-significant values             
             subplot(length(roi_list),length(designs_list{design_num}{1}),nn);
             imagesc(times, freqs,tmpersp,[-4 4]); 
             line([0,0],[1,40],'LineStyle','--');
             strcond='[ ';
             for nc=1:length(designs_list{design_num}{1}{ncond})
                str=char(designs_list{design_num}{1}{ncond}{nc});
                strcond=[strcond,str,' '];
             end
             strcond=[strcond,']'];
             
             title([roi_names{nroi} ' '  strcond]); 
             set(gca, 'ydir', 'normal'); 
             xlabel('Time (ms)'); 
             ylabel('Frequencies (Hz)'); 
             if nroi==length(roi_list) && ncond==length(designs_list{design_num}{1})
                h=cbar;
                title(h, 'Power (dB)');
             end
             nn=nn+1;
         end
    end
    
    
    % if and only the design compare 2 conditions perform a direct
    % comparison (using the difference between conditions)
    if length(designs_list{design_num}{1})==2  
    nn=1; 
    	figure();
        for nroi=1:length(roi_list)
        all_ersp=[];
        STUDY = pop_erspparams(STUDY, 'topotime',[] ,'topofreq', []);
        [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',roi_list{nroi},'noplot','on');
         for ncond=1:length(designs_list{design_num}{1})
            all_ersp(ncond,:,:,:,:)=ersp{ncond};           
         end
         % avaraging channels of the roi
         all_ersp_cond=squeeze(mean(all_ersp,4)); 
%          for ncond=1:length(designs_list{design_num}{1})                                             
             % avaraging channels of the roi
             all_ersp_cond=squeeze(mean(all_ersp,4));          
             ersp_cond1=squeeze(all_ersp_cond(1,:,:,:));
             ersp_cond2=squeeze(all_ersp_cond(2,:,:,:));
             ersp_cond21=ersp_cond2-ersp_cond1;
             %testing the hypothesis that the difference between conditions
             %is mdofied by the trigger event (comparing the difference in post-trigger with the difference in the pre-trigger ) 
             pvals = std_stat({ ersp_cond21 zeros(size(ersp_cond21)) }', 'method', 'permutation', 'condstats', 'on', 'mcorrect', 'fdr');
             tmpersp = mean(ersp_cond21,3); % average ERSP for all subjects
             tmpersp(pvals{1} > 0.05) = 0; % zero out non-significant values             
             subplot(length(roi_list),1,nn);
             imagesc(times, freqs,tmpersp,[-2 2]); 
             line([0,0],[1,40],'LineStyle','--');
             strcond1='[ ';
             for nc=1:length(designs_list{design_num}{1}{1})
                str=char(designs_list{design_num}{1}{1}{nc});
                strcond1=[strcond1,str,' '];
             end
               strcond1=[strcond1,']'];
             
             strcond2='[ ';
             for nc=1:length(designs_list{design_num}{1}{2})
                str=char(designs_list{design_num}{1}{2}{nc});
                strcond2=[strcond2,str,' '];
             end
             strcond2=[strcond2,']'];
             
             strcomp_cond=[strcond2, ' vs ' strcond1];
             
             title([roi_names{nroi} ' '  strcomp_cond]); 
             set(gca, 'ydir', 'normal'); 
             xlabel('Time (ms)'); 
             ylabel('Frequencies (Hz)'); 
             if nroi==length(roi_list) && ncond==length(designs_list{design_num}{1})
                h=cbar;
                title(h, 'Power (dB)');
%              end
             
             end
         nn=nn+1;
        end
    end
%     
    
    

    % plot topo map of each band in frequency_bands_list in each time window in design_time_windows_list 
    STUDY = pop_statparams(STUDY, 'condstats','on', 'alpha',study_ls,'naccu',num_permutations,'method', stat_method,'mcorrect',correction);
    for nwindow=1:length(design_time_windows_list)
        for nband=1:length(frequency_bands_list)
                STUDY = pop_erspparams(STUDY, 'topotime',design_time_windows_list{nwindow} ,'topofreq', frequency_bands_list(nband,:));
                STUDY = std_erspplot(STUDY,ALLEEG,'channels',{STUDY.changrp.name});        
        end


    end
    
end