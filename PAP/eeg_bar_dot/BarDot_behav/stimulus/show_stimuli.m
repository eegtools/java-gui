function [err] = show_stimuli(stim_struct,window,screen_param)

try
    case_flag = stim_struct.stimulustype;
    switch case_flag
        case 'dot'
            DOT = stim_struct;
            DOT = update_stimuli(DOT);                        
            Screen('FillOval', window, [screen_param.color.white' screen_param.color.black'],DOT.mtx_coord);            
            err = 0;
            
%          case 'dotd'
%             DOTD = stim_struct;
%             DOTD = update_stimuli(DOTD); 
%             
%             Screen('FillOval', window, [screen_param.color.white' screen_param.color.black'],DOTD.dot.mtx_coord); 
%             Screen('FillOval', window, [screen_param.color.blue' screen_param.color.black'],DOTD.dis.mtx_coord); 
%             err = 0;
            
        case 'bard'
            BARD = stim_struct;            
            BARD = update_stimuli(BARD);            
            
            Screen('DrawLines', window, BARD.bar.mtx_coord, BARD.bar.dim,BARD.bar.color); 
            Screen('FillOval', window, [screen_param.color.white' screen_param.color.black'],BARD.dot.mtx_coord);  
            err = 0;
            
        case 'barda'
            BARDA = stim_struct;            
            BARDA = update_stimuli(BARDA);            
            
            Screen('DrawLines', window, BARDA.bar.mtx_coord, BARDA.bar.dim,BARDA.bar.color); 
            Screen('Flip', window);
           % Show Blank 
            pause(0.05);
            %Screen('Flip', window);
            Screen('DrawLines', window, BARDA.bar.mtx_coord, BARDA.bar.dim,BARDA.bar.color);
            Screen('FillOval', window, [screen_param.color.white' screen_param.color.black'],BARDA.dot.mtx_coord);  
            err = 0;    
            
        case 'cross'
            CROSS = stim_struct;
            CROSS = update_stimuli(CROSS);
            Screen('DrawLines', window, CROSS.mtx_coord, CROSS.linedim, screen_param.color.green);
            err = 0;
            
        case 'bar'
            BAR = stim_struct;
            BAR = update_stimuli(BAR);
            Screen('DrawLines', window, BAR.mtx_coord, BAR.dim,BAR.color);            
            err = 0;     
            
    end
catch err
    Screen('CloseAll');
    sca    
    err.message
    err.stack 
    ListenChar(0);
    pause
    
end