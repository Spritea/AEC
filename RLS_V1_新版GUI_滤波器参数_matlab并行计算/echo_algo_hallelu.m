clear all;  
% Audio Input  
 [x,Fs] = audioread('handel.wav');  
 %sound(x,Fs)
 
%pause(10);  

% echoed audio signal
[y,Fs1]=audioread('handel_echo.wav');
 %sound(y,Fs1); 
 %pause(10);

%Echo cancellation by Adaptive Filter
%b = fir1(31,0.5);     % FIR system to be identified
mu= 0.008;            % LMS step size.
ha = dsp.LMSFilter('Length',32,'StepSize',mu);
%ha =dsp.RLSFilter(64, 'ForgettingFactor', 0.997);
%ha =dsp.BlockLMSFilter('Length',32, 'StepSize', mu,'BlockSize',5);
%ha= adaptfilt.lms(32,mu);
%[res,e] = filter(ha,p,z);
[res,e,w] = ha(x,y);

%Regenerated Sound from Echoed Sound
sound(res,Fs);
audiowrite('handle Regenerated.wav',res,Fs)

%Plots
%Original Signal
subplot(4,1,1); plot(x);
title('Original Signal');
xlabel('Time Index'); ylabel('Signal Value');

%Echoed Signal
subplot(4,1,2); plot(y);
title('Echoed Signal');
xlabel('Time Index'); ylabel('Signal Value');

%Regenerated Signal
subplot(4,1,3); plot(e);
title('Regenerated Signal');
xlabel('Time Index'); ylabel('Signal Value');
%[xx,Fs] = audioread('2.wav');  
co=corr(x,res);
subplot(4,1,4); bar(co);

%Original Signal

%title('Original Signal');
%xlabel('Time Index'); ylabel('Signal Value');