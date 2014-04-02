

fc = 10000;
ft = 440;
Tmax = 0.025;

t = linspace(0,4,Tmax*fc);
s = sin(2*pi*ft.*t);

set(ao,'SampleRate',fc)

chans = addchannel(ao,1);
putdata(ao,s')