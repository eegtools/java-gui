% © EOG VICON ©
% Protocol for Visuo - Hand coordination in non-constrained targeting
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
%
% Update struct properties according to stim type
%
% stim_struct = update_stimuli(stim_struct)
%
% Questa funzione aggiorna la struttura dei dati dello stimolo prima che
% questa venga visualizzata. In generale si occupa di definire le matrici
% coordinate sulla base del punto sullo schermo che si vuole visualizzare

function stim_struct = update_stimuli(stim_struct)

try
    case_flag = stim_struct.stimulustype;
    switch case_flag
        case 'dot'
            dot = stim_struct;
            
            dot.dim_ext = 8;
            dot.dim_int = 4;
            oval.w.radius = dot.dim_ext; %dot radius
            oval.b.radius = dot.dim_int;
            oval.w.coord = [-oval.w.radius -oval.w.radius oval.w.radius oval.w.radius]';
            oval.b.coord = [-oval.b.radius -oval.b.radius oval.b.radius oval.b.radius]';
            dot.duration = 1;
            dot.mtx_coord = [oval.w.coord  oval.b.coord] + ...
                repmat([dot.xposition;dot.yposition;dot.xposition;dot.yposition],1,2);
            stim_struct = dot;
                       
            
        case 'bard'
            bard = stim_struct;            
            bard.bar.mtx_coord =[bard.bar.xstart, bard.bar.xstop ; bard.bar.yposition, bard.bar.yposition];
                       
           
            bard.dot.dim_ext = 8;
            bard.dot.dim_int = 4;
            oval.w.radius = bard.dot.dim_ext; %dot radius
            oval.b.radius = bard.dot.dim_int;
            oval.w.coord = [-oval.w.radius -oval.w.radius oval.w.radius oval.w.radius]';
            oval.b.coord = [-oval.b.radius -oval.b.radius oval.b.radius oval.b.radius]';
            bard.dot.duration = 1;
            bard.dot.mtx_coord = [oval.w.coord  oval.b.coord] + ...
                repmat([bard.dot.xposition;bard.dot.yposition;bard.dot.xposition;bard.dot.yposition],1,2);
            stim_struct = bard;
            
            
        case 'cross'
        case 'bar'
            bar = stim_struct;
            bar.mtx_coord =[bar.xstart, bar.xstop ; bar.yposition, bar.yposition];
            stim_struct = bar;
    end
catch err
    Screen('CloseAll');
    sca
    err.message
    err.stack
end