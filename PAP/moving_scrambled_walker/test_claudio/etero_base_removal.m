[ALLEEG EEG CURRENTSET ALLCOM] = eeglab; %open EEGLAB

EEG = pop_readegi(Baseline data, [],[],'auto'); % Load your baseline data

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','Baseline','gui','off');

%

EEG = pop_epoch( EEG, {  'Baseline Condition'  }, [-0.5           0], 'newname', 'Baseline epoch', 'epochinfo', 'yes'); % Extract the required epoch length for baseline, 500 ms in this case - you can change to what suites you

 

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');

EEG = eeg_checkset( EEG );

 

%Get the mean of each channel from the baseline data set above

 

EEG.data = mean(EEG.data,2); % This give a vector of number of channels x 1 sample point - which is the mean for the channel

EEG.pnts = 1; % Reset the number of sample points to 1 so as to maintain consistency of data structure in EEGLAB

EEG.times = EEG.times(1); % Reset the times to 1 so as to maintain consistency of data structure in EEGLAB

EEG = eeg_checkset( EEG );

eeglab redraw

 

% Load and epoch your data

EEG = pop_readegi('Data, [],[],'auto'); %Load your main data

EEG = pop_epoch( EEG, {  }, [0  1], 'newname', 'EGI file epochs', 'epochinfo', 'yes'); % epoch your main data

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');

EEG = eeg_checkset( EEG );

 

% Baseline correct your data – ALLEEG(1) is your baseline data set and ALLEEG(2) your epoched main data set

for i = 1:size(ALLEEG(2).data,3) % number of epochs

    for j = 1:size(ALLEEG(2).data,2) % number of samples in each epoch

        ALLEEG(2).data(:,j,i) = ALLEEG(2).data(:,j,i)- ALLEEG(1).data;

    end

end

%

EEG = eeg_checkset( EEG );% this is THE BASELINE CORRECTED DATA

eeglab redraw
