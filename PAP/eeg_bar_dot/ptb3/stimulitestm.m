window = screen_param.window;

err = show_stimuli(CROSS,window,screen_param);

BAR.xstart = 0;
BAR.xstop = screen_param.W;
BAR.yposition = CROSS.yposition+25;
err = show_stimuli(BAR,window,screen_param);

BARD.bar.xstart = 0;
BARD.bar.xstop = screen_param.W;
BARD.bar.yposition = CROSS.yposition+50;
BARD.dot.xposition = protocol_param.xleft;
BARD.dot.yposition = CROSS.yposition+50;
err = show_stimuli(BARD,window,screen_param);

DOT.xposition = protocol_param.xright;
DOT.yposition = CROSS.yposition+100;
err = show_stimuli(DOT,window,screen_param);

DOTD.dot.xposition = protocol_param.xleft;
DOTD.dot.yposition = CROSS.yposition+150;
DOTD.dis.xposition = protocol_param.xright;
DOTD.dis.yposition = CROSS.yposition+150;
err = show_stimuli(DOTD,window,screen_param);


Screen('Flip',window);
pause
