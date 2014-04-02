
roi_list={{'F7','F3','FC5','FC1','C3'}; ... LEFT ANTERIOR(LA)
          {'F8','F4','FC6','FC2','C4'}; ... RIGHT ANTERIOR(RA)
          {'Fz','Cz'}; ... MIDLINE ANTERIOR(MA)
          {'CP1','CP5','P3','P7','PO9','O1'}; ... LEFT POSTERIOR(LP)
          {'CP2','CP6','P4','P8','PO10','O2'}; ... LEFT POSTERIOR(RP)
          {'Pz','Oz'} ... MIDLINE POSTERIOR(MP)
          
          {'TP9','T7'}; ... LEFT TEMPORO-PARIETAL(LTP)
          {'TP10','T8'}; ... RIGHT TEMPORO-PARIETAL(RTP)
          
};
%frequenza del passa-basso x lo smoothing
filter_freq=10;
%limite inferiore e superiore in uV per l'asse y
ylim_plot=[-2.5 2.5];
%limiti temporali per la rappresentazione dell'erp come mappa
tlim_plot=[400 600];
time_range=[-200 1000];
study_ls=0.01;
num_permutations=100;
stat_method='permutation';
correction='bonferroni';






STUDY = pop_statparams(STUDY, 'alpha',study_ls,'naccu',num_permutations,'method', stat_method,'mcorrect',correction);
%settaggio parametri plot serie temporale erp di ciascuna roi
STUDY = pop_erpparams(STUDY, 'ylim',ylim_plot,'averagechan','on','filter',filter_freq,'topotime',[],'timerange' time_range);
totroi=length(rol_list);
%per ogni roi plotta la serie temporale dell'erp
for nroi=1:totroi
    STUDY = std_erpplot(STUDY,ALLEEG,'channels',roi_list{nroi});
end

STUDY = pop_erpparams(STUDY, 'averagechan','off','topotime',tlim_plot );
STUDY = std_erpplot(STUDY,ALLEEG,'channels',{STUDY.changrp.name});