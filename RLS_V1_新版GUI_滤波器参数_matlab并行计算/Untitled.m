clear all; 
[x,Fs] = audioread('handel.wav'); 
[s,f,t]=spectrogram(x,Fs);
figure;
plot(f,s);