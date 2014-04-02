function write_accel_data(trial_id, eeg_code, output)

    variable = sprintf('acceldata_%d_%d',trial_id, eeg_code);
    str=[variable '= cdaq_read_data' ];
    eval(str);    
    str=['save(''',output,''',''',variable,''', ''-append'')']
    eval(str);
end
