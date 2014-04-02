% function to send a trigger (a decimal number) of a certain duration to a parallel port.
% put_trigger(CODE,DIO,DURATION) where 
% 
% CODE is 2^(n-1) where n is the number of type of the trigger
% 
% DIO is an object mapping a parallel port. it has to be previously created by dio=dio=digitalio('parallel','PARALLEL_NAME') and initialized by line=addline(dio,0:m,'out'); where m is the number of trigger types - 1
% 
% DURATION is the required duration of the trigger (to avoid trigger overlapping AND trigger detection even subsampling)

function put_trigger(code,dio,duration)
putvalue(dio,0); %to be absolutely sure that no previous trigger is on (if this cause a significant delay it can be removed)
putvalue(dio,code);
WaitSecs(duration);
putvalue(dio,0);
end