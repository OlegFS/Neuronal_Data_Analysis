%% 

%y = [Y{1}; Y{2}; Y{3}; Y{4}; Y{5}; Y{6} ;Y{7}];
%h = [H{1}; H{2}; H{3}; H{4}; H{5}; H{6} ;H{7}];




clear X
peaks = find(y>0);
n = zeros(length(y),1);
n(peaks) = 1;
Neighbours=0;
for i=1:length(peaks)
Neighbours(i) = sum(n(peaks(i)-2:peaks(i)+2)); % try 6
end

X(:,1) = xF(peaks);
%X = zscore(X);
X = [ones(length(X),1) X Neighbours'];

training = y(peaks)

Beta = X\training;

prediction = X*Beta; 

residuals = training- prediction;
n = zeros(length(y),1);
n(peaks)= prediction;
 n(peaks)= prediction;
corr(n,y)
plot(residuals,prediction,'.')

