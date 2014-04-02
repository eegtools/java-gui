
% function to import data into eeglab form file format of BIOSEMI, BRAINAMP (et al)
% function epoching_subject_2(input_file_name, output_path, settings_path, acquisition_system, valid_marker) where
% input_file_name is the full path of the file to be imported
% output_path is the forlder where .set files will be placed
% settings_path is the folder of the configuration file named
% project_config.m
% acquisition_system is the employed acquisition system. at the moment it can be BRAINAMP or BIOSEMI
% valid_marker is a cell array with the marker types to be selected
% nch_eeg is the number fo EEG channels acquired (to exclude other non-eeg channels like polygraphyc and trigger channels) 

function EEG = epoching_subject_2(input_file_name, output_path, settings_path, acquisition_system, valid_marker,nch_eeg)

    [path,name_noext,ext] = fileparts(input_file_name);
    
    % load configuration file
    addpath(settings_path);
    project_config;
    
    selstim=[];
    switch acquisition_system
        case 'BRAINAMP'
            % load vhdr data
             EEG = pop_loadbv(path, [name_noext,ext], [], 1:nch_eeg);
              % keep only stimulus events (removing blink and other markers)
              evecode={EEG.event.code};
               % keep only stimulus events (removing blink and other markers)
                evecode={EEG.event.code};
                selstim=strncmp(evecode,'St',2);
                EEG.event=EEG.event(selstim);    
                EEG = eeg_checkset( EEG );
    
        case 'BIOSEMI'
             EEG = pop_biosig(input_file_name, 'importannot','off');
             % need a standad filter
              EEG = pop_eegfiltnew(EEG, 0.16, 45);
             % keep only stimulus events (removing blink and other markers)
             evecode=cell2mat({EEG.event.type});
             selstim0=[];        
             
             for eve_type=valid_marker
                 evenum=str2double(eve_type);
                 selstim0=find(evenum==evecode);
                 selstim=[selstim,selstim0];
                 
             end
             selstim=sort(selstim);

    end
    
   
    
    EEG.event=EEG.event(selstim);    
    EEG = eeg_checkset( EEG );
    
    nch=size(EEG.data,1);                               %get channel number
%     EEG=pop_chanedit(EEG, 'lookup',channels_path);      %channels positions
    EEG = eeg_checkset( EEG );

    if nch>nch_eeg
       EEG = pop_reref(EEG, [],'exclude',(nch_eeg+1): nch);
    else
       EEG = pop_reref(EEG, []);
    end
    if size(mrkcode_cond,1)>1
        EEG = pop_epoch( EEG,   [mrkcode_cond{1:length(mrkcode_cond)}]  , [epo_st         epo_end], 'newname', 'all_conditions', 'epochinfo', 'yes');
    else
        EEG = pop_epoch( EEG,   mrkcode_cond  , [epo_st         epo_end], 'newname', 'all_conditions', 'epochinfo', 'yes');
    end
    EEG = pop_runica(EEG, 'icatype','runica','chanind',1:nch_eeg,'options',{'extended' 1});
    
    EEG = pop_rmbase( EEG, [bc_st  bc_end]);
    
%     % perform processing and then save condition datasets
    for cond=1:length(mrkcode_cond)
        EEG2 = pop_epoch( EEG,  mrkcode_cond{cond}  , [epo_st         epo_end], 'newname', name_cond{cond}, 'epochinfo', 'yes');
        
        EEG2 = eeg_checkset( EEG2 );
        EEG2 = pop_saveset( EEG2, 'filename',[name_noext '_' name_cond{cond}],'filepath',output_path);
    end

end