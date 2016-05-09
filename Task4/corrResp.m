function [Locs,correct] = corrResp(h,y);

maxWindow = 10;
[~,hLocks] = findpeaks(h);
correct = zeros(length(hLocks),1);
ind = find(y >0);
Locs = {};
for i =1:length(hLocks)
    p=0;
    n =0;
        for c=1:maxWindow
             if h(hLocks(i)+p)>0
                p = p+1;
             else
                break
             end
        end
    
     for c=1:maxWindow
         if h(hLocks(i)-n)>0     
            n = n+1;
         else
             break
         end
     end
    Locs{i}= hLocks(i)-(n-1):hLocks(i)+(p-1);
    
    if sum(ismember(hLocks(i)-(n-1):hLocks(i)+(p-1),ind))>0;
        if i>1
            if   length(Locs{i}) == length(Locs{i-1}) & isequal(Locs{i},Locs{i-1});
                
                correct(i)=0;
            end
        end
        correct(i) = 1;      
    else 
        correct(i) = 0;
    end   
end
    

