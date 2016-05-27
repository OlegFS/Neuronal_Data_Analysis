
% Run to finish the stuff
load('NDA_Data_2p_only.mat')
load SVM_Ca

<<<<<<< HEAD
for i =1:55
=======
for i =1:55;
>>>>>>> origin/master
    inferredRate = estimateRateFromCa(NDA_Data(i).GalvoTraces(:),...
        NDA_Data(i).fps,SVM);
NDA_Data(i).predictedRate(:) =inferredRate;
end