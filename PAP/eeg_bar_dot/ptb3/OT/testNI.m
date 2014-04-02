
% Test National Instruments Acquisition

% Adding Library PATH
addpath(genpath('F:\WorkingDir\Toolbox\daq_distrib\include'));
addpath(genpath('F:\WorkingDir\Toolbox\daq_distrib\lib'));
addpath(genpath('F:\WorkingDir\Toolbox\daq_distrib\bin'));

%run mex -setup to configure compiler
%Load the Dll
loadlibrary('cdaq', 'cdaq.h')
libfunctions('cdaq') %Display all functions available from the library