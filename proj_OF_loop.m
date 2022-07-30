function arrow_per_frame_out = proj_OF_loop(ImPrev,ImCurr,k,Threshold,arrow_per_frame,frame_index,step)
% Smooth the input images using a Box filter
% write a kernel and use matlab's built in convolution function
thresh2 = 25;
thresh3 = 25;
box_filt_kernel =  [1/9,1/9,1/9;
                               1/9,1/9,1/9;
                                1/9,1/9,1/9];
gauss_kernel = [1,4,7,4,1;
    4,16,26,16,4;
    7,26,41,26,7;
    4,16,26,16,4;
    1,4,7,4,1;];
gauss_kernel = gauss_kernel/273;
% ImPrev = conv2(ImPrev,box_filt_kernel);
% ImCurr = conv2(ImCurr,box_filt_kernel) ;
%ImPrev = medfilt2(ImPrev,[5 20]);
%ImCurr = medfilt2(ImCurr,[5 20]);
ImPrev = double(imgaussfilt(ImPrev));
ImCurr = double(imgaussfilt(ImCurr));
%ImPrev = medfilt2(ImPrev);
%ImCurr = medfilt2(ImCurr);
% Calculate spatial gradients (Ix, Iy) using Prewitt filter
% write prewitt kernel and use built-in convolution function

prewitt_x_kernel = [1,0,-1;
                    1,0,-1;
                    1,0,-1];
prewitt_y_kernel = [1,1,1;
                     0,0,0;
                    -1,-1,-1];


Gx= conv2(ImCurr,prewitt_x_kernel);
Gy = conv2(ImCurr,prewitt_y_kernel);

% Calculate temporal (It) gradient
ImTemporal = double(ImCurr - ImPrev);
%ImTemporal= wiener2(ImTemporal,[5 20]);
%ImTemporal = imgaussfilt(ImTemporal);
[ydim,xdim] = size(ImCurr);
Vx = zeros(ydim,xdim);
Vy = zeros(ydim,xdim);
Vxg = zeros(ydim,xdim);
Vyg = zeros(ydim,xdim);
G = zeros(2,2);
b = zeros(2,1);
cx=k+1;
%disp(max(ImTemporal,[],'all'));
if max(ImTemporal,[],'all') < thresh2
    %disp("false");
else
for x=k+1:k:xdim-k-1
    cy=k+1;
        for y=k+1:k:ydim-k-1
            %sub_array = ImCurr(i:i+2*k,j:j+2*k);
            sum_x_squared = sum(Gx(y-k : y+k , x-k:x+k).*Gx(y-k : y+k , x-k:x+k),'all');
            sum_x_y = sum( Gx( y-k : y+k , x-k:x+k ).* Gy(y-k : y+k , x-k:x+k),'all' );
            sum_y_squared = sum( Gy(y-k : y+k , x-k:x+k).*Gy(y-k : y+k , x-k:x+k),'all' );
            G = [sum_x_squared,sum_x_y;
                    sum_x_y,sum_y_squared];
        % Calculate the elements of G and b
             eigen = eig(G);

            if (min(eigen) < Threshold) 
                Vx(cy,cx)=0;
                 Vy(cy,cx)=0;
            else
             % Calculate u
             curr_temp_window = ImTemporal(y-k : y+k , x-k:x+k);
             if max(curr_temp_window,[],'all') > thresh3
                 b11 = sum(    Gx(y-k : y+k , x-k:x+k) .* ImTemporal(y-k : y+k , x-k:x+k),'all' );
                 b12 = sum(    Gy( y-k : y+k , x-k:x+k ) .* ImTemporal(  y-k : y+k , x-k:x+k) ,  'all'  );
                 b = [b11;
                         b12];
                 u = (-inv(G)*b);
                 Vx(cy,cx)=u(1); 
                 Vy(cy,cx)=u(2);
             else
                 Vx(cy,cx)=0; 
                 Vy(cy,cx)=0;
             end
             end
        cy=cy+k;
      end
     cx=cx+k;
end
end

%divider = line([256,256],[0,512],'Color','r','LineWidth',2);%line([x1,x2],[y1,y2],'Color','r','LineWidth',2)
%x = 256, y = 0 to 512 % vertical line
right_of_counter = 0;
line_x = 200;
%disp(size(Vy))
%disp(size(Vyg))
%disp("q");

for i = line_x - 10:1:line_x + 10
    for j = 1:1:360
        if Vy(i,j) > 0
              right_of_counter = right_of_counter + 1;
              Vxg(i,j) = Vx(i,j);
              Vyg(i,j) = Vy(i,j);
              %Vx(j,i) = 1;
              %Vy(j,i) = 1;
              ImPrev(i,j) = 255;
        elseif Vy(i,j) < 0
              right_of_counter = right_of_counter -1;
              Vxg(i,j) = Vx(i,j);
              Vyg(i,j) = Vy(i,j);
              %Vx(j,i) = 1;
              %Vy(j,i) = 1;
              ImPrev(i,j) = 255;

        else
            a = 2; % dummy line
        end
    end
end


% for i = line_x :-1:line_x + 100
%     disp("a");
%     for j=1:1:400
%         
%         if (abs(Vy(i,j)) > 0) %% a small value; and if it is smaller than 
%             disp(j);
            % a specific negative value, then it is an outgoing arrow;
%               right_of_counter = right_of_counter + 1;
%               Vxg(i,j) = Vx(i,j);
%               Vyg(i,j) = Vy(i,j);
%               %Vx(j,i) = 1;
%               %Vy(j,i) = 1;
%               ImPrev(i,j) = 255;
%         else
%             a = 2;
%         end
%       
%     end
% end
%disp(right_of_counter);
% right_of_counter = optical flow arrows going to right
person_count = count_ins2(arrow_per_frame,step);
ImPrev = uint8(ImPrev);
ImPrev = insertText(ImPrev,[0 0],sprintf('people count = %d',person_count));
ImPrev = insertText(ImPrev,[0 30],sprintf('OF_arrows = %d',right_of_counter));
ImPrev =  insertText(ImPrev,[0 60],sprintf('frame %d', frame_index));
ImPrev = rgb2gray(ImPrev);
arrow_per_frame_out = arrow_per_frame;
arrow_per_frame_out(1,frame_index) = right_of_counter;
%disp(size(ImPrev));
cla reset;
%imagesc(uint8(ImTemporal));
imagesc(ImPrev); hold on;
line([0,360],[200,200],'Color','b','LineWidth',4);%line([x1,x2],[y1,y2],'Color','r','LineWidth',2)
line([0,360],[190,190],'Color','b','LineWidth',1);%line([x1,x2],[y1,y2],'Color','r','LineWidth',2)
line([0,360],[210,210],'Color','b','LineWidth',1);%line([x1,x2],[y1,y2],'Color','r','LineWidth',2)
%[xramp,yramp] = meshgrid(1:1:xdim,1:1:ydim); quiver(xramp,yramp,Vx,Vy,10,"r");
if max(Vxg,[],'all') > 0
   [xramp,yramp] = meshgrid(1:1:xdim,1:1:ydim); quiver(xramp,yramp,Vxg,Vyg,10,"g");
end

colormap gray;
end