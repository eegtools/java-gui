function TTL_obj = init_TTL(flag);

% Function to create trigger using National Instruments Board  <NI> flag,
% or using usb cable <USB> flag

%--------------    TTL generator    ------------------------%
if strcmp(flag,'NI')
    %-----   NI card
    %find DigitalAalog (DAQ) devices features
    NI_info = daqhwinfo('nidaq');
    if not(isempty(NI_info.InstalledBoardIds))
        id_Dev = NI_info.InstalledBoardIds{1};
        %initialization input/output lines
        TTL_obj.dio = digitalio('nidaq', id_Dev);
        hwlinesIN = addline(TTL_obj.dio,0:3,'in');
        hwlinesOUT = addline(TTL_obj.dio,4:7,'out');
        putvalue(TTL_obj.dio.Line(5:8),[0 0 0 0]);
        TTL_obj.serial = 0;
    else
        disp('National Instruments Board NOT found');
        TTL_obj.dio = 0;
        TTL_obj.serial = 0;
        return
    end
    
    
elseif strcmp(flag,'USB')
    %------   USB/SERIAL
    A = instrfind;  %to find any serial object
    
    %to delete any serial obj already present in the workspace
    if ~isempty(A)
        fclose(A);
        delete(A);
        clear A;
    end
    
    TTL_obj.serial = serial('COM3', 'BaudRate', 115000); % Create Serial Object
    try
        fopen(TTL_obj.serial); % Open Serial Port
        set(TTL_obj.serial,'RequestToSend','off')  %TTL 0V --> low enable
        set(TTL_obj.serial,'RequestToSend','on')
    catch
        disp('Problemi con l''apertura della porta seriale');
        TTL_obj.dio = 0;
        TTL_obj.serial = 0;
        return
    end
    
else   %flag = 'test'
    disp('test')
    TTL_obj.dio = 0;
    TTL_obj.serial = 0;
    
end
%-----------------------------------------------------------%