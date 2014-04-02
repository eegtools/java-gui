lists=zeros(2,180);

lists(1,:)=1:180;
lists(2,:)=181:360;

cnt=0;
var=1;
for iter=lists(var,:)
    cnt=cnt+1;
    disp(iter); 
    
    if (var == 1)
        var=2;
    else
        var=1;
    end
    var
end
var
cnt

.... not working...goes on accessing lists(1,:)