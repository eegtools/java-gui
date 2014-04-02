% Import C3d Data Script

% Aggiungo il path contenente C3D server
addpath('C:\Users\Marco\Documents\WorkingDIR\C3D Server\C3D')
itf = c3dserver;
% Directory contenete le sessioni
session_dir = ['\\geo\repository\groups\behaviour_lab\Projects\EEG_tools\mirror_mirror\vicon\'];

%% Filtro COORD
filtro.coord.fc = 100 ; % Frequenza di campionamento Coordinate
filtro.coord.ft = 10; % Frequenza di taglio passa basso
filtro.coord.fn = filtro.coord.fc/2; % Frequenza Nyquist
filtro.coord.wn = filtro.coord.ft/filtro.coord.fn;
[filtro.coord.b,filtro.coord.a] = butter(2,filtro.coord.wn);
%%
% Definizione della sessione
session_name = 'sess1\';
working_dir = [session_dir session_name];
a = dir(working_dir);
data.info.max_trial = length(a)-2;
fprintf('Trial identificati : %d\n', data.info.max_trial);
trial_err = [];
for trial = 1:data.info.max_trial
    
    %file_name = [file_name_pre '_' num2str(trial,'%03d')];
    file_name = a(trial+2).name;
    trial_rec = str2double(file_name(end-6:end-4));
    data.trial_rec{trial} = trial_rec;
    fullpath = [working_dir file_name];
    openc3d(itf,0,fullpath);
    residual = 0;
    index1 = itf.GetVideoFrame(0); % frame start
    index2 = itf.GetVideoFrame(1); % frame end
    nIndex = itf.GetParameterIndex('POINT', 'LABELS');
    nItems = itf.GetParameterLength(nIndex); %Number of Markers
    if nItems == 10
        unitIndex = itf.GetParameterIndex('POINT', 'UNITS');
        for i = 1 : nItems
            %         target_name = itf.GetParameterValue(nIndex, i-1);
            %         target_name = deblankl(target_name);
            %         marker_lab{i} = target_name(2:end);
            %         target_name = ['M' marker_lab{i}];
            rawdata = double(cell2mat([   itf.GetPointDataEx(i-1,0,index1,index2,'1'),...
                itf.GetPointDataEx(i-1,1,index1,index2,'1'),...
                itf.GetPointDataEx(i-1,2,index1,index2,'1')]));
            %         filtdata = filtra_coord(filtro,rawdata);
            %         Vxyz = [0 0 0 ; diff(filtdata)*filtro.coord.fc];
            %         Vm = [sqrt(sum(Vxyz.^2,2))];
            %         eval([subject_name '.(target_name).xyz{trial} = rawdata ;']);
            %         eval([subject_name '.(target_name).xyzf{trial} = filtdata ;']);
            %         eval([subject_name '.(target_name).Vxyz{trial} = Vxyz ;']);
            %         eval([subject_name '.(target_name).Vm{trial} = Vm ;']);
            mtx(:,:,i) = rawdata;
        end
        % Data segmentation : subjects
        % Y coordinates > 0  or < 0 differentiate between subjects
        S = (squeeze(mean(mtx(30:60,2,:))) < 0);
        Msubj1 = find(S==1);
        Msubj2 = find(S==0);
        if sum(Msubj2 == Msubj1) >=1
            fprintf('Estrazione soggetti fallita\n')
            break
        end
        %         % Draw subject color
        %
        %         for jj = Msubj1'
        %             hold on
        %             plot3(mtx(1,1,jj),mtx(1,2,jj),mtx(1,3,jj),'ro')
        %         end
        %         for jj = Msubj2'
        %             hold on
        %             plot3(mtx(1,1,jj),mtx(1,2,jj),mtx(1,3,jj),'go')
        %         end
        %         grid on
        
        % Order markers according to Z-coordinates
        % Subject_1
        [y,i] = sort(squeeze(mtx(1,3,Msubj1)));
        foot = Msubj1(i(1));
        data.s1.foot.xyz{trial} = squeeze(mtx(:,:,foot));
        hand = Msubj1(i(2));
        data.s1.hand.xyz{trial} = squeeze(mtx(:,:,hand));
        mouth = Msubj1(i(3:end));
        % sort mouth Subject 1 (y<0) xcoord crescente è da sinistra verso
        % destra
        [y,i] = sort(squeeze(mtx(1,1,mouth)));
        data.s1.Lmouth.xyz{trial} =squeeze(mtx(:,:,mouth(i(1))));
        data.s1.Cmouth.xyz{trial} = squeeze(mtx(:,:,mouth(i(2))));
        data.s1.Rmouth.xyz{trial} = squeeze(mtx(:,:,mouth(i(3))));
        % Subject_2 xcoord crescente è e destra vesro sinistra
        [y,i] = sort(squeeze(mtx(1,3,Msubj2)));
        foot = Msubj2(i(1));
        data.s2.foot.xyz{trial} = squeeze(mtx(:,:,foot));
        hand = Msubj2(i(2));
        data.s2.hand.xyz{trial} = squeeze(mtx(:,:,hand));
        mouth = Msubj2(i(3:end));
        % sort mouth Subject 1 (y<0) xcoord crescente è da sinistra verso
        % destra
        [y,i] = sort(squeeze(mtx(1,1,mouth)));
        data.s2.Rmouth.xyz{trial} = squeeze(mtx(:,:,mouth(i(1))));
        data.s2.Cmouth.xyz{trial} = squeeze(mtx(:,:,mouth(i(2))));
        data.s2.Lmouth.xyz{trial} = squeeze(mtx(:,:,mouth(i(3))));
        % filter data
        subj_str = {'s1' 's2'};
        label = {'foot' 'hand' 'Rmouth' 'Cmouth' 'Lmouth'};
        for subj = 1:2
            for labM = 1:5
                %data.(subj_str{subj}).(label{labM}).xyz{trial}(data.(subj_str{subj}).(label{labM}).xyz{trial}== 0) = NaN;
                data.(subj_str{subj}).(label{labM}).xyzf{trial} = filtra_coord(filtro,data.(subj_str{subj}).(label{labM}).xyz{trial});
                Vxyz = [0 0 0 ; diff(data.(subj_str{subj}).(label{labM}).xyzf{trial})*filtro.coord.fc];
                Vm = [sqrt(sum(Vxyz.^2,2))];
                data.(subj_str{subj}).(label{labM}).Vxyz{trial} = Vxyz;
                data.(subj_str{subj}).(label{labM}).Vm{trial} = Vm;          
                
                %             % First 100 sample baseline
                %             Vo = mean(Vm(1:75));
                %             Vo_std = std(Vm(1:75));
                %              data.(subj_str{subj}).(label{labM}).Vo_m{trial} = Vo;
                %              data.(subj_str{subj}).(label{labM}).Vo_std{trial} = Vo_std;
                %              % first samples over 1 std or 2 std
                %              %find(Vm >= Vo + 2*Vo_std,1,'first')
                %              To_samples = find((Vm >= 100),1,'first');
                %              data.(subj_str{subj}).(label{labM}).To_samples{trial} =  To_samples;
                %              if not(isempty(To_samples))
                %                  figure(1)
                %                  title([num2str(subj) ' ' label{labM}]);
                %              else
                %                  title_label='';
                %              end
                %
                %              hold on
                %              plot(Vm)
                %              plot( To_samples,Vm(To_samples),'ro')
                
                figure(subj)
                set(0, 'CurrentFigure', subj);
                subplot(3,2,labM)
                
                hold on
                plot(Vm)
                %                 title(label{labM})
                drawnow
                
                
            end
        end
        % Calcolo Area Bocca
        
        %
        %                 a = data.s1.Rmouth.xyzf{trial} -
        %                 b
        %                 c
    else
        fprintf('Marker attesi 10, Marker trovati %d abort trial\n',nItems)
        trial_err = [trial_err trial]
    end
    
    
end
save('data.mat', 'data', 'trial_err')

