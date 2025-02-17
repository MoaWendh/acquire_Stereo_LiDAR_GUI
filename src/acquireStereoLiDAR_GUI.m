function varargout = acquireStereoLiDAR_GUI(varargin)
% ACQUIRESTEREOLIDAR_GUI MATLAB code for acquireStereoLiDAR_GUI.fig
%      ACQUIRESTEREOLIDAR_GUI, by itself, creates a new ACQUIRESTEREOLIDAR_GUI or raises the existing
%      singleton*.
%
%      H = ACQUIRESTEREOLIDAR_GUI returns the handle to a new ACQUIRESTEREOLIDAR_GUI or the handle to
%      the existing singleton*.
%
%      ACQUIRESTEREOLIDAR_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACQUIRESTEREOLIDAR_GUI.M with the given input arguments.
%
%      ACQUIRESTEREOLIDAR_GUI('Property','Value',...) creates a new ACQUIRESTEREOLIDAR_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before acquireStereoLiDAR_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to acquireStereoLiDAR_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help acquireStereoLiDAR_GUI

% Last Modified by GUIDE v2.5 07-Feb-2023 20:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @acquireStereoLiDAR_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @acquireStereoLiDAR_GUI_OutputFcn, ...
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


% --- Executes just before acquireStereoLiDAR_GUI is made visible.
function acquireStereoLiDAR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to acquireStereoLiDAR_GUI (see 

%************ Parâmetros do usuário abaixo ********************************

% Parâmetro, flag, que indica que o arqquivo de dados foi carregado para a
% memória, possibilitando alterar os parãmetros das câmeras:
handles.ArquivoParamLido= 0;
handles.camObjStarted= 0;
handles.camObj(1).DeviceID= 0;
handles.ctCapture= 0;
handles.pathsGerados= 0;
handles.extImageFile= '.png';

% Este parâmetro "handles.param.pathToSaveImagesOld" serve para guardar o 
% path atual, quando for solicitado um novo path e a operação cancelada,
% ele manterá o path anterior válido, ver função fGerPaths():
handles.param.pathToSave= "";

% Definição inicial dos parâmetros do LiDAR:
handles.lidar.Model= 'VLP16';
handles.lidar.Timeout= 15;
handles.lidar.extFile= '.pcd';
handles.lidar.fileCalibration= 'vlp16.xml';
handles.lidar.numPointCloudMode= 'latest';
handles.lidar.numPointCloudToSave= 1;
handles.Lidar.LidarStarted= 0;

%************ Parâmetros do usuário acima *********************************

% Choose default command line output for acquireStereoLiDAR_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes acquireStereoLiDAR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figureBase2);

% --- Outputs from this function are returned to the command line.
function varargout = acquireStereoLiDAR_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbAbrirAsCameras.
function pbAbrirAsCameras_Callback(hObject, eventdata, handles)
% hObject    handle to pbAbrirAsCameras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Antes de ler os parâmetros da câmera tem que ser criado um objeto para o
% device câmera.
% Abre e cria um objeto para acessar as câmeras:

% Mensagem inicial:
msg= sprintf(' Abrindo as câmeras...\n Se demorar mais que 10 seg. pode ser que tenha ocorrido um problema.');
handles.editMsgs.String= msg;

[handles.camObj handles.paramCamHW]= fOpenCam();

if (handles.camObj(1).DeviceID)
    if (handles.ArquivoParamLido)
        handles.pbConfigCams.Enable= 'on';
    else
        handles.pbConfigCams.Enable= 'off';        
    end
    
    handles.pbShowParamCams.Enable= 'on';        
    handles.pbTesteCapturaImages.Enable= 'on';
    handles.camObjStarted= 1;
    msg= sprintf('Foram criados %d objetos para os devices:\n - Câmera: %s\n - Câmera: %s', ...
                length(handles.camObj), handles.paramCamHW(1).deviceModel, handles.paramCamHW(2).deviceModel);
    handles.editMsgs.String= msg;
    handles.staticCameras.String= 'Ok.';
    handles.staticCameras.ForegroundColor= [0, 0.6, 0];
