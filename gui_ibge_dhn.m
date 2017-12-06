function varargout = gui_ibge_dhn(varargin)
% GUI_IBGE_DHN M-file for gui_ibge_dhn.fig
%      GUI_IBGE_DHN, by itself, creates a new GUI_IBGE_DHN or raises the existing
%      singleton*.
%
%      H = GUI_IBGE_DHN returns the handle to a new GUI_IBGE_DHN or the handle to
%      the existing singleton*.
%
%      GUI_IBGE_DHN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_IBGE_DHN.M with the given input arguments.
%
%      GUI_IBGE_DHN('Property','Value',...) creates a new GUI_IBGE_DHN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_ibge_dhn_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_ibge_dhn_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_ibge_dhn

% Last Modified by GUIDE v2.5 12-Jan-2016 14:41:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_ibge_dhn_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_ibge_dhn_OutputFcn, ...
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


% --- Executes just before gui_ibge_dhn is made visible.
function gui_ibge_dhn_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_ibge_dhn (see VARARGIN)

% Choose default command line output for gui_ibge_dhn
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_ibge_dhn wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_ibge_dhn_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in arq_inp.
function arq_inp_Callback(hObject, eventdata, handles)
% [handles.name,handles.path]=uigetfile('*.xyz','Arquivo de entrada')
% handles.arquivo=load ([handles.path handles.name]);
% guidata(hObject,handles)
[handles.name,handles.path]=uigetfile('*.xyz','Arquivo de entrada','MultiSelect','on')
numfiles = size(handles.name,2);
% if iscell(fileName)
%     nbfiles = length(fileName);
% elseif fileName != 0
%     nbfiles = 1;
% else
%     nbfiles = 0;
% end
for ii = 1:numfiles
    entirefile =fullfile(handles.path,handles.name{ii});
handles.arquivo{ii}=load ([handles.path handles.name{ii}]);
end  
guidata(hObject,handles)


% --- Executes on button press in ibge.
function ibge_Callback(hObject, eventdata, handles)
for ii = 1:size(handles.name,2)
dlmwrite(fullfile(handles.path,handles.name{ii}),handles.arquivo{ii},...
    'delimiter','\t','newline','pc','precision','%.3f')
end
% --- Executes on button press in dhn.
function dhn_Callback(hObject, eventdata, handles)
est=get(handles.painel_estacao,'SelectedObject');
str_est=get(est,'String');

switch str_est
    case 'Barra do Riacho'
        dhn=0.742;
        set(handles.str_offset,'String',num2str(0.742));
        case 'Cabiunas'
        dhn=1.041;
        set(handles.str_offset,'String',num2str(1.041));
        case 'Guamare'
        dhn=1.354;
        set(handles.str_offset,'String',num2str(1.354));
        case 'Jacone'
        dhn=0.76;
        set(handles.str_offset,'String',num2str(0.760));
        case 'Serra'
        dhn=1.354;
        set(handles.str_offset,'String',num2str(1.354));
end
for ii = 1:size(handles.name,2)
handles.arquivo{ii}(:,3)=handles.arquivo{ii}(:,3)+dhn;
dlmwrite([handles.path 'DHN_' handles.name{ii}],handles.arquivo{ii},'delimiter','\t','newline','pc','precision','%.3f')
end

% --- Executes during object creation, after setting all properties.
function str_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to str_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function graficar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graficar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graficar

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close gui_ibge_dhn
