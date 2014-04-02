address = hex2dec('378'); 

%Load the Dll
loadlibrary('cdaq', 'cdaq.h')
libfunctions('cdaq') %Display all functions available from the library

configFile='F:\WorkingDir\EEG_Tools\point_dot_bar\BarDot_eeg\ptb3\DanLiAcq.cfg';

if calllib('cdaq', 'cdaqConfig', configFile) == 1
    disp('Successfully configured the task')
else
    disp('Error reading config file:')
    disp(calllib('cdaq','cdaqGetErrorInfo'))
    return;
end

%Create the acquisition task
res=calllib('cdaq','cdaqCreateTask');
if res ==1
	disp('Task Created')
else
	disp( 'Error creating the task:')
	disp(calllib('cdaq','cdaqGetErrorInfo'))
	return;
end


%Start the acquisition
disp('Press a key to start task')
pause
 

res=calllib('cdaq','cdaqStartTask');
if res ==1
	disp('Task Started')
else
	disp('Error: could not start the task')
	disp(calllib('cdaq', 'cdaqGetErrorInfo'))
	return;
end   

...lptwrite(address,0) 
%Wait for manual or automatic stop signal (depending on the type of acquisition)
...done=0;
...trigger =0;
...disp('Press button to stop task')

...calllib('cdaq','cdaqRead')


...disp('read call')
% pause(0.1);
% if GetSecs - to >= 4
%     done=1;
% end
% if GetSecs - to >= 2 && trigger == 0
%     lptwrite(address,16);
%     trigger = 1;
% end

...pause(1)
...lptwrite(address,16)
...pause(1)
...calllib('cdaq','cdaqRead')



...disp('Acquisition done')
...calllib('cdaq','cdaqIsTaskDone',done)
%Stop acquisition task
...if calllib('cdaq','cdaqStopTask') ==1
...	disp('Task Stopped')
...else		
...	disp('Error: could not stop the task')
...	disp(calllib('cdaq','cdaqGetErrorInfo'))
...	return;
...end

pause(4.1);
calllib('cdaq','cdaqRead')

calllib('cdaq','cdaqStopTask')

%Print data to screen
Nchann=calllib('cdaq','cdaqGetNumChannels');
maxsamp=calllib('cdaq','cdaqGetMaxSamples');
c_data=zeros(1,maxsamp*Nchann);
pc_data=libpointer('singlePtr', c_data);
data=calllib('cdaq','cdaqExportData',pc_data, maxsamp*Nchann);
setdatatype(data,'singlePtr',maxsamp*Nchann)
figure
%Errors occurr when trying to treat c_data as a 2D structure
%here we use it as 1D array
for i = 1:Nchann
	subplot(Nchann, 1, i)
    plot(data.Value(i:Nchann:maxsamp*Nchann))
end

%Save data to file
saveFile='cdaqMatlabExampleData.txt';
if calllib('cdaq','cdaqSaveData',saveFile)==1
	disp('Data saved to file')
else
	disp('Error: could not save data')
	disp(calllib('cdaq','cdaqGetErrorInfo'))
	return;
end
	
%Exit program
disp('Press a key to exit program')
pause

unloadlibrary('cdaq')
disp('Exit Program')