%function fCapturaSalvaNuvemDePontos(lidar, paramLidar, ctCap) 
function handles= fCapturaSalvaNuvemDePontos(handles) 
    
    % Captura nuvem de pontos:
    [pCloud, timeStamp]= read(handles.lidar.lidar, handles.lidar.numPointCloudToSave, handles.lidar.numPointCloudMode);
        
    %Salva nuvem de pontos em arquivo:
    nameFile= sprintf('%0.4d%s', handles.ctCapture , handles.lidar.extFile);
    fullPath= fullfile( handles.param.pathToSaveImagesLidar, nameFile);
    pcwrite(pCloud, fullPath, 'Encoding', 'ascii');
    
    % Salva o timeStamp da nuvem de ponto:    
    % salvaTimeStamp(timeStamp);
    
    handles.msg= sprintf('%s\n Foi salva a PC: \n -> %s', handles.msg, fullPath);
end
   