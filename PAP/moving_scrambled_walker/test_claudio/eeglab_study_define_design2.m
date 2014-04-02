function [STUDY, EEG] = eeglab_study_define_design2(settings_path, study_path, within_design_list, between_design_list)

% function [STUDY, EEG] = eeglab_study_define_design(study_path, designs_list, settings_path)
% defines EEGLab STUDY design(s) indicated in designs_list for the next
% statistical comparisons between conditions.
% study_path is the full path of the STUDY file,
% designs_list is a cell array such as {designs_list={{'cond1_of_comparison1' 'cond2_of_comparison1'... condn_of_comparison1};...{'cond1_of_comparisonm' 'cond2_of_comparison,'... condk_of_comparisonm}};
% settings_path is the complete path were the settings file of the project (typically named project_settings) is placed.

% load configuration file
    [path,name_noext,ext] = fileparts(settings_path);
    addpath(path);    eval(name_noext);

    [study_folder,study_name_noext,study_ext] = fileparts(study_path);    

    % start EEGLab
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

    % load the study and working with the study structure 
    [STUDY ALLEEG] = pop_loadstudy( 'filename',[study_name_noext study_ext],'filepath',study_folder);
    
    tot_wd=size(within_design_list,1);
    tot_bd=size(between_design_list,1);
    nn=0;
    % all groups merged
    for wd=1:tot_wd
        nn=nn+1;
        STUDY = std_makedesign(STUDY, ALLEEG, nn, 'variable1','condition','variable2','','name',['design' num2str(nn)],'pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',within_design_list{wd});
    end
    
    
    % cycle among  within & between design lists
    for bd=1:tot_bd
        for wd=1:tot_wd
            nn=nn+1;
            STUDY = std_makedesign(STUDY, ALLEEG, nn, 'variable1','condition','variable2','group','values2', between_design_list{bd}, 'pairing2', 'off', 'name',['design' num2str(nn) ' ' within_design_names{wd} ':' between_design_names{bd}],'pairing1','on','pairing2','on','delfiles','off','defaultdesign','off','values1',within_design_list{wd});
        end
    end    
    
    % save study
    [STUDY EEG] = pop_savestudy( STUDY, ALLEEG, 'savemode','resave');
end