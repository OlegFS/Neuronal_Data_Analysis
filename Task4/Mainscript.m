%% Ca traces competition
%load Data

load('/Users/olegvinogradov/Documents/MATLAB/Neuronal_Data_Analysis/Task4/TrainingData.mat');
cd Neuronal_Data_Analysis/Neuronal_Data_Analysis/Task4 
%% Visualization 
plot(data(1).GalvoTraces(1000:2000)*20); 
hold on; 
plot(data(1).SpikeTraces(1000:2000)+10)

%%
x = data(2).GalvoTraces(:);
y = data(2).SpikeTraces(:);
fs = data(2).fps;



%%  Fourier transfrom 
F =fft(x);
L = length(x);
P2 = abs(F/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(L/2))/L;

plot(f,P1);
xlabel('Hz');
ylabel('A');
%% Filtration
d = designfilt('highpassiir','FilterOrder',8, ...
         'PassbandFrequency',0.04,'PassbandRipple',0.01, ...
         'SampleRate',fs);
%fvtool(d)
xF    = filter(d,double(x));
%%
fcutlow  = 0.0400%;
fcuthigh = 3%;3
d = designfilt('bandpassfir','FilterOrder',20, ...
'CutoffFrequency1',fcutlow,'CutoffFrequency2',fcuthigh, ...
'SampleRate',fs);

xF    = filtfilt(d,double(x));
%% Filter plot
t1= 500;
t2 = 700%length(x)

plot(x(t1:t2));hold on; plot(xF(t1:t2)); 

plot(y(t1:t2)/50-0.1);
legend original filt spikes 
%% Deconvolution 

%pd = makedist('Poisson',1)
kern = exppdf(1:100,10);
%kern = w;
%kern = pdf(pd,[0:100]);
 
C = conv(kern,y);
disp('forward')
corr(C(1:length(xF)),xF)
result = deconv(xF,kern);
result = result.*(result>0); % b=a.*(a>0)
%[res rem] = deconv(xF,kern);
disp('Inverse')

%res = [abs(res) ;abs(rem(length(res):end-1))];

result2 = deconv(flip(xF),kern);
result2 = result2.*(result2>std);

RES = [result; result2(end-(length(xF)-length(result)-1):end)];
corr(y, RES)
plot(RES); hold on;
plot(y+4)

%% Deconv OLD
result1 = deconv([x; zeros(99,1),kern);
% Rectification
result1 = result1.*(result1>0); 
% Deconv fliped signal to get the whole data
result2 = deconv(flip(x),pinv(kern));
% Rectification
result2 = result2.*(result2>0);
result2 = flip(result2);
% Decontruct the data
result = [result1; result2(end-(length(x)-length(result1)-1):end)];




%% Extract features
X = zeros(20,sum(y>0));
ind = find(y>0);
for i =1:size(X,2)
X(:,i) = x(ind(i)-10:ind(i)+9);
end


%%

kern = exppdf(1:10,20)';
[J,P]=deconvblind(xF,kern);
result = J.*(J>0);
disp('Inverse')
corr(y(1:length(result)), result)

%%
estimated_nsr = 1 / var(xF(:))
wnr2 = deconvwnr(xF, kern', estimated_nsr);
result = wnr2.*(wnr2>0);
disp('Inverse')
corr(y(1:length(result)), result)



%% Weekend 

% Prepocessing 
xF = filterTraces(x, fs);


%%

h  = xF(1:100)'*beta;
beta = xF\y;







