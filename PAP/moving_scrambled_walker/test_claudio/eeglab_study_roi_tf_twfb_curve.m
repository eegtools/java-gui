function [STUDY ersp times freqs pcond, pgroup, pinter] = eeglab_study_roi_tf_twfb_curve(STUDY, ALLEEG,  channels_list, levels_f1, levels_f2,time_windows,frequency_bands,correction,study_ls,num_permutations, masked_times_max)

% function [ersp times freqs pcond, pgroup, pinter] = eeglab_study_roi_tf_grouptf(STUDY, ALLEEG, channels_list, levels_f1, levels_f2,num_grouped_times,num_grouped_freqs,correction,study_ls,num_permutations)
% calculate ersp in the channels corresponding to the selected roi grouping times (obtaineing a time-frequency representation with a lowered time resolution) and perform statistics	
% STUDY is an EEGLab study. 
% ALLEEG is an EEGLab structure containing all EEG in the STUDY. 
% channels_list is a cell array with a list of channels (usually the channels of a ROI). 
% levels_f1 are the levels of the first factor in the selected STUDY design. 
% levels_f2 are the levels of the second factor in the selected STUDY design. 
% num_grouped_times is the number of times to be grouped by averaging.
% num_grouped_freqs is the number of frequencies to be grouped by averaging.
% correction is a EEGLab statistical correction for multiple comparisons.
% study_ls is the LS chosen for the analysis.
% num_permutations il the number of permutations chosen for the analysis.  
% masked_times_max is a time threshold (in ms): only times > masked_times_max will be considered for statistics on time-frequency representation.

STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off','method', 'bootstrap');
[STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',channels_list,'noplot','on');
   
    
    for nf1=1:length(levels_f1)
        for nf2=1:length(levels_f2)
            M=squeeze(mean(ersp{nf1,nf2},3));
            [total_freqs, total_times, total_subjects]= size(M);
            final_freqs_mat=length(frequency_bands);
            final_times_mat=length(time_windows);
            M2=zeros(final_freqs_mat, final_times_mat , total_subjects);
            
            for nfb=1:final_freqs_mat %for each frequency band
                for ntw=1:final_times_mat %for each time window
                    sel_f = freqs >= frequency_bands(nfb,1) & freqs <= frequency_bands(nfb,2);
                    sel_t = times >= time_windows{ntw}(1) & times <= time_windows{ntw}(2);
                    M2(nfb,ntw,:) = mean(mean(M(sel_f ,sel_t,:)));
                end %for each time window
            end %for each frequency band
        ersp{nf1,nf2}=M2;
        end
        
    end
    
    times=1:final_times_mat;
    freqs=1:final_freqs_mat;
    
 [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp,'groupstats','on','condstats','on','mcorrect',correction,'threshold',study_ls,'naccu',num_permutations); 
    
end