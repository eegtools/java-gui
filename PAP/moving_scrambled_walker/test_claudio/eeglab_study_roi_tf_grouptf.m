function [STUDY ersp times freqs pcond, pgroup, pinter] = eeglab_study_roi_tf_grouptf(STUDY, ALLEEG,  channels_list, levels_f1, levels_f2,num_grouped_times,num_grouped_freqs,num_permutations, masked_times_max,paired,stat_method)

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
    STUDY = pop_statparams(STUDY, 'groupstats','off','condstats','off');
    [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',channels_list,'noplot','on','method', stat_method);
   
    
    for nf1=1:length(levels_f1)
        for nf2=1:length(levels_f2)
            M=squeeze(mean(ersp{nf1,nf2},3));
            [total_freqs, total_times, total_subjects]= size(M);
            final_freqs_mat=fix(total_freqs/num_grouped_freqs);
            final_times_mat=fix(total_times/num_grouped_times);
            fixed_freqs=num_grouped_freqs*final_freqs_mat;
            fixed_times=num_grouped_times*final_times_mat;
            M=M(1:fixed_freqs,1:fixed_times,:);
            tmp_freqs_mat = reshape(M, [num_grouped_freqs final_freqs_mat  fixed_times total_subjects]);
            tmp_freqs_mat = squeeze(mean(tmp_freqs_mat));
            matrix_avg_freqs = reshape(tmp_freqs_mat, [final_freqs_mat fixed_times total_subjects]);
            tmp_times_mat =  reshape(matrix_avg_freqs, [final_freqs_mat num_grouped_times final_times_mat total_subjects]);
            tmp_times_mat = squeeze(mean(tmp_times_mat,2));
            ersp{nf1,nf2} = reshape(tmp_times_mat, [ final_freqs_mat final_times_mat total_subjects]);
        end
    end
    tmp_times_vec=reshape(times(1:fixed_times),num_grouped_times, final_times_mat);
    times= mean(tmp_times_vec);
    
    tmp_freqs_vec=reshape(freqs(1:fixed_freqs),num_grouped_freqs, final_freqs_mat);
    freqs= mean(tmp_freqs_vec);
      
%     [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp,'groupstats','on','condstats','on','mcorrect',correction,'threshold',study_ls,'naccu',num_permutations,'method', stat_method,'paired',paired);          
    
    [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp,'groupstats','on','condstats','on','mcorrect','none','threshold',NaN,'naccu',num_permutations,'method', stat_method,'paired',paired);          
    for ind = 1:length(pcond),  pcond{ind}  =  abs(pcond{ind}) ; end;
    for ind = 1:length(pgroup),  pcond{ind}  =  abs(pgroup{ind}) ; end;
    for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}) ; end;
    
    if ~ isempty(masked_times_max)
         [pcond, pgroup, pinter] = eeglab_study_roi_tf_maskp(pcond, pgroup, pinter,times, masked_times_max);              
    end
    
    
    
end