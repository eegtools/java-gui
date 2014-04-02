function plot_accell(data, nch, nsamples)
    figure
    for ch=1:nch
        subplot(nch, 1, ch)
        plot(data(ch:nch:nsamples*nch))
    end
end