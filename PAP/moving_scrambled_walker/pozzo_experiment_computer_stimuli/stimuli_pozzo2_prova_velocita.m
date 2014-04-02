close all
sca
clear all
%----------Configuration-----------------
stimuli_set = {'stick', 'bounce'}; %stick-bounce
stimuli = stimuli_set{1};
load_type ='mat'; % mat-c3d
marker_set  = {'LBHD','LSHO','LELB','RELB','LWRA','RWRB','LPSI','LKNE','RKNE','LANK','RANK','LTOE','RTOE'};
% marker_set  = {'LANK','RANK'};%{'LANK','RELB'};%
%LBDH LeftSHOulder LeftELBow RightELBow LeftWRA?WRIST?  RightWRistB? LPSI?
%1      2              3         4           5               6          7
%LeftKNEE RightKNEE LeftANKle RightANKle LeftTOE RightTOE
%8           9        10           11       12      13
xrev = 'off'; % on-off cambia direzione x
yrev = 'off'; % on-off cambia direzione y
central ='off';  % on-off fissa nel centro
time_deformed=0; %if ==1, fa variare la velocità...
rallenty=0;
add_noise_alg = 1;
stimulus_time=4.4;
bicycle=1;
debug = 0;
dot_size = 4; %dimensione pallino
plane=[2 3]; % piano di visualizzazione 1=x :: 2=y :: 3=z
N_iter = 1; % Number of repeated video
x_offset = 0.5;
y_offset = 0.33;
delta_y=0;

if strcmp(central,'on')
    y_offset = 0.5;
end

if strcmp(xrev,'off')
    str_1 = 'LR';
else
    str_1 = 'RL';
end
if strcmp(yrev,'on')
    str_3 = 'inverso';
else
    str_3 = 'dritto';
end
if strcmp(central,'on')
    str_2 = 'centrale';
else
    str_2 = 'movimento';
end
%--------Video configuration-----------------
flag_record_avi = 0; %flag avi creation
video_freq = 75;
video_quality = 80;
codec ={'Indeo3';'Indeo5';'Cinepak';'MSVC';'RLE';'None'};
used_codec = 2;
% avi_file = [codec{used_codec} '_' stimuli '_' num2str(video_freq) '.avi'];
%avi_file = [str_1 '_ankle_' str_2 '_' str_3 '3sec.avi'];
avi_file= 'scramble_video.avi';%'LR_ankle_dritto_3sec.avi';
%---------------------------------------------

flipSpdback = 0;
flipSpdwindow = 0;
black = [0 0 0];
blue =  [100 100 250];
red = [200 50 50];
white = [255 255 255];
green=[10 255 10];

% Inizializzazione test
rec = Screen('Rect',0);
[W, H]=Screen('WindowSize', 0);
[window, rect] = Screen('OpenWindow', 0, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);
%alpha=monitorFlipInterval %monitorFlipInterval is 1/refresh_rate_of_the_monitor
%monitorFlipInterval=1/85;
Screen('CloseAll');
%-------------------------
%----CROCE----
cross_center = [W/2-12 W/2+12 W/2 W/2; H/2 H/2 H/2-12 H/2+12];
%------------

