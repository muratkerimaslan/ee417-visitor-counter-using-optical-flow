%%
clear all; close all; clc;
% Load the files given in SUcourse as Seq variable [row,col,num]=size(Seq);

load("walk3.mat");

Seq = walk3;
[row,col,dummy,num]=size(Seq);
Threshold = 30000;
k = 15;


% ImPrev = Seq(:,:,1);
% ImCurr = Seq(:,:,2);
% lab7OF2(ImPrev,ImCurr,k,Threshold);
%j = 2;
 %ImPrev = Seq(:,:,j-1);
 %ImCurr = Seq(:,:,j);
%lab7OF_P(ImPrev,ImCurr,k,Threshold);

%%
% Define k and Threshold
arrow_per_frame = zeros(1,num); %
step_size = 1; % must be 1
tic
for j=1+step_size:step_size:num
    
         ImPrev = Seq(:,:,:,j-step_size);
         ImCurr = Seq(:,:,:,j);
         ImPrev = rgb2gray(ImPrev);
         ImCurr = rgb2gray(ImCurr);
         arrow_per_frame = proj_OF_loop(ImPrev,ImCurr,k,Threshold,arrow_per_frame,j-1,step_size);
         pause(0.001);
end
toc
%display(arrow_per_frame);
%person_count = count_ins2(arrow_per_frame,step_size);
%display(person_count);


%%
