function xF = filterTraces(x,fs)


fcutlow  = 0.0400;%;
fcuthigh = 3; %;3

d = designfilt('bandpassfir','FilterOrder',20, ...
'CutoffFrequency1',fcutlow,'CutoffFrequency2',fcuthigh, ...
'SampleRate',fs);

xF = filtfilt(d,double(x));