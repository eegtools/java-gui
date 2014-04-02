clear all
close all
% ===================================================================
% SETTINGS
% ===================================================================
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'SuppressAllWarnings', 0);

debug=0;
% ===================================================================
% MAIN SCREEN SETTINGS
% ===================================================================
black = [0 0 0];
white = [255 255 255];
screenid=max(Screen('Screens'));

if debug
    W=750; H=300; rec = [0,0,W,H]; 
else
    rec = Screen('Rect',0);[W, H]=Screen('WindowSize', 0);
end
% ===================================================================
% FILE SETTINGS
% ===================================================================
... filename='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\test.avi';
movie_path='E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3';
filename='test.avi';

% ==================================================================================================
% ==================================================================================================
try
    AssertOpenGL;
    
    [mainwin, rect] = Screen('OpenWindow', screenid, black, rec);
    Screen('Flip',mainwin);

    % START PLAYBACK
    showMovie(fullfile(movie_path, filename), mainwin); ..., 'rotation', 0);
    
    sca
    
 catch error
    % display error
    error.identifier
    error.message
    error.stack

    Screen('CloseAll');
end
