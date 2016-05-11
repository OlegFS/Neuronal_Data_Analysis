function Fe = extractWFeatures(f); 
% Extracts features for the SVM classification

f = f(1:16,:);
Fe = zeros(84,length(f));
% Statistical moments
Fe(1,:)= moment(f,1);
Fe(2,:)=moment(f,2);
Fe(3,:)=moment(f,3);
Fe(4,:)=moment(f,4);
% Stationaty wavelet transform coefficients
for i=1:length(f)
SW(i,:)= reshape(swt(f(:,i),4,'haar'),1,5*16);
end
Fe(6:85,:) = SW';