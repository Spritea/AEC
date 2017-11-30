function varargout = Echo_cancel(varargin)
% ECHO_CANCEL MATLAB code for Echo_cancel.fig
%      ECHO_CANCEL, by itself, creates a new ECHO_CANCEL or raises the existing
%      singleton*.
%
%      H = ECHO_CANCEL returns the handle to a new ECHO_CANCEL or the handle to
%      the existing singleton*.
%
%      ECHO_CANCEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECHO_CANCEL.M with the given input arguments.
%
%      ECHO_CANCEL('Property','Value',...) creates a new ECHO_CANCEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Echo_cancel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Echo_cancel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Echo_cancel

% Last Modified by GUIDE v2.5 30-Nov-2017 13:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Echo_cancel_OpeningFcn, ...
                   'gui_OutputFcn',  @Echo_cancel_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Echo_cancel is made visible.
function Echo_cancel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Echo_cancel (see VARARGIN)

% Choose default command line output for Echo_cancel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global FilterType;
FilterType=0;
global std_rls;
global std_lms;
global std_fxlms;
global std_nlms;
global std_ap;
std_rls=0;
std_lms=0;
std_fxlms=0;
std_nlms=0;
std_ap=0;
global corr_rls;
global corr_lms;
global corr_fxlms;
global corr_nlms;
global corr_ap;
corr_rls=0;
corr_lms=0;
corr_fxlms=0;
corr_nlms=0;
corr_ap=0;

% UIWAIT makes Echo_cancel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Echo_cancel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global res;
global Fs;
global std_rls;
global std_lms;
global std_fxlms;
global std_nlms;
global std_ap;
global corr_rls;
global corr_lms;
global corr_fxlms;
global corr_nlms;
global corr_ap;
[x,Fs] = audioread('handel.wav');
[y,Fs]=audioread('handel_echo.wav');
length=get(handles.edit1,'String');
length=str2num(length);
ff=get(handles.edit2,'String');
ff=str2double(ff);
mu=get(handles.edit3,'String');
mu=str2double(mu);
global FilterType;
switch FilterType
    case 0
        ha=dsp.RLSFilter('Length',length,'ForgettingFactor',ff);
        [res,e] = ha(x,y);
        std_rls=std(e,1);
        corr_rls=corr(x,res);
    case 1
        ha=dsp.LMSFilter('Length',length,'StepSize',mu);
        [res,e] = ha(x,y);
        std_lms=std(e,1);
        corr_lms=corr(x,res);
    case 2
        ha=dsp.FilteredXLMSFilter('Length',length,'StepSize',mu);
        [res,e] = ha(x,y);
        std_fxlms=std(e,1);
        corr_fxlms=corr(x,res);
    case 3
        ha=dsp.LMSFilter('Length',length,'Method','Normalized LMS','StepSize',mu);
        [res,e] = ha(x,y);
        std_nlms=std(e,1);
        corr_nlms=corr(x,res);
    case 4
        ha=dsp.AffineProjectionFilter('Length',length,'StepSize',mu);
        [res,e] = ha(x,y);
        std_ap=std(e,1);
        corr_ap=corr(x,res);
end
audiowrite('handle Regenerated.wav',res,Fs);
set(handles.pushbutton4,'Enable','on');
set(handles.radiobutton1,'Enable','on');
set(handles.radiobutton1,'Value',0);
%axes(handles.axes1);
%spectrogram(x);
plot(handles.axes1,x);
title(handles.axes1,'Original Signal');
xlabel(handles.axes1,'Time Index'); ylabel(handles.axes1,'Signal Value');
plot(handles.axes2,y);
title(handles.axes2,'Echoed Signal');
xlabel(handles.axes2,'Time Index'); ylabel(handles.axes2,'Signal Value');
plot(handles.axes3,res);
title(handles.axes3,'Regenerated Signal');
xlabel(handles.axes3,'Time Index'); ylabel(handles.axes3,'Signal Value');
std_all=[std_rls,std_lms,std_nlms,std_fxlms,std_ap];
corr_all=[corr_rls,corr_lms,corr_nlms,corr_fxlms,corr_ap];
%bar(handles.axes4,mse_all);
bar(handles.axes4,std_all,0.4);
gap1=get(handles.axes4,'YTick');
ylength1=get(handles.axes4,'YLim');
ylim(handles.axes4,[0 ylength1(1,2)*1.1]);
if std_rls>0
    text(handles.axes4,1-0.3,std_rls+gap1(1,2)*0.3,'RLS');
end
if std_lms>0
    text(handles.axes4,2-0.3,std_lms+gap1(1,2)*0.3,'LMS');
end
if std_fxlms>0
    text(handles.axes4,4-0.3,std_fxlms+gap1(1,2)*0.3,'FX');
end
if std_nlms>0
    text(handles.axes4,3-0.4,std_nlms+gap1(1,2)*0.3,'NLMS');
end
if std_ap>0
    text(handles.axes4,5-0.3,std_ap+gap1(1,2)*0.3,'Affine');
end
title(handles.axes4,{'Standard deviation';'the smaller the better'});
xlabel(handles.axes4,'Filter type'); ylabel(handles.axes4,'Value');

bar(handles.axes5,corr_all,0.4);
gap2=get(handles.axes5,'YTick');
ylength2=get(handles.axes5,'YLim');
ylim(handles.axes5,[0 ylength2(1,2)*1.1]);
if corr_rls>0
    text(handles.axes5,1-0.3,corr_rls+gap2(1,2)*0.3,'RLS');
