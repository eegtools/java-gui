
function epoching_subject(input_file_name, output_path, settings_path)

    [path,name_noext,ext] = fileparts(input_file_name);
    
    % function to process Alejo's data, already preprocessed in BV
    % preprocessing already performed:
    % filtering : 0.1-45
    % ICA Ocular Correction
    % subsampling @ 250 Hz
    
    % read the configuration file
    fid=fopen(settings_path, 'r'); %~ischar(fgetl(fid))
    while 1   
       tline = fgetl(fid);
        if ~ischar(tline), break, end
        eval(tline);
    end
    fclose(fid);

    % load vhdr data
    EEG = pop_loadbv(path, [name_noext,ext], [], [1:64]);
    
    % keep only stimulus events (removing blink and other markers)
    evecode={EEG.event.code};
    selstim=strncmp(evecode,'St',2);
    EEG.event=EEG.event(selstim);    
    EEG = eeg_checkset( EEG );
    
    nch=size(EEG.data,1);                               %get channel number
    EEG=pop_chanedit(EEG, 'lookup',channels_path);      %channels positions
    EEG = eeg_checkset( EEG );

    EEG = pop_reref(EEG, []);
    EEG = pop_epoch( EEG,   mrkcode_cond  , [epo_st         epo_end], 'newname', 'all_conditions', 'epochinfo', 'yes');
    EEG = pop_rmbase( EEG, [bc_st  bc_end]);
    
    % perform processing and then save condition datasets
    for cond=1:length(mrkcode_cond)
        EEG2 = pop_epoch( EEG, {  mrkcode_cond{cond}  }, [epo_st         epo_end], 'newname', name_cond{cond}, 'epochinfo', 'yes');
        
        EEG2 = eeg_checkset( EEG2 );
        EEG2 = pop_saveset( EEG2, 'filename',[name_noext '_' name_cond{cond}],'filepath',output_path);
    end
end