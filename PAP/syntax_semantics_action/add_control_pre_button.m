

event_classes=unique({EEG.event.type}); 
stimulus_classes={'S200'};
question_classes={'S254'};


[trgs,urnbrs,urnbrtypes,delays,tflds,urnflds] = eeg_context(EEG,stimulus_classes,question_classes,1);  

selev=[];
for e=1:length(trgs ) % For each target,
	if abs(delays(e)) < 1500 ...  % if  latency in acceptable range	
		selev = [selev trgs(e,1)];  % mark target as responded to
	
	end
end



% number of selected events
nevents = length(selev);
for index = 1 : nevents
    % Add events relative to existing events
	EEG.event(end+1) = EEG.event(selev(index)); % Add event to end of event list
	EEG.event(end).type = 'S201';
    
end;
  
EEG = eeg_checkset(EEG, 'eventconsistency'); % Check all events for consistency
[ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET); % Store dataset
eeglab redraw % Redraw the main eeglab window
