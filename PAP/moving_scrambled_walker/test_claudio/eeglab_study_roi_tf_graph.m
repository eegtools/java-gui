 function [] = eeglab_study_roi_tf_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, ersp, times, freqs, pcond, pgroup, pinter, caxis,study_ls, correction, plot_dir)
    
    titles=eeglab_study_set_subplot_titles(STUDY,design_num);
    
    % if required, correct for multiple comparisons    
    for ind = 1:length(pcond),  pcond{ind}  =  mcorrect(pcond{ind},correction) ; end;    
    for ind = 1:length(pgroup),  pgroup{ind}  =  mcorrect(pgroup{ind},correction) ; end;
    for ind = 1:length(pinter),  pinter{ind}  =  mcorrect(pinter{ind},correction) ; end;
    
    % if required, apply a significance treshold    
    if ~isnan(study_ls)
        for ind = 1:length(pcond),  pcond{ind}  =  pcond{ind}<study_ls ; end;
        for ind = 1:length(pgroup),  pgroup{ind}  =  pgroup{ind}<study_ls ; end;
        for ind = 1:length(pinter),  pinter{ind}  =  pinter{ind}<study_ls ; end;
    end
      
    % plot ersp and statistics 
    std_plottf_tf(times, freqs, ersp,plot_dir,roi_name, name_f1, name_f2, levels_f1,levels_f2, 'datatype', 'ersp','groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'plotmode','normal','titles',titles ,'tftopoopt',{'mode', 'ave'},'caxis',caxis ,'threshold',study_ls);

 end