else
    handles.camObjStarted= 0;
    handles.pbShowParamCams.Enable= 'off';
    handles.pbConfigCams.Enable= 'off';
    handles.pbTesteCapturaImages.Enable= 'off';    
end

% Se a câmera está aberta, liDAR inicailizado, arq. de parãmetros lido e os
% paths forma gerados, serão habilitadas os seguintes botões:
if (handles.pathsGerados && handles.Lidar.LidarStarted && handles.camObjStarted && handles.ArquivoParamLido)
    handles.pbPreviewStereoLidar.Enable= 'on';
    handles.pbCapturaStereoLidar.Enable= 'on';
else
    handles.pbPreviewStereoLidar.Enable= 'off';
    handles.pbCapturaStereoLidar.Enable= 'off';    
end

% Efetua a leitura dos parãmetros das câmeras:
handles= fLerParametrosDaCamera(handles); 

% Update handles structure
guidata(hObject, handles);


function editMsg_Callback(hObject, eventdata, handles)
% hObject    handle to editMsgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMsgs as text
%        str2double(get(hObject,'String')) returns contents of editMsgs as a double


% --- Executes during object creation, after setting all properties.
function editMsgs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMsgs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pbLerParamFiles.
function pbLerParamFiles_Callback(hObject, eventdata, handles)
% hObject    handle to pbLerParamFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%param.numFiles= 1001;

% Faz a leitura dos parâmetros previamente armazenados num arquivo de
% dados, Este arquivo pé usado para coonfigurar as cãmeras com os
% parâmetros desejados no ensaio:
handles= fLerParametrosDoArquivo(handles);

if (handles.ArquivoParamLido)
    if (handles.camObjStarted)
        handles.pbConfigCams.Enable= 'on';
    else
        handles.pbConfigCams.Enable= 'off';        
    end
    
    handles.pbExibeParamFiles.Enable= 'on';
    handles.editMsgs.String= handles.msg;
    handles.staticLerArquivoParam.String= 'Ok.';
    handles.staticLerArquivoParam.ForegroundColor= [0.0, 0.6, 0.0];   
    
    % Exibe os prâmetros lidos do arquivo de dados:
    % fShowParamFile(handles);
else
    handles.pbExibeParamFiles.Enable= 'off';
    msgbox(handles.msg, 'Atenção!', 'warn');
    
    handles.staticLerArquivoParam.String= 'Arquivo não lido.';
    handles.staticLerArquivoParam.ForegroundColor= [1, 0.0, 0.0];
end

% Se a câmera está aberta, liDAR inicailizado, arq. de parãmetros lido e os
% paths forma gerados, serão habilitadas os seguintes botões:
if (handles.pathsGerados && handles.Lidar.LidarStarted && handles.camObjStarted && handles.ArquivoParamLido)
    handles.pbPreviewStereoLidar.Enable= 'on';
    handles.pbCapturaStereoLidar.Enable= 'on';
else
    handles.pbPreviewStereoLidar.Enable= 'off';
    handles.pbCapturaStereoLidar.Enable= 'off';    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbShowParamCams.
function pbShowParamCams_Callback(hObject, eventdata, handles)
% hObject    handle to pbShowParamCams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.camObjStarted)
    fShowParamCam(handles);
else
    msg= sprintf(' As câmeras não foram abertas ainda.\n Primeiro crie os objetos das câmeras.!');
    msgbox(msg, 'Atenção!', 'warn')    
end


% --- Executes on button press in pbConfigCams.
function pbConfigCams_Callback(hObject, eventdata, handles)
% hObject    handle to pbConfigCams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Chama função para gravar os parãmetros do arquivo na câmera:
if handles.ArquivoParamLido 
    fGravarParametrosNaCamera(handles);
    msg= sprintf(' Parâmetros gravados nas câmeras.');
    handles.editMsgs.String= msg;
else
    msg= sprintf(' Primeiro carregue os arquivos de dados. ');
    msgbox(msg, 'Atenção!', 'warn');
end

% Efetua a leitura dos parãmetros das câmeras:
handles= fLerParametrosDaCamera(handles); 

