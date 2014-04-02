pnts = eeg_lat2point([-100:10:600]/1000, 1, EEG.srate, [EEG.xmin EEG.xmax]);
% Above, convert latencies in ms to data point indices
figure; [Movie,Colormap] =  eegmovie(mean(EEG.data,3), EEG.srate, EEG.chanlocs,'mode','3D','title','ERP', 'startsec',0);
seemovie(Movie,-5,Colormap);