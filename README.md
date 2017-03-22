# Change Point Detection
## Introduction
Change-point detection is the identification of abrupt changes in the sequential data. As a signal processing method, it has been applied to econometrics[1] and disease demographics[2]. Most papers on change-point detection focus on segmentation and techniques to generate samples from the posterior distribution over change-point locations. In this work, describing an efficient change-point model that is able to update itself at each iteration is targeted. Once a new change point has been detected, the algorithm is reinitialized per the new trend and keep running itself accordingly. As opposed to Bayesian approaches proposed[3,4], here we seek to implement the most simplistic approaches to detect the anomalies without deep diving statistical concepts. The rest of the article is organized as follows. Section 2 describes the idea behind the implemented algorithm, Section 3 presents an assessment of the test results and Section 4 provides discussion and conclusions.

## Mean Value Oriented Algorithm
So far, the proposed algorithms and approaches in the literature applied variety of statistical formulas to detect change- methods both online and offline. Here, it is assumed that, in any give data set, iterating through each data point, we can calculate the mean value for each data point concurrently and by comparing the preceding mean value to the current point, we can estimate if the trend surges or plummet. However, it is obvious that, we have to set some parameters to represent those abrupt changes so that the algorithm will be able to detect the anomalies. The algorithm devised to tackle with the change- point problem on a “well_log” dataset is shown below.
```
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
```
“Well_log” dataset is comprised of 4050 data points, and to iterate through each one, “for” loop has been implemented in the algorithm. Once the algorithm bumps into the very first data point, which is modeled with if(iter==1) statement in the algorithm, calculating the mean value is not reasonable, as there is only one data point present, thus mean value is simply set to the value of the first data point. Moving forward, next data point is fed to the algorithm, leading to calculate the corresponding mean value by simply summing the current and previous data points up and dividing the sum value by the number of data points fed to the algorithm so far. Next step to identify change- points accurately in the data set is comparison of both the current data point and the previous mean value. By doing so, we can have a better visibility on whether we are stepping out of the current trend or not. In order to simulate those abrupt changes, we have to set parameters manually as depicted in the algorithm. To model surge actions, we precisely selected “1.09” constant value to identify change-point and “1.1” parameter to symbolize sudden decreases as well. Once the algorithm detected any change-point, collecting previous data points’ values would be futile, hence the mean value has to be set to current data point value again. In order to achieve this, “counter” variable holds the number of data points to be taken into consideration throughout the runtime of the algorithm, and in case change-point detected, it is set to 1 to hold the number of new data points that belong to current trend going forward. When any change-point detected, the algorithm store this value in “change_point_detected” vector structure and plots those values on the dataset in the rest of the program which will be further discusses in the next section.

## Analysis and Test Results
### Well_log Dataset
<img width="500" alt="screen shot 2017-03-22 at 14 16 53" src="https://cloud.githubusercontent.com/assets/18366839/24195332/02e41820-0f02-11e7-96af-9612bf01ea1a.png">
### Well_log_no_outliers Dataset
<img width="500" alt="screen shot 2017-03-22 at 14 17 08" src="https://cloud.githubusercontent.com/assets/18366839/24195333/03c9440e-0f02-11e7-9597-5de11daaff94.png">

In order to fine tune the threshold parameters, the algorithm were run many times to obtain the best results. Following results point out that the algorithm were fed by both datasets and the values in the source code are the best results achieved so far and almost detected each change point that any human is able to recognize. As depicted above, approximately 60 change-points were detected by our algorithm. Best results were obtained by parameters values set to 1,09 and 1,1 respectively.
