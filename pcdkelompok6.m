function varargout = pcdkelompok6(varargin)
% PCDKELOMPOK6 MATLAB code for pcdkelompok6.fig
%      PCDKELOMPOK6, by itself, creates a new PCDKELOMPOK6 or raises the existing
%      singleton*.
%
%      H = PCDKELOMPOK6 returns the handle to a new PCDKELOMPOK6 or the handle to
%      the existing singleton*.
%
%      PCDKELOMPOK6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PCDKELOMPOK6.M with the given input arguments.
%
%      PCDKELOMPOK6('Property','Value',...) creates a new PCDKELOMPOK6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pcdkelompok6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pcdkelompok6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pcdkelompok6

% Last Modified by GUIDE v2.5 23-Mar-2018 16:10:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcdkelompok6_OpeningFcn, ...
                   'gui_OutputFcn',  @pcdkelompok6_OutputFcn, ...
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

% --- Executes just before pcdkelompok6 is made visible.
function pcdkelompok6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pcdkelompok6 (see VARARGIN)

% Choose default command line output for pcdkelompok6
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pcdkelompok6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pcdkelompok6_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Open_btn.
function Open_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Open_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    [filename, pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
    handles.gambar = imread(strcat(pathname, filename));    
    axes(handles.axesori);
    imshow(handles.gambar);
    setappdata(handles.Open_btn,'gambarsaved',handles.gambar);
    
    %set(handles.edit1,'string',filename);
    %set(handles.edit2,'string',image);
    % save the updated handles object
  
    guidata(hObject, handles);

    
% --- Executes on button press in Grey_btn.
function Grey_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Grey_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    gambarcpy = getappdata(handles.Open_btn,'gambarsaved');
    %newGambarcpy = imread(gambarcpy);
    handles.toGrey = rgb2gray(gambarcpy);
    setappdata(handles.Grey_btn,'gambarGreyScale',handles.toGrey);
    axes(handles.axescpy);
    imshow(handles.toGrey);


% --- Executes on button press in biner_btn.
function biner_btn_Callback(hObject, eventdata, handles)
% hObject    handle to biner_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newgambar = getappdata(handles.Grey_btn,'gambarGreyScale');
toBiner = im2bw(newgambar,0.5);
axes(handles.axesprocess);
imshow(toBiner);


% --- Executes on button press in Exit_btn.
function Exit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in AddNoise_btn.
function AddNoise_btn_Callback(hObject, eventdata, handles)
% hObject    handle to AddNoise_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GreyImage = getappdata(handles.Grey_btn,'gambarGreyScale');
addFilter = imnoise(GreyImage,'salt & pepper');
setappdata(handles.AddNoise_btn,'NoiseImage',addFilter);
axes(handles.axesprocess);
imshow(addFilter);


% --- Executes when selected object is changed in Filter_btn.
function Filter_btn_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Filter_btn 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global kernel
    switch get(get(handles.Filter_btn,'SelectedObject'),'Tag')
        case 'Lpf_btn', 
            NoiseImage = getappdata(handles.AddNoise_btn, 'NoiseImage')
            mask = (1./(kernel*kernel))*ones(kernel)
            Filtered = imfilter(NoiseImage, mask)
            %%filter = fspecial('gaussian',[kernel kernel],1);
            %%Filtered = imfilter(NoiseImage, filter, 'same');
            axes(handles.axesprocess);
            imshow(Filtered);;
        case 'Hpf_btn',
            GreyImage = getappdata(handles.Grey_btn,'gambarGreyScale');
            %NoiseImage = getappdata(handles.AddNoise_btn, 'NoiseImage')
            %mask = fspecial('log' ,[kernel kernel],0.5);
            %Filtered = imfilter(NoiseImage, mask)
            %axes(handles.axesprocess);
            %imshow(Filtered);;
            if kernel == 3
                k = -1*ones(kernel)
                k(2,2) = 8
                filter = imfilter(GreyImage,k)
                axes(handles.axesprocess)
                imshow(filter)
            elseif kernel == 5
                k = -1*ones(kernel)
                k(3,3) = 24
                filter = imfilter(GreyImage,k)
                axes(handles.axesprocess)
                imshow(filter)
            elseif kernel == 7
                k = -1*ones(kernel)
                k(4,4) = 48
                filter = imfilter(GreyImage,k)
                axes(handles.axesprocess)
                imshow(filter)
            elseif kernel == 9
                k = -1*ones(kernel)
                k(5,5) = 80
                filter = imfilter(GreyImage,k)
                axes(handles.axesprocess)
                imshow(filter)
            end
        case 'Median_btn',
            GreyImage = getappdata(handles.Grey_btn,'gambarGreyScale');
            %NoiseImage = getappdata(handles.AddNoise_btn, 'NoiseImage');
            Filtered = medfilt2(GreyImage, [kernel kernel]);
            axes(handles.axesprocess);
            imshow(Filtered);;
    end


% --- Executes when selected object is changed in kernel_btn.
function kernel_btn_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in kernel_btn 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global kernel
    switch get(get(handles.kernel_btn,'SelectedObject'),'Tag')

        case 'Three_kernel', kernel = 3;
        case 'Five_kernel', kernel = 5;
        case 'Seven_kernel', kernel = 7;
        case 'Nine_kernel', kernel = 9; 

    end


function InputBrightness_Callback(hObject, eventdata, handles)
% hObject    handle to InputBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputBrightness as text
%        str2double(get(hObject,'String')) returns contents of InputBrightness as a double
global brightness
brightness = str2num(get(handles.InputBrightness,'String'))
%brightness = str2double(char(bright))

% --- Executes on button press in SetBrightness.
function SetBrightness_Callback(hObject, eventdata, handles)
% hObject    handle to SetBrightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global brightness
GreyImage = getappdata(handles.Grey_btn,'gambarGreyScale');
BrightImage = GreyImage+brightness
axes(handles.axesprocess);
imshow(BrightImage);
