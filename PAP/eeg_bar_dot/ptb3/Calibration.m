% Screen('Preference', 'SkipSyncTests',1);
% Screen('Preference', 'VisualDebugLevel', 0);
% Screen('Preference', 'SuppressAllWarnings', 1);
 
whichScreen = 0; 
perc_hidden = [];

stop = 0;
data = [];
   
flipSpdwindow = 0; 
flipSpdback = 0; 

xmopo=[1 0 1 0]; 
ymopo=[0 1 0 1]; 

mopo=[-1 -1 1 1];
dimi = [3 1 ; 1 3];


white = [255 255 255];
gray = [100 100 100];
black = [0 0 0];
blue = [100 100 250]; 
red = [200 50 50];



rec = Screen('Rect',0);
[W, H]=Screen('WindowSize', whichScreen);
W=800;
[window, rect] = Screen('OpenWindow', whichScreen, black, rec);
monitorFlipInterval = Screen('GetFlipInterval', window);


Page = Screen(window, 'OpenOffScreenWindow');
Screen('FillRect', Page, 1);

 

halfsize_pal = 8; 

Screen('HideCursorHelper', window);

for i = 1:2 
            
             
    Screen('FillOval', window, blue, [W/2 H/2-150 W/2 H/2-150]+mopo*halfsize_pal);
    Screen('FillOval', window, blue, [W/2+200 H/2-150 W/2+200 H/2-150]+mopo*halfsize_pal);
    Screen('FillOval', window, blue, [W/2 H/2+250 W/2 H/2+250]+mopo*halfsize_pal);
    Screen('Flip', window);


    
    while (1)
        [x,y,buttons] = GetMouse(window);


        if buttons(3) || KbCheck
            stop =1; %
            break;
        end
    end 
   
    if stop
        break;
    end

end
Screen('CloseAll');
sca
