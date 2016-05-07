 function falsePositives(h,y)
 
 [yPeaks,yLocks] = findpeaks(double(y));
 [hPeaks,hLocks] = findpeaks(h);
 
 True = zeros(length(h),1);
 True(yLocks)=1;
 
 Detected = zeros(length(h),1);
 Detected(hLocks)=1;
 [X,Y] = perfcurve(True,Detected,1)
 
 plot(X,Y); hold on
plot([0 1] ,[0 1],'-k')
 xlabel('False positive rate')
ylabel('True positive rate')
title('ROC')

 
 
 
 
 