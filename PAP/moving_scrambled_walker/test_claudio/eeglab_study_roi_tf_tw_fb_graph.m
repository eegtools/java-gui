 function [] = eeglab_study_roi_tf_tw_fb_graph(STUDY, design_num, roi_name, name_f1, name_f2, levels_f1,levels_f2, ersp, times, freqs, pcond, pgroup, pinter, caxis,study_ls, time_windows_names, frequency_bands_names,plot_dir )
     
     titles=eeglab_study_set_subplot_titles(STUDY,design_num);    

     % plot ersp and statistics
     std_plottf_tw_fb(times, freqs, ersp, time_windows_names, frequency_bands_names , plot_dir,roi_name, name_f1, name_f2, levels_f1,levels_f2,'datatype', 'ersp','groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'plotmode','normal','titles',titles ,'tftopoopt',{'mode', 'ave'},'caxis',caxis ,'threshold',study_ls);

 end