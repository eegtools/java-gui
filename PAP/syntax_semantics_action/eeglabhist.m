arr_subject_epochs_ica=cell(1,numsubj);
for nsubj=1:length(subjects_list)
    for ncond=1:length(conditions_list)
        arr_subject_epochs_ica{nsubj}=[subjects_list{nsubj} '_' analysis_name '_raw_ica_' conditions_list{ncond} '.set'];
    
    end
end