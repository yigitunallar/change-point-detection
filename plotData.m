data = load("well_log_data.txt");
y = data(:,1);
m = length(y);
mean = zeros(m);
change_point_detected = zeros(m);
counter=0;
for iter = 1:m
   if(iter == 1)
     mean(iter) = y(iter);
     counter++;
   else
     if( or(y(iter) > 1.09 * mean(iter-1), y(iter) * 1.1 <  mean(iter-1)))
        change_point_detected(iter) = iter;
        mean(iter) = y(iter);
        counter = 1;
     else
        counter++;
        mean(iter) = (mean(iter-1)*(counter-1)+ y(iter))/counter;
     endif
   endif
endfor

plot(y);
hold on;
for iter = 1:m
  if(change_point_detected(iter) != 0)
     x = change_point_detected(iter);
     plot([x;x],[0;160000],"r");
  endif
endfor
hold off;
