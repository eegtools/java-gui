dd=rand(1,100);
figure;plotcurve(1:100,dd,'maskarray',[1:100]/100,'highlightmode','background','val2mask',[ones(1,100)*0.5],'vert',[50],'linewidth',2)
