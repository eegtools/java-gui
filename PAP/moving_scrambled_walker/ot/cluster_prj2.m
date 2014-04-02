% For each cluster and condition of a selected design, calculate the projection on EEG channels of each component of the selected cluster. 
% Then, compute the mean ERP projection of the cluster on the scalp by averaging between components.  


% The cluster.topo field contains the average topography of a component cluster. 
% Its size is 67x67 and the coordinate of the pixels are given by cluster.topox and cluster.topoy (both of them of size [1x67]). 
% This contains the interpolated activity on the scalp so different subjects having scanned electrode positions may be visualized on the same topographic plot. 
% The cluster.topoall cell array contains one element for each component and condition.
% The cluster.topopol is an array of -1s and 1s indicating the polarity for each component. 
% Component polarities are not fixed, in the sense that inverting both one component activity and its scalp map does not modify the back-projection of the component to the data channels). 
% The true scalp polarity is taken into account when displaying component ERPs.




%==========================================================================
%==========================================================================
% GLOBAL PATHS 
projects_data_path='G:/moving_scrambed_walker-old/';
plugins_path='/data/matlab';
%==========================================================================
%==========================================================================


%==========================================================================
%==========================================================================
% PROJECT DATA
project_name='moving_scrambled_walker';
subjects_list={'alessandra_finisguerra', 'alessia', 'amedeo_schipani', 'antonio2', 'augusta2', 'claudio2', 'denis_giambarrasi', 'eleonora_bartoli', 'giada_fix2', 'jorhabib', 'martina2', 'stefano', 'yannis3'};
analysis_name='OCICA_250';
%==========================================================================
%==========================================================================

%names of conditions
name_cond={'cwalker' 'twalker' 'cscrambled' 'tscrambled'};

% path where eeglab epochs files are exported
epochs_path=fullfile(projects_data_path,'epochs',analysis_name, '');


% select the name of the design to consider
select_design='allcentered';
% select the variable (factor) to disciminate plots
select_variable='condition';

%select the path where projections will be exported
projections_path='G:\moving_scrambed_walker-old\projections\OCICA_250';

%load the study file

[STUDY ALLEEG] = pop_loadstudy('filename', 'moving_scrambed_walker.study', 'filepath', epochs_path);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;


channel_locations=EEG.chanlocs;
channel_names={ EEG(1).chanlocs.labels};

% take the current study 
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];    

% names of experimental designs defined for the current STUDY
design_names={STUDY.design(1:end).name};

% number of the selected design
design_number=find(strcmp(select_design,design_names));

% names of the variables (factors) in the selected design 
variable_names={STUDY.design(design_number).variable.label};

% number of the selected variable in the design
variable_number=find(strcmp(select_variable,variable_names));

% condition names for the selected design and variable
condition_names=STUDY.design(design_number).variable(variable_number).value;
total_conditions=length(condition_names);

% number of clusters: the first is the parent cluster (all components
% together)
total_clusters=size(STUDY.cluster,2);

% clean up variables
clear winvs acts chans prjclus


for clust = 2:total_clusters;  % choose a cluster (excluding parent cluster)
    % initialize the cluster projection
    prjclus=[];
    if clust==2
        STUDY = std_topoplot(STUDY,ALLEEG,'clusters',2:length(STUDY.cluster)); 
    end
    
    for cond = 1:total_conditions % choose a condition (from STUDY.condition)
 
        % compute average cluster ERP projected on EEG channels

        for ic = 1:length(STUDY.cluster(clust).allinds{cond}) % for each component in the cluster
            %take the index of data set corresponding to the selected condtion AND
            %to the selected condition
            design_idx = STUDY.cluster(clust).setinds{cond}(1,ic);
            setidx = STUDY.design(design_number).cell(design_idx).dataset;
            %select the component
            comp = STUDY.cluster(clust).allinds{cond}(1,ic);
            %load the dataset with the selected component
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,... 
            'retrieve',setidx,'study',CURRENTSTUDY);

            
            % the only sign carrier is icawinv, therefore to obtain the right
            % polarity it can be directly multiplied with topopol

            % exctract the matrix with the weights and if multiply by the corrresponding topopol to invert the polarities (if required). 
            % this is made to be in accordance with the polarity of cluser centroid  
            winvs = ALLEEG(setidx).icawinv(:,:)*STUDY.cluster(clust).topopol(ic); 
            
            %winvs = ALLEEG(setidx).icawinv(:,:); 

            % calculate the projection of the IC on all channels
            prjics(:,:,ic)=icaproj2(mean(ALLEEG(setidx).data(:,:,:),3),pinv(winvs),comp);    
        end; 
        %average projection over trials 
        prjclus=mean(prjics,3);

%         figure;
%         plottopo(prjclus,EEG.chanlocs);
%         title( ['Cluster_' num2str(clust) '_' condition_names{cond}] )
          name_file_save=char(['projection' '_' 'cluster' '_' num2str(clust) '_' select_design '_' condition_names{cond}]);
%         save(name_file_save, 'prjclus','channel_locations','channel_names')
        EEG2 = pop_importdata('dataformat','array','nbchan',64,'data','prjclus','srate',250,'subject','All','pnts',0,'condition',condition_names{cond},'xmin',-0.400,'session',1,'group','1');
        EEG2.chanlocs=EEG.chanlocs;
        EEG2 = pop_saveset( EEG2, 'filename',name_file_save,'filepath',projections_path);
        clear EEG2;
    end    
end

