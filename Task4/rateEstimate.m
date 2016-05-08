%% 

y = [Y{1}; Y{2}; Y{2}; Y{2}; Y{2}; Y{2} ;Y{2}];
h = [H{1}; H{2}; H{2}; H{2}; H{2}; H{2} ;H{2}];

clear X
peaks = find(y>0);
n = zeros(length(y),1);
n(peaks) = 1;

for i=1:length(peaks)
Neighbours(i) = sum(n(peaks(i)-1:peaks(i)+1));
end

X(:,1) = h(peaks);
X = zscore(X);
X = [ones(length(X),1) X  Neighbours'];


Beta = X\peaks;

prediction = X*Beta; 
n = zeros(length(y),1);
n(peaks)= prediction;
 n(peaks)= prediction;
corr(n,y)