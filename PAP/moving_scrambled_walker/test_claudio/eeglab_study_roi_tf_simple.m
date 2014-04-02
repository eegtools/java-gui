function [ersp times freqs pcond, pgroup, pinter] = eeglab_study_roi_tf_simple(STUDY, ALLEEG, channels_list, levels_f1, levels_f2,num_permutations,masked_times_max,paired,stat_method)

% function [ersp times freqs pcond, pgroup, pinter] = eeglab_study_roi_tf_simple(STUDY, ALLEEG, channels_list, levels_f1, levels_f2,correction,study_ls,num_permutations)
% calculate ersp in the channels corresponding to the selected roi and perform statistics	
% STUDY is an EEGLab study. 
% ALLEEG is an EEGLab structure containing all EEG in the STUDY. 
% channels_list is a cell array with a list of channels (usually the channels of a ROI). 
% levels_f1 are the levels of the first factor in the selected STUDY design. 
% levels_f2 are the levels of the second factor in the selected STUDY design. 
% correction is a EEGLab statistical correction for multiple comparisons.
% study_ls is the LS chosen for the analysis.
% num_permutations il the number of permutations chosen for the analysis.  
% masked_times_max is a time threshold (in ms): only times > masked_times_max will be considered for statistics on time-frequency representation.
    
    [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',channels_list,'noplot','on','method', stat_method);
   
    for nf1=1:length(levels_f1)
        for nf2=1:length(levels_f2)
            ersp{nf1,nf2} = squeeze(mean(ersp{nf1,nf2},3));
        end
    end
    
%     [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp,'groupstats','on','condstats','on','mcorrect',correction,'threshold',study_ls,'naccu',num_permutations,'method', stat_method,'paired',paired);
    
    [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp,'groupstats','on','condstats','on','mcorrect','none','threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired);          
    for ind = 1:length(pcond),  pcond{ind}  =  abs(pcond{ind}) ; end;
    for ind = 1:length(pgroup),  pcond{ind}  =  abs(pgroup{ind}) ; end;
    for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end;


if ~ isempty(masked_times_max)
         [pcond, pgroup, pinter] = eeglab_study_roi_tf_maskp(pcond, pgroup, pinter,times, masked_times_max);              
    end
    
end