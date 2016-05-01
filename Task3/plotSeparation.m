function plotSeparation(b, mu, Sigma, priors, assignments, varargin)
% Plot cluster separation by projecting on LDA axes
%   plotSeparation(b, mu, Sigma, priors, assignment) visualizes the cluster
%   separation by projecting the data on the LDA axis for each pair of
%   clusters. Each column is normalized such that the left (i.e. first)
%   cluster has zero mean and unit variances. The LDA axis is estimated
%   from the model.
nClust = max(assignments);
pairs = combvec(1:nClust,1:nClust)';
figure;
a = colormap(lines);
clrMap = a(1:7,:);
clrMap(8,:) = [0 0 0];
clrMap(9,:) = [1 0 0];
for i =1:length(pairs)
       m1 = mu(pairs(i,1),:);
       m2 = mu(pairs(i,2),:);
       S1 = Sigma(:,:,pairs(i,1));
       S2= Sigma(:,:,pairs(i,2));
       S = S1+S2;
       W=pinv(S)*(m2-m1)';
      
        if pairs(i,1)== pairs(i,2)
            continue
        end
         subplot(9,9,i)
        h1= b(assignments==pairs(i,1),:)*W;
        histogram(h1, 'EdgeColor',clrMap(pairs(i,1),:),...
            'FaceColor',clrMap(pairs(i,1),:)); hold on;
        set(gca,'XTick',[],'YTick',[]);
        h2= b(assignments==pairs(i,2),:)*W; 
        histogram(h2,'EdgeColor',clrMap(pairs(i,2),:),...
            'FaceColor',clrMap(pairs(i,2),:)); 
        set(gca,'XTick',[],'YTick',[]);

end