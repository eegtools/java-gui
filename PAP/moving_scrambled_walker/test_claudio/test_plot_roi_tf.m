 [STUDY ersp9 times freqs]=std_erspplot(STUDY,ALLEEG,'channels',{'F3'},'noplot','on');
% [STUDY erspdata ersptimes erspfreqs] = std_erspplot(STUDY,ALLEEG,'channels',{'Fp1'});
% 
% is a n x m cell array. n and m depend on your study design. To make it simple, create a very simple design with only 1 condition per subject (then n = 1 and m = 1) and erspdata will be a cell array of 1 x 1.
% 
% The array in erspdata is for example 50 x 200 x 10. 50 frequencies, 200 time points and 10 subjects/components. You may average the last dimension and export to a text file.
% 
% tmperspdata = mean(erspdata{1},3);
% save -ascii myfile.txt tmperspdata
% 
% Alternatively, you might want to preserve the subject/component information, so in this case, you would transform the ERSP 2-D image into a 1-D vector
% 
% tmperspdata = reshape(erspdata{1},size(erspdata{1},1)*size(erspdata{1},2), size(erspdata{1},3));
% save -ascii myfile.txt tmperspdata
% 




roi='RA';
name_f1=STUDY.design(9).variable(1).label;
name_f2=STUDY.design(9).variable(2).label;

levels_f1=STUDY.design(9).variable(1).value;
levels_f2=STUDY.design(9).variable(2).value;


for nf1=1:length(levels_f1)
    for nf2=1:length(levels_f2)
        ersp9{nf1,nf2}=squeeze(mean(ersp9{nf1,nf2},3));
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
 titles=[ersp_titles;   p_titles2]
  titles=[titles,   p_titles1']
 
 %  [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat(ersp9,'groupstats','on','condstats','on','mcorrect','fdr','paired',{'on','on'})
 [pcond, pgroup, pinter, statscond, statsgroup, statsinter] = std_stat(ersp9,'groupstats','on','condstats','on','mcorrect','holms','threshold',0.05,'naccu',500)
std_plottf(times, freqs, ersp9, 'datatype', 'ersp','groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'plotmode','normal','titles',titles ,'tftopoopt',{'mode', 'ave'},'caxis',[-2.3, 2.3] ,'threshold',0.05);
 
suptitle(['ERSP in ' roi,': ', name_f1 ' and ' name_f2 ])


%   std_plottf(times, freqs, ersp9, 'datatype', 'ersp','groupstats', pgroup, 'condstats', pcond,'interstats', pinter, 'plotmode','normal','titles',{'1','2','3';'4','5','6';'7','8','9'} ,'tftopoopt',{'mode', 'ave'},'caxis',[-2.3, 2.3] ,'threshold',0.05);
 
%    std_plottf(times, freqs, ersp9, 'datatype', 'ersp','titles',{'1','2','3';'4','5','6';'7','8','9'},'caxis',[-2.3, 2.3],'tftopoopt',{'mode', 'ave'} );