function start_glove_fingers(glove_obj, finger_ids, strenght)

    string={'0' '0' '0' '0' '0'};
    for id=finger_ids
        string{id}=num2str(strenght);
    end
    fprintf(glove_obj, '%s', ['A' char(string)' 'B']);

end