% Exibe os parâmetros da câmera; 
fShowParamCam(handles);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbTesteCapturaImages.
function pbTesteCapturaImages_Callback(hObject, eventdata, handles)
% hObject    handle to pbTesteCapturaImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Verica se a aquisição das câmeras está ok. 
if (handles.camObjStarted)
    fShowSnapShot(handles);
    msg= sprintf(' Imagens capturadas.\n Verifique a qualidade.');
    handles.editMsgs.String= msg;    
else
    msg= sprintf(' As câmeras não foram abertas ainda.\n Primeiro crie os objetos das câmeras.!');
    msgbox(msg, 'Atenção!', 'warn')    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbPreviewParEstereo.
function pbPreviewParEstereo_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreviewParEstereo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Abre um stream das duas câmeras. 
fShowPreviewStereo(handles);



% --- Executes on button press in pbClose.
function pbClose_Callback(hObject, eventdata, handles)
% hObject    handle to pbClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.camObj(1).DeviceID)
    % Fecha o hardware e reseta todas as variáveis:
    imaqreset; % Fecha o hardware.
    delete(handles.camObj); % Deleta o objeto aberto.
end

% Fecha o programa:
handles.figureBase2.HandleVisibility= 'on';
clc;
clear;
close all;


% --- Executes on button press in pbDefinePathsToSave.
function pbDefinePathsToSave_Callback(hObject, eventdata, handles)
% hObject    handle to pbDefinePathsToSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles= fGeraPaths(handles);

if (handles.pathsGerados)
    handles.staticPaths.String= 'Ok.';
    handles.staticPaths.ForegroundColor= [0.0, 0.6, 0.0];
    MsgBox= msgbox(handles.msg);
    uiwait(MsgBox);
else
    handles.staticPaths.String= 'Indefinido';
    handles.staticPaths.ForegroundColor= [1, 0.0, 0.0];       
    MsgBox= msgbox(handles.msg);
    uiwait(MsgBox);
end

% Se a câmera também está aberta, liDAR inicailizado e arq. de parãmetros lido,
% serão habilitadas os seguintes botões:
if (handles.pathsGerados && handles.Lidar.LidarStarted && handles.camObjStarted && handles.ArquivoParamLido)
    handles.pbPreviewStereoLidar.Enable= 'on';
    handles.pbCapturaStereoLidar.Enable= 'on';
else
    handles.pbPreviewStereoLidar.Enable= 'off';
    handles.pbCapturaStereoLidar.Enable= 'off';    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbCapturaStereoLidar.
function pbCapturaStereoLidar_Callback(hObject, eventdata, handles)
% hObject    handle to pbCapturaStereoLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Só serão capturadas e salvas imagens se os folders foram craidos e se
% as câmeras foram inicializadas:
if (handles.pathsGerados)
    if (handles.camObjStarted)
        % Salva o par de imgens:
        handles= fSalvaImagem(handles);
        
        % Salva a nuvem de pontos do LiDAR:
        handles= fCapturaSalvaNuvemDePontos(handles);
    else
        msg= sprintf(' As câmeras não foram abertas ainda.\n Primeiro crie os objetos das câmeras.!');
        msgbox(msg, 'Atenção!', 'warn') 
    end
else
    msg= sprintf(' Primeiro crie os paths onde serão salvas as imagens L e R.');
    msgbox(msg, 'Atenção!', 'warn')        
end

% Imprime as imagens salvas: 
handles.editMsgs.String= handles.msg;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pbAbrirAsCameras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pbAbrirAsCameras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbPreviewStereoLidar.
function pbPreviewStereoLidar_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreviewStereoLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Chama função para exibir preview do LiDAR e cãmeras simultaneamente:
fExibePreviewLidarStereo(handles);



% --- Executes on button press in pbAbreLidar.
function pbAbreLidar_Callback(hObject, eventdata, handles)
% hObject    handle to pbAbreLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Mensagem inicial:
msg= sprintf(' Abrindo LiDAR Puck Lite...\n Se demorar mais que 5 seg. pode ser que tenha ocorrido um problema.');
handles.editMsgs.String= msg;

% Abre o device LiDAR VPL-16:
handles.lidar.lidar= velodynelidar(handles.lidar.Model, 'Timeout', handles.lidar.Timeout);

