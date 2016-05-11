%% 

%y = [Y{1}; Y{2}; Y{3}; Y{4}; Y{5}; Y{6} ;Y{7}];
%h = [H{1}; H{2}; H{3}; H{4}; H{5}; H{6} ;H{7}];




clear X
peaks = find(y>0);
n = zeros(length(y),1);
n(peaks) = 1;
Neighbours = zeros(length(peaks),1)';
for i=1:length(peaks)
Neighbours(i) = sum(n(peaks(i)-2:peaks(i)+2)); % try 6
end

peaks = find(y>0);
distNeighbours = zeros(length(peaks),1)';

for i=19:length(peaks)
distNeighbours(i) = sum(n(peaks(i)-250:peaks(i))); % try 6
end

%X(:,1) = xF(peaks);
X(:,1) = diff([ 0 ;xF(peaks)]);
X(:,1) = X(:,1).^2;
%X = zscore(X);Neighbours'
X = [ones(length(X),1) X Neighbours' distNeighbours'];
training = y(peaks);

Beta = X\training;

prediction = X*Beta; 

residuals = training- prediction;
n = zeros(length(y),1);
n(peaks)= prediction;
 n(peaks)= prediction;
corr(n,y)
plot(residuals,prediction,'.')

%%

 mdl = fitrsvm(X,training,'Standardize',true,'KernelScale','auto','Standardize',true,'KernelFunction','rbf')
 
peaks = find(spikeFlag>0);
h = xF(xLocks(logical(ClassSpikes)));
% Estimate the neighbours of each waveform as a regressor
for i=1:length(peaks)
Neighbours(i) = sum(spikeFlag(peaks(i)-4:peaks(i)+4)); % try 6
end
FF = [ones(length(h),1) h Neighbours'];
 yfit = predict(mdl,FF);
 
 
 
 