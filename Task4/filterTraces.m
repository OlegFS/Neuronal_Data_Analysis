function xF = filterTraces(x,fs)

<<<<<<< Updated upstream
fcutlow  = 0.0400;%;
fcuthigh = 3; %;3
=======
fcutlow  = 0.0400
fcuthigh = 3
>>>>>>> Stashed changes
d = designfilt('bandpassfir','FilterOrder',20, ...
'CutoffFrequency1',fcutlow,'CutoffFrequency2',fcuthigh, ...
'SampleRate',fs);

xF = filtfilt(d,double(x));