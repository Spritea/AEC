clear all;  
% Audio Input  
[x,Fs] = audioread('handel.wav');  
%sound(x,Fs)
%pause(10);  

% echoed audio signal
[y,Fs1]=audioread('handel_echo.wav');
%sound(y,Fs1); 
%pause(10);

long=[2 4 8 16 32 64 128];
mu=(0.002:0.02:0.8);
ff=(0.9:0.002:1);
co_lms=zeros(length(long),length(mu));
co_rls=zeros(length(long),length(ff));
StartMatlabPool_fun(4);
for i=1:length(long)
    %for j=1:length(mu)
    for j=1:length(ff)
       %ha = dsp.LMSFilter('Length',long(i),'StepSize',mu(j));
       %ha = dsp.LMSFilter('Length',long(i),'Method','Normalized LMS','StepSize',mu(j));
        ha =dsp.RLSFilter('Length',long(i),'ForgettingFactor',ff(j));
       %ha=dsp.FilteredXLMSFilter('Length',long(i),'StepSize',mu(j));
      % ha=dsp.AffineProjectionFilter('Length',long(i),'StepSize',mu(j));
        [res,e] = ha(x,y);
        %co_lms(i,j)=corr(x,res);
        co_rls(i,j)=corr(x,res);
    end
end
CloseMatlabPool_fun;
%哈哈
% value=max(max(co_lms));
% [row, col]=find(value==co_lms);
% [L,M]=meshgrid(long,mu);
value=max(max(co_rls));
[row, col]=find(value==co_rls);
[L,F]=meshgrid(long,ff);
figure;
% surf(L,M,co_lms');
surf(L,F,co_rls');

%Original Signal

title('Correlation Function of Filter Order and Stepsize');
xlabel('Filter Order'); ylabel('Stepsize'); zlabel('Correlation');