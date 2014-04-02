 devices=imaqhwinfo('winvideo')
ndev=length(devices);

supportedFormats={devices(1).DeviceInfo.SupportedFormats};

...for dev=1:ndev
...    
...end

vid = videoinput('winvideo', 1, 'I420_1280x720');
src = getselectedsource(vid);

vid.FramesPerTrigger = 90;
vid.TriggerRepeat = 0;
vid.LoggingMode = 'disk';

diskLogger = VideoWriter('E:\Matlab\EEG_tools_svn\see_you_see_me\ptb3\examples\test.mp4', 'MPEG-4');
diskLogger.FrameRate = 30;

vid.DiskLogger = diskLogger;



triggerconfig(vid, 'immediate');


preview(vid);
start(vid);