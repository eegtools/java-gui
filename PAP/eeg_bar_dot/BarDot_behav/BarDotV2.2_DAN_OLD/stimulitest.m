% Open window
[window, rect] = Screen('OpenWindow', 0, screen_param.color.black , screen_param.rect);

monitorFlipInterval = Screen('GetFlipInterval', window);
%Show moving DOT until keypressed
keyIsDown = 0;
count = 0;
% create 30 random a and b
a = 5*rand(40,1)+1;
b = 5*rand(40,1)+1;
while not(keyIsDown)
    count = count + 2*pi/180;
    [x,y,buttons] = GetMouse;
    
    
    % Change DOT position
    for kk = 1:40
        DOT.xposition = x+250*sin(count/a(kk));
        DOT.yposition = y+250*cos(count/b(kk));
        DOT = update_stimuli(DOT);
        [err] = show_stimuli(DOT,window,screen_param);
    end
    Screen('Flip', window,[],0);
    
    % Control Keypressed
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
end
sca