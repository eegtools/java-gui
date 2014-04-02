
% Studio sui comandi da mandare alla porta parallela per i Marker EEG e per
% triggerare altri strumenti, spostare parte di questo codice in
% CommonScript nel caso in cui si riesca a trovare un modo generalizzato.

%create an instance of the io32 object
ioObj = io32;%
%initialize the inpoutx64 system driver
status = io32(ioObj);%
%if status = 0, you are now ready to write and read to a hardware port
%let's try sending the value=1 to the parallel printer's output port (LPT1)
address = hex2dec('378');          %standard LPT1 output port address

% Preload GetSecs for fast speed recall
to = GetSecs;
pause(.5)
to = GetSecs;
T = zeros(256,1);
data_out = 0;
for val = 0:255
    if data_out == 0
        data_out = 16;
    else
        data_out = 0;
    end 
    %sample data value
    io32(ioObj,address,data_out);   %output command 
end
tf = GetSecs - to;

% On my PC report is less than 9 ms, but this oscillo I see 2.1 ms to
% complete le writing of 256 value on LPT port, is fast enought for us.\\



address = hex2dec('378');          %standard LPT1 output port address

% Preload GetSecs for fast speed recall
to = GetSecs;
pause(.5)
to = GetSecs;
T = zeros(256,1);
data_out = 0;
for val = 0:255
    if data_out == 0
        data_out = 16;
    else
        data_out = 0;
    end 
    %sample data value
    lptwrite(address,data_out)  %output command 
end
tf = GetSecs - to;



