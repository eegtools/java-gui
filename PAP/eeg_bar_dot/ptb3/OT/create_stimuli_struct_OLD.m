% © EOG VICON © 
% Protocol for Visuo - Hand coordination in non-constrained targeting 
% Keywords : Optimal Control, Viso-Hand Coordination, PsychToolbox
% Fondazione Istituto Italiano Tecnologia
% Marco Jacono . Bastien Berret . Ambra Bisio
% 2011-2012
% 
% Creating stimulii data structure for : DOT BARD BAR CROSS according to screen
% paramenter and protocol parameters
%
% [DOT,DOT2,BAR, CROSS] = create_stimuli_struct(screen_param,protocol_param)
%
function [dot,bard,bar,dotd,cross] = create_stimuli_struct(screen_param,protocol_param,pointing_data_normalized)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definition of Stimulii Struct                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CROSS STIMULI                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER DATA FIELD %
%%%%%%%%%%%%%%%%%%%
%cross.yposition =  screen_param.H * protocol_param.upperY;
cross.yposition = protocol_param.ycross;
% In mean position respect to left and right baseline
cross.xposition = (protocol_param.xright+protocol_param.xleft)/2;

%cross.xposition =  screen_param.W / 2;
%%%%%%%%%%%%%%%%%%
% COMPUTED FIELD %
%%%%%%%%%%%%%%%%%%
cross.dim = 8; % Cross Dimension
cross.linedim = 3;
cross.color = [21 152 18]; % Green
cross.duration = 'wait';
cross.mtx_rel_coord = [-cross.dim cross.dim 0 0;0 0  -cross.dim cross.dim];
cross.mtx_coord = cross.mtx_rel_coord + repmat([cross.xposition;cross.yposition],1,4);
cross.stimulustype = 'cross';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOT STIMULI                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER DATA FIELD %
%%%%%%%%%%%%%%%%%%%
dot.xposition = screen_param.W/2;  % X position in pixel
dot.yposition = screen_param.H/2;  % Y position in pixel between [Ymin - Ymax]
%%%%%%%%%%%%%%%%%%
% COMPUTED FIELD %
%%%%%%%%%%%%%%%%%%
dot.dim_ext = 8;
dot.dim_int = 4;
oval.w.radius = dot.dim_ext; %dot radius
oval.b.radius = dot.dim_int;
oval.w.coord = [-oval.w.radius -oval.w.radius oval.w.radius oval.w.radius]';
oval.b.coord = [-oval.b.radius -oval.b.radius oval.b.radius oval.b.radius]';
dot.duration = 1; 
dot.mtx_coord = [oval.w.coord  oval.b.coord] +  repmat([dot.xposition;dot.yposition;dot.xposition;dot.yposition],1,2);
dot.stimulustype = 'dot';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BARD STIMULI                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER DATA FIELD %
%%%%%%%%%%%%%%%%%%%
bard.bar.yposition = screen_param.H/2;
bard.dot.xposition = screen_param.W/2;  % X position in pixel
bard.dot.yposition = screen_param.H/2;  % Y position in pixel between [Ymin - Ymax]
%%%%%%%%%%%%%%%%%%
% COMPUTED FIELD %
%%%%%%%%%%%%%%%%%%
bard.bar.xstart = 0;
bard.bar.xstop = screen_param.W;
bard.bar.mtx_coord =[bard.bar.xstart, bard.bar.xstop ; bard.bar.yposition, bard.bar.yposition];
bard.bar.dim = 15; % Line Dimension
bard.bar.duration = 'wait';
bard.bar.color = screen_param.color.gray;

bard.dot.dim_ext = 8;
bard.dot.dim_int = 4;
oval.w.radius = bard.dot.dim_ext; %dot radius
oval.b.radius = bard.dot.dim_int;
oval.w.coord = [-oval.w.radius -oval.w.radius oval.w.radius oval.w.radius]';
oval.b.coord = [-oval.b.radius -oval.b.radius oval.b.radius oval.b.radius]';
bard.dot.duration = 1; 
bard.dot.mtx_coord = [oval.w.coord  oval.b.coord] +  repmat([bard.dot.xposition;bard.dot.yposition;bard.dot.xposition;bard.dot.yposition],1,2);
bard.stimulustype = 'bard';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BAR STIMULI                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER DATA FIELD %
%%%%%%%%%%%%%%%%%%%
bar.yposition = screen_param.H/2;
%%%%%%%%%%%%%%%%%%
% COMPUTED FIELD %
%%%%%%%%%%%%%%%%%%
bar.xstart = 0;
bar.xstop = screen_param.W;
bar.mtx_coord =[bar.xstart, bar.xstop ; bar.yposition, bar.yposition];
bar.dim = 15; % Line Dimension
bar.duration = 'wait';
bar.color = screen_param.color.gray;
bar.stimulustype = 'bar';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DOTD STIMULI                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER DATA FIELD %
%%%%%%%%%%%%%%%%%%%
dotd.dot.xposition = screen_param.W/2;  % X position in pixel
dotd.dot.yposition = screen_param.H/2;  % Y position in pixel between [Ymin - Ymax]
dotd.dis.xposition = screen_param.W/2;  % X position in pixel
dotd.dis.yposition = screen_param.H/2;  % Y position in pixel between [Ymin - Ymax]
%%%%%%%%%%%%%%%%%%
% COMPUTED FIELD %
%%%%%%%%%%%%%%%%%%
dotd.dot.dim_ext = 8;
dotd.dot.dim_int = 4;
dotd.dis.dim_ext = 8;
dotd.dis.dim_int = 4;
oval.w.radius = dotd.dot.dim_ext; %dot radius
oval.b.radius = dotd.dot.dim_int;
oval.w.coord = [-oval.w.radius -oval.w.radius oval.w.radius oval.w.radius]';
oval.b.coord = [-oval.b.radius -oval.b.radius oval.b.radius oval.b.radius]';
dotd.duration = 1; 
dotd.dot.mtx_coord = [oval.w.coord  oval.b.coord] +  repmat([dotd.dot.xposition;dotd.dot.yposition;dotd.dot.xposition;dotd.dot.yposition],1,2);
dotd.dis.mtx_coord = [oval.w.coord  oval.b.coord] +  repmat([dotd.dis.xposition;dotd.dis.yposition;dotd.dis.xposition;dotd.dis.yposition],1,2);
dotd.stimulustype = 'dotd';
