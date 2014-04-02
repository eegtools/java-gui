figure;
[ersp,itc,powbase,times,freqs,erspboot,itcboot] = newtimef(EEG.data(1,:,:), EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 0,'timesout',[-200:8: 800],'freqs',[1:0.5:40],'padratio',16);
