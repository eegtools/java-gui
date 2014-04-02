%create an instance of the io32 object
ioObj = io32;
%
%initialize the inpoutx64 system driver
status = io32(ioObj);
%
%if status = 0, you are now ready to write and read to a hardware port
%let's try sending the value=1 to the parallel printer's output port (LPT1)
address = hex2dec('B030');          %standard LPT1 output port address
data_out=16;                                 %sample data value
io32(ioObj,address,data_out);   %output command
%
%now, let's read that value back into MATLAB
...data_in=io32(ioObj,address);
%
%when finished with the io32 object it can be discarded via
%'clear all', 'clear mex', 'clear io32' or 'clear functions' command.