
% Run to finish the stuff

for i =1:55; inferredRate = estimateRateFromCa(NDA_Data(i).GalvoTraces(:),...
        NDA_Data(i).fps,SVM);
NDA_Data(i).predictedRate(:) =inferredRate;
end