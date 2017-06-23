%% randhist.m
for i = 1:5
    temp = rand(1, 1000000);
    figure
    histogram(temp)
end