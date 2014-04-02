trigger_duration=0.02;
dio=digitalio('parallel','LPT1');


line=addline(dio,0:7,'out');

put_trigger(1,dio,trigger_duration);
WaitSecs(2);
put_trigger(2,dio,trigger_duration);
WaitSecs(2);
put_trigger(3,dio,trigger_duration);
WaitSecs(2);
put_trigger(4,dio,trigger_duration);
WaitSecs(2);
put_trigger(5,dio,trigger_duration);
WaitSecs(2);
put_trigger(6,dio,trigger_duration);
WaitSecs(2);
put_trigger(7,dio,trigger_duration);
WaitSecs(2);
put_trigger(8,dio,trigger_duration);
WaitSecs(2);
put_trigger(9,dio,trigger_duration);
WaitSecs(2);
put_trigger(10,dio,trigger_duration);
WaitSecs(2);
put_trigger(11,dio,trigger_duration);
WaitSecs(2);
put_trigger(12,dio,trigger_duration);
WaitSecs(2);
put_trigger(13,dio,trigger_duration);
WaitSecs(2);