%----STICK-------
if strcmp(stimuli,'stick')
    %Carico i dati
    if strcmp(load_type,'mat')
        load('C:\Documents and Settings\BMILab\My Documents\MATLAB\Alejo\pozzo_experiment\walk1');
    else if strcmp(load_type,'c3d')
            [c3d] = create_struct();
        else
            disp(['Controlla :: ' load_type ' formato non conosciuto usa solo mat o c3d' ])
        end
    end
    %Genero matrici di lavoro
    mtx = c3d.mtx_filt_data;
    N_frames = length(mtx);
    Num_marker = length(marker_set);
    coord_1_raw = zeros(Num_marker,N_frames);
    coord_2_raw = zeros(Num_marker,N_frames);
    for j = 1:Num_marker
        coord_1_raw(j,:) = double(shiftdim(c3d.(marker_set{j}).filt_data(:,plane(1)),1));
        coord_2_raw(j,:) = double(shiftdim(c3d.(marker_set{j}).filt_data(:,plane(2)),1));
    end    
    %Interpolazione a frequenza monitor
    fc = c3d.FrameRate;
    monitor_freq = 1/monitorFlipInterval;
    N_resampled = round((N_frames/fc) * monitor_freq); %questo è il nuovo numero di frames che ci vorranno per riprodurre
    %l'animazione nel computer dove si ranna lo script, per preservare
    %l'impressione della velocità con cui avvengono i movimenti
    x = 1:N_frames;
    xi = 1:(N_frames/N_resampled):N_frames;
    coord_1 = interp1(x,coord_1_raw',xi)';
    coord_2 = interp1(x,coord_2_raw',xi)'; 
    video_freq = monitor_freq;
end 
%----END STICK-------

%------BOUNCER------
if strcmp(stimuli,'bounce')
    monitor_freq = 1/monitorFlipInterval;  
    %Parametri configurazione bounce
    %Tempo totale bouncing
    time_bounce = 5;
    N_frames = round(monitor_freq)*time_bounce;
    %Numero di bouncing
    N_bounce_1 = 4;
    N_bounce_2 = 4;
    freq_bounce_1 = N_bounce_1/(2*N_frames);
    freq_bounce_2 = N_bounce_2/(2*N_frames); 
    phase_bounce_1 = 0;
    phase_bounce_2 = pi;
    H_ratio_1 = .03;
    H_ratio_2 = .03;
    coord_1(1,:) = 0:N_frames;
    coord_2(1,:) = (H*H_ratio_1*(abs(sin((coord_1(1,:))*2*pi*freq_bounce_1+phase_bounce_1))));
    %2 Bouncing Ball
    x_shift = 40;
    coord_1(2,:) = (0:N_frames)+x_shift;
    coord_2(2,:) = (H*H_ratio_2*(abs(sin((coord_1(2,:))*2*pi*freq_bounce_2+phase_bounce_2))));
    
    Num_marker = 2;
end
%----END BOUNCER------


%-------Estrazione estremi----------
coord_1_min = min(min(coord_1));
coord_2_min = min(min(coord_2));
coord_1_max = max(max(coord_1));
coord_2_max = max(max(coord_2));
d_coord_1 = coord_1_max-coord_1_min;
d_coord_2 = coord_2_max-coord_2_min;
%-----------------------------------

% Processo di scaling dei dati li riporto con origine in zero
coord_1_zero = (coord_1-coord_1_min);
coord_2_zero = (coord_2-coord_2_min);
% Devo scalare entrambe le coordinate dello stesso fattore. Tale fattore è
% il numero piu grande tra il rapporto tra la massima misura in millimetri
% e la corrispondente misura in pixel.
scaled_1 = d_coord_1/W;
scaled_2 = d_coord_2/H;
scaled_f = max([scaled_1 scaled_2]);
coord_1_scaled = coord_1_zero/scaled_f;
coord_2_scaled = coord_2_zero/scaled_f;

% qui ho le coordinate opportunamente scalate per poterlo eventualmente fissare al centro dello schermo
if strcmp(central,'off')
    % non modifica niente
    if strcmp(xrev,'off')
        pix_traj(1,1:Num_marker,:) = double(coord_1_scaled);
    end
    if strcmp(xrev,'on')
        pix_traj(1,1:Num_marker,:) = W-double(coord_1_scaled);
    end
    if strcmp(yrev,'off')
        pix_traj(2,1:Num_marker,:) = H-double(coord_2_scaled) - H * y_offset;
    end
    if strcmp(yrev,'on')
        pix_traj(2,1:Num_marker,:) = double(coord_2_scaled) + H * y_offset;
    end

end

if strcmp(central,'on')
    % Calcolo baricentro
    coord_1_scaled_center = mean(coord_1_scaled);
    coord_2_scaled_center = mean(coord_2_scaled);
    %sottraggo alle coord il centroide
    coord_1_scaled=coord_1_scaled-repmat(coord_1_scaled_center,Num_marker,1);
    coord_2_scaled=coord_2_scaled-repmat(coord_2_scaled_center,Num_marker,1);
    if strcmp(xrev,'off')
        pix_traj(1,1:Num_marker,:) = double(coord_1_scaled) + W * x_offset;
    end
    if strcmp(xrev,'on')
        pix_traj(1,1:Num_marker,:) = W-double(coord_1_scaled) - W * x_offset;
    end
    if strcmp(yrev,'off')
        pix_traj(2,1:Num_marker,:) = H-double(coord_2_scaled) - H * y_offset;
    end
    if strcmp(yrev,'on')
        pix_traj(2,1:Num_marker,:) = double(coord_2_scaled) + H * y_offset;
    end
end

%-------Estrazione estremi frame stick----------
coord_1_min = min(min(pix_traj(1,:,:)));
coord_2_min = min(min(pix_traj(2,:,:)));
coord_1_max = max(max(pix_traj(1,:,:)));
coord_2_max = max(max(pix_traj(2,:,:)));
d_coord_1 = coord_1_max-coord_1_min;
d_coord_2 = coord_2_max-coord_2_min;
%-----------------------------------

% Algoritmo per l'introduzione del rumore nelle traiettorie
if add_noise_alg
    rand('seed',410)    
    for j = 1:Num_marker

        % Frame del marker j-esimo
        Mcoord_1_min = min(min(pix_traj(1,j,:)));
        Mcoord_2_min = min(min(pix_traj(2,j,:)));
        Mcoord_1_max = max(max(pix_traj(1,j,:)));
        Mcoord_2_max = max(max(pix_traj(2,j,:)));
        Md_coord_1 = Mcoord_1_max-Mcoord_1_min;
        Md_coord_2 = Mcoord_2_max-Mcoord_2_min;
        DX = d_coord_1 - Md_coord_1;
        DY = d_coord_2 - Md_coord_2;   
        
        noisex = DX*rand(1);
        noisey = DY*rand(1);

        pix_traj(1,j,:) = pix_traj(1,j,:) - Mcoord_1_min + coord_1_min +noisex ;
        pix_traj(2,j,:) = pix_traj(2,j,:) - Mcoord_2_min + coord_2_min +noisey;
    end
    
    inv_scramble2=pix_traj;
% 
%     
%     %Versione 1 :: aggiungo deviazioni alla traiettoria smooth, l'algoritmo
%     %consiste nel sovrapporre una certa V (vx,vy) alla traiettoria
%     %esistente la V è generata in modo da essere smooth facendo in modo che
%     %ad ogni istante sia piccola la viariazione di velocità    
%     % Creazione velocità smooth
%     rand('seed',110)
%     Ag = 0.00080;
%     Ax = Ag*rand(Num_marker,N_resampled) - Ag/2;
%     Ay = Ag*rand(Num_marker,N_resampled) - Ag/2;    
%     Vx = cumsum(Ax')*fc;
%     Vy = cumsum(Ay')*fc;
%     Xn = cumsum(Vx')*fc;
%     Yn = cumsum(Vy')*fc;
%     [B,A] = butter(2,0.1);
%     Xn_f = filtfilt(B,A,Xn');
%     Yn_f = filtfilt(B,A,Yn');
%     
%     pix_traj(1,:,:) = squeeze(pix_traj(1,:,:))+Xn_f';
%     pix_traj(2,:,:) = squeeze(pix_traj(2,:,:))+Yn_f';      
%     %Alejo      
end

%parte del codice per far cambiare la velocità dell'animazione, in modo
%tale da darle un profilo di velocità poco biologico
for marker=1:13

denom=3;
num_frames=67; %num_frames is the nb of frames on which the building-block time-deforming function is defined
shift=ceil(rand(1)*num_frames); %the number of frames by which I want to shift the animation
cycle_frames=1:num_frames; 
time_trans=ceil(length(cycle_frames)^((denom-1)/denom)*cycle_frames.^(1/denom));
deformed_time=time_trans(num_frames-shift+1:num_frames)-time_trans(num_frames-shift+1)+1;
n_blocks=0;
while deformed_time(n_blocks*num_frames+shift)<268 %268 is the total number of frames of the original animation in a 60 Hz refresh rate monitor
    deformed_time=cat(2,deformed_time,time_trans+deformed_time(n_blocks*num_frames+shift));
    n_blocks=n_blocks+1;
end
indices=find(deformed_time<268);
def_time{marker}=deformed_time(indices);
clear denom shift cycle_frames time_trans n_blocks indices num_frames
end
lunghezze=[];
for marker=1:13
    lunghezze=cat(2,lunghezze,length(def_time{marker}));
end
common_length=min(lunghezze);

for marker=1:13
    differentsnapshots(marker,:)=def_time{marker}(1:common_length);
end
%fine di questa parte incasinata

% if add_noise_alg==0 & length(marker_set)==13
%     if strcmp(yrev,'off')
%         walker=pix_traj;
%     end
%     if strcmp(yrev,'on')
%         walkerupdown=pix_traj;
%     end
% end
% 
% if add_noise_alg==0 & length(marker_set)==2
%     ankles=pix_traj;
% end

% if strcmp(central,'on')
%     coord_1_scaled_center = (coord_1_scaled(1,:)); %fisso un marker
%     coord_2_scaled_center = (coord_1_scaled(1,:)); %fisso un marker
%     %Li fisso entrambi solo sulla x
%     coord_1_scaled=coord_1_scaled-repmat(coord_1_scaled_center,13,1);
%     coord_2_scaled=coord_2_scaled-repmat(coord_2_scaled_center,13,1);
% end

% scramble2=pix_traj;
if time_deformed==1
if size(pix_traj,2)==13
    for marker=1:13
        pix_traj(:,marker,1:common_length)=pix_traj(:,marker,differentsnapshots(marker,:));
    end
end
snapshots=1:common_length;
else
    snapshots=1:round(monitor_freq*stimulus_time);

end

if flag_record_avi
    % Create black figure
    rec_fig = figure;
    set(rec_fig,'Position',rect,...
        'MenuBar','none',...
        'Toolbar','none',...
        'NextPlot','replacechildren',...
        'Visible','off',...
        'DoubleBuffer','on');

    %initializing file
    mov = avifile(avi_file,...
        'compression',codec{used_codec},...
        'fps',video_freq,...
        'keyframe',20,...
        'quality',video_quality);
    test= getframe(rec_fig);
    test.cdata=[];
    ANIM = struct(test);
end

 if rallenty
     rand('seed',180);
   Indexes1=[1];
   while size(Indexes1,2)<268
       count=abs(ceil(3*rand(1)));
       addendum=(Indexes1(1,size(Indexes1,2))+1)*ones(1,count);
       Indexes1=cat(2,Indexes1,addendum);
       %fprintf('llegue hasta aca\n');
   end   
   if size(Indexes1,2)>268
       Indexes1=Indexes1(1:268);
   end
% Indexes1=[1];
%    while size(Indexes1,2)<268
%        addendum=ceil(abs(267*rand(1)));       
%        Indexes1=cat(2,Indexes1,addendum);
%    end
%    Indexes1=sort(Indexes1);
%    if size(Indexes1,2)>268
%        Indexes1=Indexes1(1:268);
%    end
   
   Indexes2=[1];
   while size(Indexes2,2)<268
       addendum=ceil(abs(267*rand(1)));       
       Indexes2=cat(2,Indexes2,addendum);
   end
   Indexes2=sort(Indexes2);
   if size(Indexes2,2)>268
       Indexes2=Indexes2(1:268);
   end
% Indexes=1:268;
%    for i=0:267
%        aux(i+1)=Indexes(268-i);
%    end
%    Indexes=aux;

   pix_traj(:,1,:)=pix_traj(:,1,Indexes1);
   pix_traj(:,2,:)=pix_traj(:,2,Indexes2);
 end

 % Algoritmo per l'introduzione del rumore nelle traiettorie
% if add_noise_alg
%     rand('seed',410)    
%     for j = 1:Num_marker
% 
%         % Frame del marker j-esimo
%         Mcoord_1_min = min(min(pix_traj(1,j,:)));
%         Mcoord_2_min = min(min(pix_traj(2,j,:)));
%         Mcoord_1_max = max(max(pix_traj(1,j,:)));
%         Mcoord_2_max = max(max(pix_traj(2,j,:)));
%         Md_coord_1 = Mcoord_1_max-Mcoord_1_min;
%         Md_coord_2 = Mcoord_2_max-Mcoord_2_min;
%         DX = d_coord_1 - Md_coord_1;
%         DY = d_coord_2 - Md_coord_2;   
%         
%         noisex = DX*rand(1);
%         noisey = DY*rand(1);
% 
%         pix_traj(1,j,:) = pix_traj(1,j,:) - Mcoord_1_min + coord_1_min +noisex ;
%         pix_traj(2,j,:) = pix_traj(2,j,:) - Mcoord_2_min + coord_2_min +noisey;
%     end
% 
%     
%     %Versione 1 :: aggiungo deviazioni alla traiettoria smooth, l'algoritmo
%     %consiste nel sovrapporre una certa V (vx,vy) alla traiettoria
%     %esistente la V è generata in modo da essere smooth facendo in modo che
%     %ad ogni istante sia piccola la viariazione di velocità    
%     % Creazione velocità smooth
% %     rand('seed',120)
% %     Ag = 0.00040;
% %     Ax = Ag*rand(Num_marker,N_resampled) - Ag/2;
% %     Ay = Ag*rand(Num_marker,N_resampled) - Ag/2;    
% %     Vx = cumsum(Ax')*fc;
% %     Vy = cumsum(Ay')*fc;
% %     Xn = cumsum(Vx')*fc;
% %     Yn = cumsum(Vy')*fc;
% %     [B,A] = butter(2,0.1);
% %     Xn_f = filtfilt(B,A,Xn');
% %     Yn_f = filtfilt(B,A,Yn');
% %     
% %     pix_traj(1,:,:) = squeeze(pix_traj(1,:,:))+Xn_f';
% %     pix_traj(2,:,:) = squeeze(pix_traj(2,:,:))+Yn_f';      
% % %     %Alejo      
% end

if bicycle
    %time=1:268;
    f=-0.1;
    phase=1.2;
    X=720;
    Y=450;
    amplitude=45;
    for i=1:268
    right_foot(:,i)=[amplitude*cos(-f*i)+X;amplitude*sin(-f*i)+Y];
    left_foot(:,i)=[amplitude*cos(-f*i+phase)+X;amplitude*sin(-f*i+phase)+Y];
    feet(:,:,i)=[squeeze(right_foot(:,i)) squeeze(left_foot(:,i))];%; squeeze(right_foot(:,i)) squeeze(left_foot(:,i))];
    end
    %feet=[right_foot left_foot; right_foot left_foot];
end



[window, rect] = Screen('OpenWindow', 0, black, rec);
HideCursor;
sc = W/H;
Ly = 50;
Lx = round(Ly*sc);
tic
for iter = 1:N_iter
    if debug == 0
        % Per fare tempi fissati usare round(monitor_freq*s) dove s è il numro di
        % secondi del video; 
        for i=snapshots%1:round(monitor_freq*stimulus_time)%length(pix_traj) %
            Screen('DrawLines', window, cross_center, 3, red);
            % Commentare questa riga se si vuole solo la croce
            Screen('FillOval', window, white, round([squeeze(pix_traj(:,:,i))+repmat([0;delta_y],1,size(pix_traj,2)) - dot_size ; squeeze(pix_traj(:,:,i))+repmat([0;delta_y],1,size(pix_traj,2)) + dot_size]));  %creo il pallino blu
%             Screen('FillOval', window, white, round([1440-squeeze(pix_traj(1,:,i)) - dot_size ; squeeze(pix_traj(2,:,i)) - dot_size ; 1440-squeeze(pix_traj(1,:,i)) + dot_size; squeeze(pix_traj(2,:,i)) + dot_size ]));  
            %Screen('FillOval', window, white, round([feet(:,:,i)-dot_size; feet(:,:,i)+dot_size ]));
            %[xx,yy] = Screen('DrawText', window, num2str(i),50 ,50 ,white);
            %vbl=Screen('Flip', window, vbl+(flipSpdwindow*monitorFlipInterval),0);
            Screen('Flip', window);
            if flag_record_avi
%                 ANIM = getframe(rec_fig,[Lx Ly W-2*Lx H-2*Ly]);
                ANIM = getframe(rec_fig);
                mov = addframe(mov,ANIM);
            end
        end
    end
    if debug == 1
        ShowCursor
        i=1;
        step_frame = 1;
        while (1)            
            Screen('DrawLines', window, cross_center, 3, red);
            Screen('FillOval', window, white, round([squeeze(pix_traj(:,:,i)) - dot_size ; squeeze(pix_traj(:,:,i)) + dot_size]));  %creo il pallino blu
            [xx,yy] = Screen('DrawText', window, num2str(i),W/2 ,50 ,white);            
            [xx,yy] = Screen('DrawText', window, 'a::rewind',50 ,50 ,white);
            [xx,yy] = Screen('DrawText', window, 'd::forward',50 ,75 ,white);
            [xx,yy] = Screen('DrawText', window, '+::increase step',50 ,100 ,white);
            [xx,yy] = Screen('DrawText', window, '-::decrease step',50 ,125 ,white);
            [xx,yy] = Screen('DrawText', window, ['step = ' num2str(step_frame)],50 ,150 ,white);
            Screen('Flip', window);
            ch = GetChar;
            if strcmp(ch,'a')
                i=i-step_frame;
                if i<=0
                    i=1;
                end
            end
            if strcmp(ch,'d')
                i=i+step_frame;
                if i>=N_resampled
                    i=N_resampled;
                end
            end
            if strcmp(ch,'+')
                step_frame = step_frame+1;                
            end
            if strcmp(ch,'-')
                step_frame = step_frame-1;
                if step_frame<=0
                    step_frame = 1;
                end
                
            end
            if strcmp(ch,' ')
                break
            end
        end
    end
end
ShowCursor;
if flag_record_avi
    mov = close(mov);
end
toc
Screen('Flip', window);
Screen('CloseAll');

sca;