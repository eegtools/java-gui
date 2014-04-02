import_file_name='G:\groups\behaviour_lab\Projects\EEG_tools\cp_action_observation\biosemi_data\03_vale-Deci.bdf';
raw_file_name='G:\groups\behaviour_lab\Projects\EEG_tools\cp_action_observation\epochs\03_vale-Deci_raw.set';
ica_file_name='G:\groups\behaviour_lab\Projects\EEG_tools\cp_action_observation\epochs\03_vale-Deci_raw_ica.set';

output_path='G:\groups\behaviour_lab\Projects\EEG_tools\cp_action_observation\epochs';
settings_path='C:\Users\User\behaviourPlatform_svn\EEG_Tools\cp_action_observation\';
acquisition_system='BIOSEMI';
valid_marker={'11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46'};
nch_eeg=64;

import=0;
clean=0;
epoch=0;
compare=1;
if import
    EEG=eeglab_subject_import_event(import_file_name, output_path, settings_path, acquisition_system, valid_marker,nch_eeg);
    EEG = pop_interp(EEG, [20], 'spherical');
    EEG=eeglab_subject_ica(raw_file_name, output_path, settings_path, acquisition_system, valid_marker,nch_eeg);
end

if clean
    EEG = pop_rejepoch( EEG, [148 177 178 180 185 196 199 208 220 224 245 254 265] ,0);
    EEG = pop_subcomp( EEG, [1  2  3  4  5  6  7  8], 0);
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 1, 1, 1);
    pop_eegplot( EEG, 0, 1, 1);
    EEG = pop_subcomp( EEG, [1   7  13  20  21  26  33  40  43], 0);
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 1, 1, 1);
    pop_eegplot( EEG, 0, 1, 1);
    EEG = pop_subcomp( EEG, [5], 0);
    EEG = eeg_checkset( EEG );
    pop_eegplot( EEG, 0, 1, 1);
    EEG = eeg_checkset( EEG );
    EEG = pop_rejepoch( EEG, [5 10 20 33 45 95 132 133 134 214 223] ,0);
end
if epoch
    EEG=eeglab_subject_epoching(ica_file_name, output_path, settings_path, acquisition_system, valid_marker,nch_eeg);
end

if compare
    chan_name='O1';   
    eeglab;
%     EEG = pop_loadset('filename',{'03_vale-Deci_raw_ica_control.set' '03_vale-Deci_raw_ica_AO.set' '03_vale-Deci_raw_ica_AOCS.set' '03_vale-Deci_raw_ica_AOIS.set'},'filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');
%    
    EEG = pop_loadset('filename',{'03_vale-Deci_raw_ica_control.set' },'filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');

    chanlist={EEG(1).chanlocs.labels};
    chan_num=find(strcmp(chan_name,chanlist));
    srate=EEG(1).srate;
    pnt=EEG(1).pnts;
    xmin=EEG(1).xmin;
    xmax=EEG(1).xmax;
    
    
    figure()
    title(['03_vale-Deci_raw_ica_control.set' '-' chan_name]);
    [ersp,itc,powbase,times,freqs,erspboot,itcboot] = newtimef(EEG.data(chan_num,:,:) ,pnt, [xmin xmax]*1000, srate, 0,'alpha',0.01,'plotitc','off','mcorrect','fdr');
     clear EEG
    

     EEG = pop_loadset('filename',{'03_vale-Deci_raw_ica_AO.set' },'filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');
     figure()
    title(['03_vale-Deci_raw_ica_AO.set' '-' chan_name]);
   [ersp,itc,powbase,times,freqs,erspboot,itcboot] = newtimef(EEG.data(chan_num,:,:) ,pnt, [xmin xmax]*1000, srate, 0,'alpha',0.01,'plotitc','off','mcorrect','fdr');
    clear EEG
    
%     EEG = pop_loadset('filename',{'03_vale-Deci_raw_ica_AOCS.set' },'filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');
%     figure()
%     title(['03_vale-Deci_raw_ica_AOCS.set' '-' chan_name]);
%     [ersp,itc,powbase,times,freqs,erspboot,itcboot] = newtimef(EEG.data(chan_num,:,:) ,pnt, [xmin xmax]*1000, srate, 0,'alpha',0.01,'plotitc','off','mcorrect','fdr');
%     clear EEG
%     
%     EEG = pop_loadset('filename',{'03_vale-Deci_raw_ica_AOIS.set' },'filepath','G:\\groups\\behaviour_lab\\Projects\\EEG_tools\\cp_action_observation\\epochs\\');
%     figure()    
%     title(['03_vale-Deci_raw_ica_AOIS.set' '-' chan_name]);
%    [ersp,itc,powbase,times,freqs,erspboot,itcboot] = newtimef(EEG.data(chan_num,:,:) ,pnt, [xmin xmax]*1000, srate, 0,'alpha',0.01,'plotitc','off','mcorrect','fdr');
% clear EEG
   %     [ersp,itc,powbase,times,freqs,erspboot,itcboot] = newtimef({EEG(1).data(1,:,:) EEG(2).data(1,:,:)},EEG(1).pnts, [EEG(1).xmin EEG(1).xmax]*1000, EEG(1).srate, 0,'alpha',0.01,'commonbase','off');
end