end
if corr_lms>0
    text(handles.axes5,2-0.3,corr_lms+gap2(1,2)*0.3,'LMS');
end
if corr_fxlms>0
    text(handles.axes5,4-0.3,corr_fxlms+gap2(1,2)*0.3,'FX');
end
if corr_nlms>0
    text(handles.axes5,3-0.5,corr_nlms+gap2(1,2)*0.3,'NLMS');
end
if corr_ap>0
    text(handles.axes5,5-0.3,corr_ap+gap2(1,2)*0.3,'Affine');
end
title(handles.axes5,{'Correlation coefficient';'the bigger the better'});
xlabel(handles.axes5,'Filter type'); ylabel(handles.axes5,'Value');




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global Fs;
sound(x,Fs);
pause(10);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y;
global Fs;
sound(y,Fs);
pause(10);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global res;
global Fs;
sound(res,Fs);
pause(10);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
global x;
global y;
global res;
if get(handles.radiobutton1,'Value')
    axes(handles.axes1);
    spectrogram(x);
    title('Original Signal');
    axes(handles.axes2);
    spectrogram(y);
    title('Echoed Signal');
    axes(handles.axes3);
    spectrogram(res);
    title('Regenerated Signal');
else
    plot(handles.axes1,x);
    title(handles.axes1,'Original Signal');
    xlabel(handles.axes1,'Time Index'); ylabel(handles.axes1,'Signal Value');
    plot(handles.axes2,y);
    title(handles.axes2,'Echoed Signal');
    xlabel(handles.axes2,'Time Index'); ylabel(handles.axes2,'Signal Value');
    plot(handles.axes3,res);
    title(handles.axes3,'Regenerated Signal');
    xlabel(handles.axes3,'Time Index'); ylabel(handles.axes3,'Signal Value');
end
guidata(hObject,handles)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
global FilterType;
set(handles.pushbutton4,'Enable','off');
set(handles.radiobutton1,'Enable','off');
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val}
    case 'RLS' % User selects peaks.
        FilterType=0;
        set(handles.edit1,'String','4');
        set(handles.edit2,'String','1');
        set(handles.edit2,'Enable','on');
        set(handles.edit3,'Enable','off');
    case 'LMS' % User selects membrane.
        FilterType=1;
        set(handles.edit1,'String','2');
        set(handles.edit3,'String','0.022');
        set(handles.edit2,'Enable','off');
        set(handles.edit3,'Enable','on');
    case 'FilteredXLMS' % User selects sinc.
        FilterType=2;
        set(handles.edit1,'String','2');
        set(handles.edit3,'String','0.002');
        set(handles.edit2,'Enable','off');
        set(handles.edit3,'Enable','on');
    case 'NLMS' % User selects membrane.
        FilterType=3;
        set(handles.edit1,'String','4');
        set(handles.edit3,'String','0.022');
        set(handles.edit2,'Enable','off');
        set(handles.edit3,'Enable','on');
    case 'AffineProjectionFilter' % User selects membrane.
        FilterType=4;
        set(handles.edit1,'String','2');
        set(handles.edit3,'String','0.022');
        set(handles.edit2,'Enable','off');
        set(handles.edit3,'Enable','on');
end
% Save the handles structure.
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
value = str2double(get(handles.edit1,'String'));
flag = value > 0 
if ~flag
   set(handles.edit1,'String','');
   warndlg('Value should be positive !! Please Enter Again');
% else
%    msgbox('Got the value, On it!');
end
set(handles.pushbutton4,'Enable','off');
set(handles.radiobutton1,'Enable','off');


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
value = str2double(get(handles.edit2,'String'));
flag = value >= 0 && value <= 1
if ~flag
   set(handles.edit2,'String','');
   warndlg('Value should be between 0 and 1 !! Please Enter Again');
% else
%    msgbox('Got the value, On it!');
end
set(handles.pushbutton4,'Enable','off');
set(handles.radiobutton1,'Enable','off');


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
value = str2double(get(handles.edit3,'String'));
flag = value > 0 
if ~flag
   set(handles.edit3,'String','');
   warndlg('Value should be positive !! Please Enter Again');
% else
%    msgbox('Got the value, On it!');
end
set(handles.pushbutton4,'Enable','off');
set(handles.radiobutton1,'Enable','off');


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot(handles.axes1,5);% To override colorbar of spectrogram
cla(handles.axes1);
reset(handles.axes1);
plot(handles.axes2,5);
cla(handles.axes2);
reset(handles.axes2);
plot(handles.axes3,5);
cla(handles.axes3);
reset(handles.axes3);
cla(handles.axes4);
reset(handles.axes4);
cla(handles.axes5);
reset(handles.axes5);
set(handles.popupmenu1,'Value',1);
set(handles.edit2,'Enable','on');
set(handles.edit3,'Enable','off');
set(handles.pushbutton4,'Enable','off');
set(handles.radiobutton1,'Enable','off');
global FilterType;
FilterType=0;
global std_rls;
global std_lms;
global std_fxlms;
global std_nlms;
global std_ap;
std_rls=0;
std_lms=0;
std_fxlms=0;
std_nlms=0;
std_ap=0;
global corr_rls;
global corr_lms;
global corr_fxlms;
global corr_nlms;
global corr_ap;
corr_rls=0;
corr_lms=0;
corr_fxlms=0;
corr_nlms=0;
corr_ap=0;
set(handles.edit1,'String','4');
set(handles.edit2,'String','1');
set(handles.edit3,'String','0.022');


% --- Executes during object deletion, before destroying properties.
function axes3_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
