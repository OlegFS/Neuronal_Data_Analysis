function b = extractFeatures(w)
% Extract features for spike sorting.
%   b = extractFeatures(w) extracts features for spike sorting from the
%   waveforms in w, which is a 3d array of size length(window) x #spikes x
%   #channels. The output b is a matrix of size #spikes x #features.
%
%   This implementation does PCA on the waveforms of each channel
%   separately and uses the first three principal components. Thus, we get
%   a total of 12 features.
nChannels = size(w,3)

%PCA
for i=1:nChannels
c(:,:,i) = pca(w(:,[~isnan(w(1,:,i))],i)');
end
% Take 1st 3 components into 
b(:,:) = reshape(c(:,1:3,:),60,12);

