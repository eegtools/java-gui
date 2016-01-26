project.study.precompute.erp                    = {'interp','off','allcomps','on','erp'  ,'on','erpparams'  ,{},'recompute','off'};
project.study.precompute.erpim                  = {'interp','off','allcomps','on','erpim','on','erpimparams',{'nlines' 10 'smoothing' 10},'recompute','off'};
project.study.precompute.spec                   = {'interp','off','allcomps','on','spec' ,'on','specparams' ,{'specmode' 'fft','freqs' project.study.ersp.freqout_analysis_interval},'recompute','off'};
project.study.precompute.ersp                   = {'interp','off' ,'allcomps','on','ersp' ,'on','erspparams' ,{'cycles' project.study.ersp.cycles,  'freqs', project.study.ersp.freqout_analysis_interval, 'timesout', project.study.ersp.timeout_analysis_interval.s*1000, ...
                                                   'freqscale','linear','padratio',num2str(project.study.ersp.padratio), 'baseline',[project.epoching.bc_st.s*1000 project.epoching.bc_end.s*1000] },'itc','on','recompute','off'};