%Pega os parâmetros do LiDAR:
model= handles.lidar.lidar.Model;
IP= handles.lidar.lidar.IPAddress;
port= handles.lidar.lidar.Port;
pathCalibFile= handles.lidar.lidar.CalibrationFile;

msg= sprintf('LiDAR %s Aberto:\n -> IP Address: %s\n -> Port: %d\n -> Calib file:\n %s', model, IP, port, pathCalibFile);
handles.editMsgs.String= msg;

% Flag que sinaliza que o LiDAR foi aberto e tem um objeto criado para ele: 
handles.Lidar.LidarStarted= 1;

handles.staticLidar.String= 'Ok.';
handles.staticLidar.ForegroundColor= [0, 0.6, 0];

% Se a câmera está aberta, liDAR inicailizado, arq. de parãmetros lido e os
% paths forma gerados, serão habilitadas os seguintes botões:
if (handles.pathsGerados && handles.Lidar.LidarStarted && handles.camObjStarted && handles.ArquivoParamLido)
    handles.pbPreviewStereoLidar.Enable= 'on';
    handles.pbCapturaStereoLidar.Enable= 'on';
else
    handles.pbPreviewStereoLidar.Enable= 'off';
    handles.pbCapturaStereoLidar.Enable= 'off';    
end


% Habilita o botão para o preview do LiDAR
handles.pbPreviewLidar.Enable= 'on';

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbPreviewLidar.
function pbPreviewLidar_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreviewLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Chama função que exibe o preview do LiDAR:
fShowPreviewLidar(handles);


% --- Executes on button press in pbExibeParamFiles.
function pbExibeParamFiles_Callback(hObject, eventdata, handles)
% hObject    handle to pbExibeParamFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exibe os prâmetros previamente defindos em arquivo:
fShowParamFile(handles); 



function editTimeOutLidar_Callback(hObject, eventdata, handles)
% hObject    handle to editTimeOutLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTimeOutLidar as text
%        str2double(get(hObject,'String')) returns contents of editTimeOutLidar as a double
val= str2double(hObject.String);

% Define um elay em segundo para ler o nuffer do LiDAR:
if (val>0.3)
    handles.Delay= val;
else
   msg= sprintf('O valor mínimo aceito para o delay é de 300 ms. Escolha um valor superior'); 
   msgbox(msg);
   hObject.String= '0.3';
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editTimeOutLidar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTimeOutLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

val= str2double(hObject.String);

% Define um elay em segundo para ler o nuffer do LiDAR:
handles.Delay= val;

% Update handles structure
guidata(hObject, handles);



function editNumAmostrasPorPC_Callback(hObject, eventdata, handles)
% hObject    handle to editNumAmostrasPorPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNumAmostrasPorPC as text
%        str2double(get(hObject,'String')) returns contents of editNumAmostrasPorPC as a double

% Define a quantidade de amostras por captura do LiDAR:
val= str2num(hObject.String);
handles.numAmostrasPorPC= val;

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function editNumAmostrasPorPC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNumAmostrasPorPC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Define a quantidade de amostras por captura do LiDAR:
val= str2num(hObject.String);
handles.numAmostrasPorPC= val;

% Update handles structure
guidata(hObject, handles);



% --- Executes on selection change in popupModeBufferLidar.
function popupModeBufferLidar_Callback(hObject, eventdata, handles)
% hObject    handle to popupModeBufferLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupModeBufferLidar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupModeBufferLidar

handles.numPointCloudMode= hObject.String(hObject.Value);

% Update handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupModeBufferLidar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupModeBufferLidar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.numPointCloudMode= hObject.String(hObject.Value);

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in rdSavePcSingleSample.
function rdSavePcSingleSample_Callback(hObject, eventdata, handles)
% hObject    handle to rdSavePcSingleSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdSavePcSingleSample

% Habilita salvar um PC com apenas 1 amostra juntamnte com as multiplas PCs:
if hObject.Value
    handles.savePcSingle= 1;
else
    handles.savePcSingle= 0;    
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rdSavePcSingleSample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rdSavePcSingleSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Habilita salvar um PC com apenas 1 amostra juntamnte com as multiplas PCs:
handles.savePcSingle= 1;

% Update handles structure
guidata(hObject, handles);
