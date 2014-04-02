function [ersp times freqs pcond, pgroup, pinter] = eeglab_study_roi_tf_curve_simple(STUDY, ALLEEG, channels_list, frequency_bands_list, levels_f1, levels_f2,correction,study_ls,num_permutations,masked_times_max)
% function [] = eeglab_study_roi_tf_curve_simple(STUDY, ALLEEG, channels_list, frequency_bands_list, levels_f1, levels_f2,correction,study_ls,num_permutations,masked_times_max)

% function [] = eeglab_study_roi_tf_curve_simple(STUDY, ALLEEG, channels_list)
 
% calculate ersp in the channels corresponding to the selected roi	
        [STUDY ersp times freqs]=std_erspplot(STUDY,ALLEEG,'channels',channels_list,'noplot','on');
%        ersp_curve=ersp
%        size(ersp)
%        size(ersp_curve)
%        
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
            
            % calculate statistics
            [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat_corr(ersp_curve,'groupstats','on','condstats','on','mcorrect',correction,'threshold',study_ls,'naccu',num_permutations);          
        
            if ~ isempty(masked_times_max)
                [pcond, pgroup, pinter] = eeglab_study_roi_curve_maskp(pcond, pgroup, pinter,times, masked_times_max);              
            end
            


end