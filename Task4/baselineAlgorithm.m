% 1- Filter 
xF = filterTraces(x, fs);
% 2- Kernel estimation
% 3- Deconvolution
kern = exppdf(1:100,10);
result = deconvTraces(xF,y,kern);
% 4- Inward rectification - Now inside 
        % ROC curve OR percentage of false positive
% 5- Spike Extraction
% 6 - Normalization
% 7 - Classification