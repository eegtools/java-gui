 function EEG = eeglab_subject_test_art(settings_path, input_file_name, output_path, nch_eeg)
%    
%    function EEG = eeglab_subject_ica(input_file_name, settings_path,  output_path, ica_type)%
%    computes ica decompositions and saves the data with the decomposition in a new datasets appending the _ica suffix    
%    input_file_name is the full path of the input file (.set EEGLab format)
%    output_path is the folder where files with the ica decomposition will be placed
%    settings_path is the full path of the settings file of the project
%    nch_eeg is the number fo EEG channels acquired (to exclude other non-eeg channels like polygraphyc and trigger channels: EEG channels are supposed to be 1:nch_eeg) 
%    ica_type is the algorithm employed to peform ica decomposition (see EEGLab manua, eg. 'runica'). The cuda implementation of ica ('cudaica') 
%    is only availlable on linux or mac and only if the PC has been previously properly configured   

%   ica is supposed to be saved on the same file on which it is applied
%   (artifact removal will be saved elsewere)

    % load configuration file
    [path,name_noext,ext] = fileparts(settings_path);
   
    
    addpath(path);    eval(name_noext);
    
    [path,name_noext,ext] = fileparts(input_file_name);   
    
    EEG = pop_loadset(input_file_name);
    
    
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:78] ,'computepower',0,'linefreqs',[50 100] ,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',1,'winsize',4,'winstep',1);
    save_raw_poly=EEG.data((nch_eeg+1):end,:);    
    
    EEG2= pop_select( EEG,'channel',1:nch_eeg);       
    
    EEG2 = clean_rawdata(EEG2, -1, [-1], -1, 5, -1);
        
    EEG2 = pop_autobssemg( EEG2, [121.6797], [121.6797], 'bsscca', {'eigratio', [1000000]}, 'emg_psd', {'ratio', [10],'fs', [256],'femg', [15],'estimator',spectrum.welch,'range', [0  39]});
    
    EEG.data(1:nch_eeg,:)=EEG2.data;    
    EEG.data((nch_eeg+1):end,:)=save_raw_poly;
    
    
    EEG = pop_saveset( EEG, 'filename',[name_noext],'filepath',output_path);
end