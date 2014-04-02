function filtdata = filtra_coord(filtro,rawdata)

filtdata = filtfilt(filtro.coord.b,filtro.coord.a,rawdata);
