function corr = corrResp(h,y);

maxWindow = 10;
[~,hLocks] = findpeaks(h);

y(y>0)=1;
h(h>0)=1;
y = double(y);
h = double(h);
h(find(h==0))=NaN;
y(find(y==0))=NaN;
resp = y - h;
resp = resp ==0;

ind = find(resp ==1);
corr = ismember(hLocks,ind);


    
    

