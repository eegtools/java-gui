% addr=hex2dec('378')
% lptwrite(addr, 0)
% for code=1:255
%     lptwrite(addr, code);
%     pause(0.1);
%     lptwrite(addr, 0);
% end
%     

for d=1:19
    variable = sprintf('acceldata_%d',d);
    plot_accell(eval(variable), 4, 4000)
end