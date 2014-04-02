address=hex2dec('B030');
portnum=1;  ... parport1
trigger_duration=0.01;   % duration of the trigger in sec. (to avoid trigger overlapping AND trigger detection even subsampling)
  
for code=1:255
    put_trigger_linux(address, code, trigger_duration, portnum);
    WaitSecs(0.2);
end

