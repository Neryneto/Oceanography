function varargout = gui_escolha_estacao(varargin)
% GUI_ESCOLHA_ESTACAO MATLAB code for gui_escolha_estacao.fig
%      GUI_ESCOLHA_ESTACAO, by itself, creates a new GUI_ESCOLHA_ESTACAO or raises the existing
%      singleton*.
%
%      H = GUI_ESCOLHA_ESTACAO returns the handle to a new GUI_ESCOLHA_ESTACAO or the handle to
%      the existing singleton*.
%
%      GUI_ESCOLHA_ESTACAO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ESCOLHA_ESTACAO.M with the given input arguments.
%
%      GUI_ESCOLHA_ESTACAO('Property','Value',...) creates a new GUI_ESCOLHA_ESTACAO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_escolha_estacao_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_escolha_estacao_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_escolha_estacao

% Last Modified by GUIDE v2.5 20-Oct-2016 23:17:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_escolha_estacao_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_escolha_estacao_OutputFcn, ...
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


% --- Executes just before gui_escolha_estacao is made visible.
function gui_escolha_estacao_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_escolha_estacao (see VARARGIN)

% Choose default command line output for gui_escolha_estacao
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_escolha_estacao wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_escolha_estacao_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BDR.
function BDR_Callback(hObject, eventdata, handles)
% hObject    handle to BDR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='BDR';

% Hint: get(hObject,'Value') returns toggle state of BDR


% --- Executes on button press in CAB.
function CAB_Callback(hObject, eventdata, handles)
% hObject    handle to CAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='CAB';
% Hint: get(hObject,'Value') returns toggle state of CAB


% --- Executes on button press in GUA1.
function GUA1_Callback(hObject, eventdata, handles)
% hObject    handle to GUA1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='GUA1';
% Hint: get(hObject,'Value') returns toggle state of GUA1


% --- Executes on button press in GUA2.
function GUA2_Callback(hObject, eventdata, handles)
% hObject    handle to GUA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='GUA2';
% Hint: get(hObject,'Value') returns toggle state of GUA2


% --- Executes on button press in GUA3.
function GUA3_Callback(hObject, eventdata, handles)
% hObject    handle to GUA3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='GUA3';
% Hint: get(hObject,'Value') returns toggle state of GUA3


% --- Executes on button press in Jac.
function Jac_Callback(hObject, eventdata, handles)
% hObject    handle to Jac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='JAC';
% Hint: get(hObject,'Value') returns toggle state of Jac


% --- Executes on button press in SER1.
function SER1_Callback(hObject, eventdata, handles)
% hObject    handle to SER1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='SER1';
% Hint: get(hObject,'Value') returns toggle state of SER1


% --- Executes on button press in SER2.
function SER2_Callback(hObject, eventdata, handles)
% hObject    handle to SER2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='SER2';
% Hint: get(hObject,'Value') returns toggle state of SER2


% --- Executes on button press in SER3.
function SER3_Callback(hObject, eventdata, handles)
% hObject    handle to SER3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='SER3';
% Hint: get(hObject,'Value') returns toggle state of SER3


% --- Executes on button press in SER4.
function SER4_Callback(hObject, eventdata, handles)
% hObject    handle to SER4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nome_est 
nome_est='SER4';
% Hint: get(hObject,'Value') returns toggle state of SER4


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all
