[STUDY erp9 times freqs]=std_erpplot(STUDY,ALLEEG,'channels',{'F3'},'noplot','on');

roi='RA';
name_f1=STUDY.design(9).variable(1).label;
name_f2=STUDY.design(9).variable(2).label;

levels_f1=STUDY.design(9).variable(1).value;
levels_f2=STUDY.design(9).variable(2).value;


titles={};
p_titles1={};
p_titles2={};

for nf1=1:length(levels_f1)
    for nf2=1:length(levels_f2)
        erp_titles{nf1,nf2}=char([levels_f2{nf2} ', ' levels_f1{nf1} ]);
    end

end

for nstat=1:nf1
    p_titles1{nstat}=char(['P(within ', levels_f1{nstat},')']);
end
p_titles1=[p_titles1,'P(interaction)'];

for nstat=1:(nf2)
     p_titles2{nstat}=char(['P(within ', levels_f2{nstat},')']);
end
 titles=[erp_titles;   p_titles2]
  titles=[titles,   p_titles1']
 
 %  [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat(erp9,'groupstats','on','condstats','on','mcorrect','fdr','paired',{'on','on'})
 [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat(erp9,'groupstats','on','condstats','on','mcorrect','holms','threshold',0.05,'naccu',2000)
 std_plotcurve(times, erp9, 'groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'titles',titles  ,'threshold',0.05);
 suptitle(['ERP in ' roi,': ', name_f1 ' and ' name_f2 ])