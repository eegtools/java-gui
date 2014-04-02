 function [] = eeglab_study_roi_tf_curve_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, ersp_curve, times, frequency_band_name, pcond, pgroup, pinter,study_ls,correction,plot_dir,display_only_significant)
  
     titles=eeglab_study_set_subplot_titles(STUDY,design_num);    
     
     % if required, correct for multiple comparisons    
     for ind = 1:length(pcond),  pcond{ind}  =  mcorrect(pcond{ind},correction) ; end;    
     for ind = 1:length(pgroup),  pgroup{ind}  =  mcorrect(pgroup{ind},correction) ; end;
     for ind = 1:length(pinter),  pinter{ind}  =  mcorrect(pinter{ind},correction) ; end;
     
     % if required, apply a significance treshold    
     if display_only_significant=='on'
        for ind = 1:length(pcond),  pcond{ind}  =  abs(pcond{ind}<study_ls) ; end;
        for ind = 1:length(pgroup),  pgroup{ind}  =  abs(pgroup{ind}<study_ls) ; end;
        for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}<study_ls) ; end;
     end

     
     

     % plot ersp and statistics
     std_plotcurve_ersp(times, ersp_curve,plot_dir, roi_name, frequency_band_name, name_f1, name_f2, levels_f1,levels_f2, ...
         'groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'titles',titles  ,'threshold',study_ls);          
 end
