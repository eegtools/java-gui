function status = start_vicon(flag, TTL_obj)

%--------------    TTL generator: START    --------------------%
if strcmp(flag,'NI')
    %  ----   NI card
    try
        putvalue(TTL_obj.dio.Line(5:8),[1 1 0 0]);
        putvalue(TTL_obj.dio.Line(5:8),[0 1 0 0]);
        status = 1;
    catch 
        status = -1;
        disp('Problemi con la porta digitale National');        
        return
    end
elseif strcmp(flag,'USB')
    %  ----   USB/SERIAL
    try
        set(TTL_obj.serial,'RequestToSend','on') %TTL 0V
        status = 1;
    catch
        status = -1;
        disp('Problemi con la porta seriale');
        return
    end    
else
    %  ----   no data acquisition
    disp('test')
    status = 1;
end