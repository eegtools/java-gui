function status = stop_vicon(flag, TTL_obj)

%--------------    TTL generator: STOP    ------------------------%
    if strcmp(flag,'NI')
        %----   NI card
        % TTL 5V immediatly after the end of the presentation of the dot
        putvalue(TTL_obj.dio.Line(5:8),[0 0 0 0]);
        status = 1;
        
    elseif strcmp(flag,'USB')
        %----   USB/SERIAL
        set(TTL_obj.serial,'RequestToSend','off') %TTL 5V
        status = 1;
        
    else
        disp('test')
        status = 1;
    end
    %-------------------------------------------------------------%