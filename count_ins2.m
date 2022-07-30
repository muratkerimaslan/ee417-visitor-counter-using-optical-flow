function Iout = count_ins2(arrow_per_frame_array,step)
[row,col] = size(arrow_per_frame_array);
frame_count = col;
%disp(row);
%disp(col);
Iout = 0;
k = 1;
while (k < frame_count)
    flag = 0;
    if( (arrow_per_frame_array(1,k)  >  0)  & (k < frame_count)   )
        total = 0;
        for i=k:step:k+20
            total = total + arrow_per_frame_array(1,i);
        end
        if total > 40
            flag = 1;
            k = k+20;
        end
    
    elseif( (arrow_per_frame_array(1,k)  <  0)  & (k < frame_count)   )
       total = 0;;
       for i=k:step:k+20
            
            total = total + arrow_per_frame_array(1,i);
        end
        if total < -40
            flag = -1;
            k = k+20;
        end
    end
    Iout = Iout + flag;
    k = k + step;
end
   
end