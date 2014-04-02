design_num=2;
nroi=1;
channels_list={'C3'};
study_ls=0.025;
num_permutations=200;

levels_f1=STUDY.design(design_num).variable(1).value;
levels_f2=STUDY.design(design_num).variable(2).value;

 stats=STUDY.etc.statistics


% [STUDY ersp1 times freqs pgroup1 pcond1 pinter1]=std_erspplot(STUDY,ALLEEG,'channels',channels_list,'noplot','off','method', 'bootstrap','mcorrect','none','naccu',2000,'groupstats','on','condstats','on','threshold',study_ls);
[STUDY ersp2 times2 freqs2 pgroup2 pcond2 pinter2]=std_erspplot(STUDY,ALLEEG,'channels',channels_list,'noplot','off','method', 'bootstrap','mcorrect','none','naccu',num_permutations,'groupstats','on','condstats','on','alpha',NaN);

%  [pcond3, pgroup3, pinter3, statscond3, statsgroup3, statsinter3] = std_stat(ersp2,stats);

[pcond3, pgroup3, pinter3, statscond3, statsgroup3, statsinter3] = std_stat(ersp2,'method', 'bootstrap','mcorrect','none','naccu',num_permutations,'groupstats','on','condstats','on','alpha',NaN,'paired',{'on'})
 std_plottf(times2, freqs2, ersp2,'condstats',pcond3)

 
 for ind = 1:length(pcond2),  pcond4{ind}  = mcorrect( pcond2{ind} , 'fdr' ); end;
 std_plottf(times2, freqs2, ersp2,'condstats',pcond4)
 
 
% [pcond2, pgroup2, pinter2, statscond2, statsgroup2, statsinter2] = std_stat(ersp1,'groupstats','on','condstats','on','threshold',study_ls,'method', 'bootstrap','mcorrect','fdr','naccu',100);
% % 
% [pcond3, pgroup3, pinter3, statscond3, statsgroup3, statsinter3] = std_stat(ersp1,'condstats','on','threshold',study_ls,'method', 'bootstrap','mcorrect','none','naccu',2000);
% [pcond4, pgroup4, pinter4, statscond4, statsgroup4, statsinter4] = std_stat(ersp1,'condstats','on','threshold',study_ls,'method', 'bootstrap','mcorrect','none','naccu',2000);
% 
% 
%     for nf1=1:length(levels_f1)
%         for nf2=1:length(levels_f2)
%             ersp{nf1,nf2} = mean(ersp1{nf1,nf2},3);
%         end
%     end
%     
%     [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat(ersp,'groupstats','on','condstats','on','threshold',study_ls,'naccu',num_permutations,'method', 'bootstrap','mcorrect','fdr');
% 
%  std_plottf(times, freqs, ersp,'condstats',pcond,'threshold',study_ls)
%  std_plottf(times, freqs, ersp1,'condstats',pcond1,'threshold',study_ls)
%  std_plottf(times, freqs, ersp1,'condstats',pcond3,'threshold',study_ls,'caxis',[-2.2,2.2])
%  std_plottf(times, freqs, ersp1,'condstats',pcond4,'threshold',study_ls)
% compute correction for multiple comparisons
% -------------------------------------------
      
        
