%function fCapturaSalvaNuvemDePontos(lidar, paramLidar, ctCap) 
function fCapturaSalvaNuvemDePontos(handles) 
    
    % Captura nuvem de pontos:
    [pCloud, timeStamp]= read(lidar, paramLidar.numPointCloudToSave, paramLidar.numPointCloudMode);
        
    %Salva nuvem de pontos em arquivo:
    nameFile= sprintf('%0.4d%s', ctCap, paramLidar.extFile);
    fullPath= fullfile(paramLidar.PathToWrite, nameFile);
    pcwrite(pCloud, fullPath, 'Encoding', 'ascii');
    fprintf('Nuvem de pontos %s salva em: %s \n', nameFile, fullPath); 
    fprintf('\n');
    
    % Salva o timeStamp da nuvem de ponto:    
    % salvaTimeStamp(timeStamp);
end
   