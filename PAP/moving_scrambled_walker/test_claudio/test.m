filtSpec.range = [8 12];
filtSpec.order = 250; 
cp=[];
tch=64;
for nch1=1:63
    for nch2=tch-nch1+1:tch
        ccp=[nch1, nch2];
        cp=[cp;ccp];
    end
end

ds.chanPairs = cp;% [7, 12; 13 20];


ds.connectStrength=rand(length(cp),1);
ds.connectStrengthLimits=[0, 1];


EEG_filtered = pop_firws(EEG, 'fcutoff', [8 12], 'ftype', 'bandpass', 'wtype', 'blackman', 'forder', filtSpec.order);
[plv] = pn_eegPLV(EEG_filtered.data, EEG.srate, filtSpec);
figure();
topoplot_connect(ds, EEG.chanlocs)



 