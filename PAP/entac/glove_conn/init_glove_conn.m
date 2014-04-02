function glove_obj = init_glove_conn(url, portnum)

    % Find a udp object.
    glove_obj = instrfind('Type', 'udp', 'RemoteHost', url, 'RemotePort', portnum, 'Tag', '');

    % Create the udp object if it does not exist
    % otherwise use the object that was found.
    if isempty(glove_obj)
        glove_obj = udp(url, portnum);
    else
        fclose(glove_obj);
        glove_obj = 0; ...glove_obj(1);
    end
    % Connect to instrument object, obj1.
    fopen(glove_obj);
end