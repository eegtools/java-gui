[STUDY ersp9 times freqs]=std_erspplot(STUDY,ALLEEG,'channels',{'F3', 'C3'},'noplot','on');
fmin=4;
fmax=8;
sel_freqs = freqs >= fmin & freqs <= fmax;
bandname='Theta'


roi='RA';
name_f1=STUDY.design(9).variable(1).label;
name_f2=STUDY.design(9).variable(2).label;

levels_f1=STUDY.design(9).variable(1).value;
levels_f2=STUDY.design(9).variable(2).value;



 % averaging channels in the roi     
        for nf1=1:length(levels_f1)
            for nf2=1:length(levels_f2)
                 ersp9_2{nf1,nf2}=squeeze(mean(ersp9{nf1,nf2},3));
            end
        end
        


% total number of levels in factors
[tlf1, tlf2]=size(ersp9_2);

for nf1=1:tlf1
    for nf2=1:tlf2
        pattern_ersp9{nf1,nf2}=squeeze((mean(ersp9_2{nf1,nf2}(sel_freqs,:,:,:),1)));
%         if nf1==1& nf2==2
%         pattern_ersp9{nf1,nf2}=pattern_ersp9{nf1,nf2};
%         end
    end
end



titles={};
p_titles1={};
p_titles2={};

for nf1=1:length(levels_f1)
    for nf2=1:length(levels_f2)
        ersp_titles{nf1,nf2}=char([levels_f2{nf2} ', ' levels_f1{nf1} ]);
    end

end

for nstat=1:nf1
    p_titles1{nstat}=char(['P(within ', levels_f1{nstat},')']);
end
p_titles1=[p_titles1,'P(interaction)'];

for nstat=1:(nf2)
     p_titles2{nstat}=char(['P(within ', levels_f2{nstat},')']);
end
 titles=[ersp_titles;   p_titles2];
  titles=[titles,   p_titles1'];
  
   % set representation to time-frequency representation
    STUDY = pop_erpparams(STUDY, 'topotime',[] ,'plotgroups','apart' ,'plotconditions','apart','averagechan','on');

   [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat(pattern_ersp9,'groupstats','on','condstats','on','mcorrect','holms','alpha',0.05,'naccu',2000)
   std_plotcurve_ersp(times, pattern_ersp9,'plotgroups','apart' ,'plotconditions','apart', 'groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'titles',titles ,'threshold',0.05 );
%    ,'threshold',0.05
%  std_plotcurve_ersp(times, pattern_ersp9, 'groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'titles',titles  ,'threshold',0.05);
%  
%  suptitle([bandname ' ERSP in ' roi,': ', name_f1 ' and ' name_f2 ])