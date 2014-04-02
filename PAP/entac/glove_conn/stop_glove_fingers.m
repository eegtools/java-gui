function stop_glove_fingers(glove_obj, finger_num)

    string={'0' '0' '0' '0' '0'};
    for id=finger_ids
        string{id}='0';
    end
    fprintf(glove_obj, '%s', ['A' char(string)' 'B']);
end