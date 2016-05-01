%% 
load('/Users/olegvinogradov/Documents/MATLAB/Neuronal_Data_Analysis/Task2/NDA_task1_results.mat')
cd Neuronal_Data_Analysis/Task3
% t - in ms
%% Clustering
tic;[mu, Sigma, priors, df, assignments] = sortSpikes(b);toc;

%% 
plotWaveforms(w, assignments) 

%% 
i =1;
dat1 = t(assignments==i);
dat2 = t(assignments==9);
h = zeros(1,39);

range = [-20:20];
range = [range(1:20) range(22:41)];
for i =1:length(dat1)
ex = dat1(i)-dat2;
h = h+ histcounts(flip(ex),range);
h(20)= NaN;
end
bar([-19:19],h)



%%
nClust = max(assignments);
pairs = combvec(1:nClust,1:nClust)';
figure;
for i =1:length(pairs)
m1 = mu(pairs(i,1),:);
m2 = mu(pairs(i,2),:);
S1 = Sigma(:,:,pairs(i,1));
S2= Sigma(:,:,pairs(i,2));
S = S1+S2;
W=pinv(S)*(m2-m1)';
subplot(9,9,i)
h1= b(assignments==pairs(i,1),:)*W; histogram(h1); hold on;
h2= b(assignments==pairs(i,2),:)*W;histogram(h2); 

end