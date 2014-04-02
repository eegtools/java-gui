 function [] = eeglab_study_roi_tf_topo_graph(STUDY, design_num, ersp_topo,caxis, locs, name_f1, name_f2, levels_f1,levels_f2,time_window_name, frequency_band_name, pcond, pgroup, pinter,study_ls, correction, plot_dir)
  

     titles=eeglab_study_set_subplot_titles(STUDY,design_num); 
          
     % if required, correct for multiple comparisons    
     for ind = 1:length(pcond),  pcond{ind}  =  mcorrect(pcond{ind},correction) ; end;    
     for ind = 1:length(pgroup),  pgroup{ind}  =  mcorrect(pgroup{ind},correction) ; end;
     for ind = 1:length(pinter),  pinter{ind}  =  mcorrect(pinter{ind},correction) ; end;
     
     % if required, apply a significance treshold    
     if ~isnan(study_ls)
        for ind = 1:length(pcond),  pcond{ind}  =  abs(pcond{ind}<study_ls) ; end;
        for ind = 1:length(pgroup),  pgroup{ind}  =  abs(pgroup{ind}<study_ls) ; end;
        for ind = 1:length(pinter),  pinter{ind}  =  abs(pinter{ind}<study_ls) ; end;
     end

%      std_plotcurve_erp_tw(times, erp_curve, plot_dir, roi_name, study_ls, time_windows_design_names, name_f1, name_f2, levels_f1,levels_f2, ...
%          'groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'titles',titles  ,'threshold',study_ls,'plotgroups','apart' ,'plotconditions','apart');
%  
     std_chantopo_tf(ersp_topo, plot_dir, time_window_name, frequency_band_name, name_f1, name_f2, levels_f1,levels_f2,...
         'groupstats', pgroup, 'condstats', pcond, 'interstats', pinter, 'caxis', caxis, 'chanlocs', locs, 'threshold', study_ls, 'titles', titles);


 end