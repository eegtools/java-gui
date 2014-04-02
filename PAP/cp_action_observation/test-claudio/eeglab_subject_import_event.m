
% function to import data into eeglab form file format of BIOSEMI, BRAINAMP (et al)
% function epoching_subject_2(input_file_name, output_path, settings_path, acquisition_system, valid_marker) where
% input_file_name is the full path of the file to be imported
% output_path is the forlder where .set files will be placed
% settings_path is the folder of the configuration file named
% project_config.m
% acquisition_system is the employed acquisition system. at the moment it can be BRAINAMP or BIOSEMI
% valid_marker is a cell array with the marker types to be selected
% nch_eeg is the number fo EEG channels acquired (to exclude other non-eeg channels like polygraphyc and trigger channels) 

function EEG = eeglab_subject_import_event(input_file_name, output_path, settings_path, acquisition_system, valid_marker,nch_eeg)

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
             % total number of channels
             nch=size(EEG.data,1);
             % using better erplab filter
             % BIOSEMI needs a standad global filter              
             EEG = pop_basicfilter( EEG,  1:nch, ff1_global, ff2_global, 2, 'butter', 0, [] );
             EEG = eeg_checkset( EEG );
             % filter for EEG channels
             EEG = pop_basicfilter( EEG,  1:nch_eeg, ff1_eeg, ff2_eeg, 2, 'butter', 0, [] );
             EEG = eeg_checkset( EEG );
             % filter for EOG channels
             EEG = pop_basicfilter( EEG,  (nch_eeg+1):(nch_eeg+2) , ff1_eog, ff2_eog, 2, 'butter', 0, [] );
             EEG = eeg_checkset( EEG );
             % filter for EMG channels
             EEG = pop_basicfilter( EEG,  (nch_eeg+1):(nch_eeg+2) ,  ff1_emg, ff2_emg, 2, 'butter', 0, [] );
             EEG = eeg_checkset( EEG );
             % notch
             EEG = pop_basicfilter( EEG,  1:nch, 50, 50, 180, 'notch', 0, [] );
             
             % keep only stimulus events (removing blink and other markers)
             evecode=cell2mat({EEG.event.type});
             selstim0=[];        
             
             for eve_type=valid_marker
                 evenum=str2double(eve_type);
                 selstim0=find(evenum==evecode);
                 selstim=[selstim,selstim0];
                 
             end
             selstim=sort(selstim);
             EEG.event=EEG.event(selstim);    
             EEG = eeg_checkset( EEG );

    end
    EEG=pop_chanedit(EEG, 'lookup',fullfile(channels_path,eeglab_channels_file_name));
    EEG = pop_saveset( EEG, 'filename',[name_noext '_' 'raw'],'filepath',output_path);
end

    
