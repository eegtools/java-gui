


for n=2:9

    pp(uint8([n]),[1],false, uint8(1),uint64(45104));   ... 64
    WaitSecs(0.1);
    pp(uint8([n]),[0],false, uint8(1),uint64(45104));
    WaitSecs(0.1);
end




pp(uint8([2 3 4 5 6 7 8 9]),[1 0 0 0 0 0 0 0],false, uint8(1),uint64(45104));
pp(uint8([2 3 4 5 6 7 8 9]),[0 0 0 0 0 0 0 0],false, uint8(1),uint64(45104));