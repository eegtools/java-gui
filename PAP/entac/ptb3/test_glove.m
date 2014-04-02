
url='192.168.23.3';
portnum=3000;

black = [0 0 0];
white = [255 255 255];

W=800; H=600; rec = [0,0,W,H]; 
%rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);

[window, rect] = Screen('OpenWindow', 0, black, rec);

try
    ...gloveObj=init_glove_conn(url, portnum);
    ...if gloveObj
        disp('glove correctly connected');
        WaitSecs(1);
        
        % set box and start some fingers
        Screen('FillRect', window, white, [0 0 20 20]);
        Screen('Flip');
       ... start_glove_fingers(gloveObj, {1 2}, 5);
        
        WaitSecs(3);
        
        % remove box and stop fingers
        Screen('FillRect', window, black, [0 0 W H]);
        Screen('Flip');
        ...stop_all_fingers(gloveObj);
        WaitSecs(2);
    ...end
catch error
            
end







