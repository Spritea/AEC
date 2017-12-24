# AEC
This code implents Acoustic Echo Cancellation with LMS/RLS in MATLAB.  
I make a GUI program based on MATLAB GUI.I tried the new App designer framework of MATLAB R2017b. Sadly, there isn't an 
alternative function of `spectrogram()` ,so I use the old GUI framework back.
## Contents
* `AEC_V2.5` includes the GUI program which consists of `Echo_cancel.fig` and `Echo_cancel.m`. For quick test, 
you can just use the folder to see the result.
* `Filter_param` is used to find the best params for different types of filters. If you want to learn more about the detail, 
you can dig up.
* If you know Chinese, just see `MATLAB代码说明.pdf`. :)  

**Version: Matlab R2017b. This should work on Matlab R2016b and above.  
Since filter function has changed after R2016b, you need to change a bit of the usage of filter functions, say use `step()` function 
if your Matlab is not so new.**
