%==========================================================================
%==========================================================================
% PROJECT DATA
project_name='moving_scrambled_walker';
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
analysis_name='OCICA_250';
%==========================================================================
%==========================================================================


%change the script to overcome a bug of eeglab: is seems that subjects
%names longer than 21 charahters cause problems in the study structure

%define alternative (shoter) names for the subjects
names=cell(length(subjects_list),1);
for i=1:9
    names{i}=['S00' num2str(i)];
end

for i=10:length(subjects_list)
    names{i}=['S0' num2str(i)];
end


%names of conditions
name_cond={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};

% path where eeglab epochs files are exported
epochs_path=fullfile('G:\groups\behaviour_lab\Projects\EEG_tools\moving_scrambled_walker\epochs\OCICA_250_concat_cond');


% reload the study and working with the study structure 
[STUDY ALLEEG] = pop_loadstudy( 'filename','moving_scrambed_walker.study','filepath',epochs_path);



bandnames={'theta','mu_alpha','beta1','beta2'};

%raw_power
f1vec=[4    8   14  20];
f2vec=[7.5  13  20  32];

chan_names=[STUDY.changrp.channels];
tot_chan=length(chan_names);

nset=1;
% 
% %start EEGLab
% %%%%[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
% 
% discard noisy components

design_name='design1';
erspset=[];
sub=[];
times=[];
ersp=[];
cond=[];
band=[];

namexls=([ char(project_name) '_' char(design_name) '.xls']);

%IMPORTANT onechan is already normalized baseline

for nband=1:length(bandnames)
    f1=f1vec(nband);
    f2=f2vec(nband);    
    % load each epochs set file (subject and condition) into the study structure
    % of EEGLab
    for des = 1%:length(STUDY.design)
        for iCell = 1:length(STUDY.design(des).cell)
            filename=[STUDY.design(des).cell(iCell).filebase '.datersp'];
            ERSPdata = load('-mat',filename); % .mat format!
            erspset=[];
            for chan=1:tot_chan		
                onechan=['ERSPdata.chan',int2str(chan),'_ersp'];
                onechan=eval(onechan);
                onebase=['ERSPdata.chan',int2str(chan),'_erspbase'];
                onebase=eval(onebase);
                %need a repmat
                nrb=size(onechan,2);
%                 onebase_mat=repmat(onebase',1,nrb);
%                 onechan_norm=onechan-onebase_mat;
                %tms=find(ERSPdata.times > t1 & ERSPdata.times < t2)
                frs=find(ERSPdata.freqs > f1 & ERSPdata.freqs < f2);
                chanersp=mean(onechan(frs,:))';%mean raw power of the channel 
                erspset=[erspset,chanersp];
            end
            ersp=[ersp;erspset];

            repsub=repmat({STUDY.design(des).cell(iCell).case},nrb,1);
            sub=[sub;repsub];    

            repcond=repmat(STUDY.design(des).cell(iCell).value(1),nrb,1);
            cond=[cond;repcond];    
            
            times=[times;ERSPdata.times'];
            
            repband=repmat(bandnames(nband),nrb,1);
            band=[band;repband];
        end
    end
    
   

end        
tot_rows=length(sub);

namecols=['band', 'sub', 'cond', 'times', chan_names];

% def_rows=['A1:A' char(num2str(tot_rows))];
xlswrite(namexls, namecols,'raw_power','A1')

xlswrite(namexls, band,'raw_power','A2')
xlswrite(namexls, sub,'raw_power','B2')
xlswrite(namexls, cond,'raw_power','C2')
xlswrite(namexls, times,'raw_power','D2')

xlswrite(namexls, ersp,'raw_power','E2')


% 
% erspset=[];
% sub=[];
% times=[];
% ersp=[];
% cond=[];
% band=[];
% 
% 
%     for nband=1:length(bandnames)
%         f1=f1vec(nband);
%         f2=f2vec(nband);    
%         % load each epochs set file (subject and condition) into the study structure
%         % of EEGLab
%         for des = 1%:length(STUDY.design)
%             for iCell = 1:length(STUDY.design(des).cell)
%                 filename=[STUDY.design(des).cell(iCell).filebase '.datersp'];
%                 ERSPdata = load('-mat',filename); % .mat format!
%                 erspset=[];
%                 for chan=1:tot_chan		
%                     onechan=['ERSPdata.chan',int2str(chan),'_ersp'];
%                     onechan=eval(onechan);
%                     onebase=['ERSPdata.chan',int2str(chan),'_erspbase'];
%                     onebase=eval(onebase);
%                     %need a repmat
%                     nrb=size(onechan,2);
%                     onebase_mat=repmat(onebase',1,nrb);
%                     onechan_norm=onechan-onebase_mat;
%                     %tms=find(ERSPdata.times > t1 & ERSPdata.times < t2)
%                     frs=find(ERSPdata.freqs > f1 & ERSPdata.freqs < f2);
%                     chanersp=mean(onechan_norm(frs,:))';%mean raw power of the channel 
%                     erspset=[erspset,chanersp];
%                 end
%                 ersp=[ersp;erspset];
% 
%                 repsub=repmat({STUDY.design(des).cell(iCell).case},nrb,1);
%                 sub=[sub;repsub];    
% 
%                 repcond=repmat(STUDY.design(des).cell(iCell).value(1),nrb,1);
%                 cond=[cond;repcond];    
% 
%                 times=[times;ERSPdata.times'];
% 
%                 repband=repmat(bandnames(nband),nrb,1);
%                 band=[band;repband];
%             end
%         end
% 
% 
% 
%     end        
%     tot_rows=length(sub);
% 
%     namecols=['band', 'sub', 'cond', 'times', chan_names];
% 
%     % def_rows=['A1:A' char(num2str(tot_rows))];
%     xlswrite(namexls, namecols,'norm_power','A1')
%     xlswrite(namexls, band,'norm_power','A2')
%     xlswrite(namexls, sub,'norm_power','B2')
%     xlswrite(namexls, cond,'norm_power','C2')
%     xlswrite(namexls, times,'norm_power','D2')
% 
%     xlswrite(namexls, ersp,'norm_power','E2')
% 
% 
