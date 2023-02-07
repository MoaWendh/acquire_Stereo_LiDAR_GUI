function handles= fCapturaSalvaNuvemDePontos(handles) 

    handles.PcErro= 0;
    
    % Captura nuvem de pontos em função do modo de aquisição do LiDAR.
    % O parâmetro "handles.numPointCloudMode" define o modo de aquisição.
    if (handles.numPointCloudMode== "")
        [pcFull, timeStamp]= read(handles.lidar.lidar, handles.numAmostrasPorPC);
    elseif (handles.numPointCloudMode== "all")
        start(handles.lidar.lidar);
        
        % Pausa em ms para capturar o buffer inteiro:
        pause(handles.Delay);
        PointCloudMode= string(handles.numPointCloudMode);
        [pCloud, timeStamp]= read(handles.lidar.lidar, PointCloudMode);  
        stop(handles.lidar.lidar);
        
        % Concatena as PCs:
        if (length(pCloud)>1)
            for (ctPC=1:length(pCloud))
                if (ctPC==1)
                    pcFull.Location= pCloud(1).Location;
                    pcFull.Intensidade= pCloud(1).Intensity;
                else
                    pcFull.Location= [pcFull.Location pCloud(ctPC).Location];
                    pcFull.Intensidade= [pcFull.Intensidade pCloud(ctPC).Intensity]
                end
            end
            pcFull= pointCloud(pcFull.Location,'Intensity',pcFull.Intensidade);   
        else
            msg=sprintf(' Buffer vazio!! não foram adquiridas PCs. \n Incremente o Delay para leitura do buffer.');
            handles= fTrataMsg(handles, msg);
            handles.PcErro= '1';
        end         
    else        
        [pCloud, timeStamp]= read(handles.lidar.lidar, handles.numAmostrasPorPC, handles.numPointCloudMode);
        % COmo o Matlab não presrva as informações do canais usando as funções 
        % nativas, tais como pcat() ou pcmerge(), as N pcs capturadas são concatendas
        % conforme abaixo, preservando as informações dos canais e da intensidade: 
        for (ctPC=1:handles.numAmostrasPorPC)
            if (ctPC==1)
                pcFull.Location= pCloud(1).Location;
                pcFull.Intensidade= pCloud(1).Intensity;
            else
                pcFull.Location= [pcFull.Location pCloud(ctPC).Location];
                pcFull.Intensidade= [pcFull.Intensidade pCloud(ctPC).Intensity]
            end
        end
        pcFull= pointCloud(pcFull.Location,'Intensity',pcFull.Intensidade);
    end
    
    % Se handlessavePcSingle estiver habilitado será salva uma PC com
    % apenas 1 amostra, 1 giro do liDAR:
    if handles.savePcSingle
        [pcSingle, timeStampSingle]= read(handles.lidar.lidar, 1);
    end   
    
    %Salva nuvem de pontos em arquivo:   
    if ~(handles.PcErro)
        nameFile= sprintf('%0.4d%s', handles.ctCapture, handles.lidar.extFile);
        fullPath= fullfile(handles.param.pathToSaveLidarMult, nameFile);
        pcwrite(pcFull, fullPath, 'Encoding', 'ascii');

        % Gera mensagem:
        msg= sprintf('Foi salva a PC mult %s em:\n -> %s', nameFile, handles.param.pathToSaveLidarMult); 
        handles.msg= sprintf('%s\n %s', handles.msg, msg);

        % Se estiver ativado o handles.savePcSingle será salva uma PC
        % contendo apenas uma amostra de nuvem depontos:
        if (handles.savePcSingle)
            fullPath= fullfile(handles.param.pathToSaveLidarSingle, nameFile);
            pcwrite(pcSingle, fullPath, 'Encoding', 'ascii');
            msg= sprintf('Foi salva a PC single %s em:\n -> %s', nameFile, handles.param.pathToSaveLidarSingle); 
            handles.msg= sprintf('%s \n %s',handles.msg, msg);
        end
    end
end
   