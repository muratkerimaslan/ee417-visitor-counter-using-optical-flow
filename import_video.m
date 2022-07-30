
clc;clear;
v = VideoReader('417proj480p4.mov');
walk4 = read(v);  %read all frames
clear v   %release it
save('walk4.mat', 'walk4');