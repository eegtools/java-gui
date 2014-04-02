% Screen('Preference', 'SkipSyncTests',1);
% Screen('Preference', 'VisualDebugLevel', 0);
% Screen('Preference', 'SuppressAllWarnings', 1);
 
whichScreen = 0;  %per dire su quale schermo lavorare
perc_hidden = [];

stop = 0;
data = [];
   
flipSpdwindow = 0; 
flipSpdback = 0; 

xmopo=[1 0 1 0]; 
ymopo=[0 1 0 1]; 

mopo=[-1 -1 1 1];
dimi = [3 1 ; 1 3];

%%%%%%%%%%%%%%%%%%%%%%%%  DEFINIZIONE  COLORI  %%%%%%%%%%%%%%%%%%%%%%%%%%%
white = [255 255 255];
gray = [100 100 100];
black = [0 0 0];
blue = [100 100 250]; 
red = [200 50 50];

%%%%%%%%%%%%%%%%%%%%%%%%  APERTURA FINESTRE DI LAVORO %%%%%%%%%%%%%%%%%%%%

%mi crea ed apre una finestra online
rec = Screen('Rect',0);
[W, H]=Screen('WindowSize', whichScreen);
W=800;
[window, rect] = Screen('OpenWindow', whichScreen, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);

%mi crea una finestra offline nera
Page = Screen(window, 'OpenOffScreenWindow');
Screen('FillRect', Page, 1);

 

%%%%%%%%%%%%%%%%%%%%%%%%    DIMENSIONE OGGETTI   %%%%%%%%%%%%%%%%%%%%%%%%
halfsize_pal = 8; %raggio del pallino

Screen('HideCursorHelper', window);

for i = 1:2 %non so perchè, ma mettendo questo ciclo for riesco ad uscire dal 
            %programma schiacciando o tasto sx del mouse o tastiera. se non
            %lo metto non m lo fa....mah...
            
             
    %%%% è per far vedere due pallini fermi e fare la calibrazione
    Screen('FillOval', window, blue, [W/2 H/2-150 W/2 H/2-150]+mopo*halfsize_pal);
    Screen('FillOval', window, blue, [W/2+200 H/2-150 W/2+200 H/2-150]+mopo*halfsize_pal);
    Screen('FillOval', window, blue, [W/2 H/2+250 W/2 H/2+250]+mopo*halfsize_pal);
    Screen('Flip', window);


    %per dirgli di aspettare il click del mouse tra un trial e l'altro
    while (1)
        [x,y,buttons] = GetMouse(window);

        % if buttons(1)
        %     Screen('Flip', window);
        %     break;
        % end

        if buttons(3) || KbCheck
            stop =1; %
            break;
        end
    end % Si ma se non cambi lo stato del while ovvio che succedono casini è in un loop infinito
   
    if stop
        break;
    end

end
Screen('CloseAll');
sca
