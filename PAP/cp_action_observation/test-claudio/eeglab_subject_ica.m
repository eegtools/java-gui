   
function EEG = eeglab_subject_ica(input_file_name, settings_path, varargin)

    % load configuration file
    [path,name_noext,ext] = fileparts(settings_path);
    addpath(path);    eval(name_noext);
    
    [path,name_noext,ext] = fileparts(input_file_name);
    
    options_num=size(varargin,2);
    if options_num == 1
       output_path = varargin{1};
    else
       output_path = path;
    end    
    
    EEG = pop_loadset(input_file_name);
    EEG = pop_runica(EEG, 'icatype','runica','chanind',1:nch_eeg,'options',{'extended' 1});
    EEG = pop_saveset( EEG, 'filename',[name_noext '_' 'ica'],'filepath',output_path);
    
end

    
