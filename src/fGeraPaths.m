function handles= fGeraPaths(handles)

pathToSave= uigetdir('C:\Projetos\Matlab\Experimentos');

if (pathToSave)
    handles.param.pathToSave= pathToSave; 
    % Aqui também tem que ser zerado o contador capturadas
    handles.ctCapture= 0;
    
    % gera paths para salvar o par estéreo, o folder considera as data atual:
    % Define o formato da data:
    formatOut = 'dd_mm_yy';
    nameFolder= datestr(now, formatOut);
    ctNameFolder= 65; % 65 equivale ao caracter A na tabela ASCII:
    fullPath= sprintf('%s\\%s_%s',handles.param.pathToSave, nameFolder, char(ctNameFolder));
    pathDefinido= 0;

    while ~(pathDefinido)
        if (isdir(fullPath))
            ctNameFolder= ctNameFolder + 1;
            if (ctNameFolder<91)
                % Conta até "Z" depois o contador volta a 65 e duplica o
                % caracter no final do nome. Mas esta é uma situação muito
                % remota, implica em existir um nº de folders maior que o alfabeto. 
                fullPath= sprintf('%s\\%s_%s',handles.param.pathToSave, nameFolder, char(ctNameFolder))
            else
                %Retorna a contagem:
                ctNameFolder= 65;
                fullPath= sprintf('%s\\%s_%s',handles.param.pathToSave, nameFolder, char(ctNameFolder));
            end
        else
            fullPathL= fullfile(fullPath, 'Camera\L');
            fullPathR= fullfile(fullPath, 'Camera\R');
            fullPathLidarMult= fullfile(fullPath, 'LiDAR','mult');
            fullPathLidarSingle= fullfile(fullPath, 'LiDAR','single');
            mkdir(fullPathL);
            mkdir(fullPathR);
            mkdir(fullPathLidarMult);
            mkdir(fullPathLidarSingle);
            pathDefinido= 1;
        end
    end

    % Gera o folder para salvas a imagem esquerda: 
    handles.param.pathToSaveImagesL= fullPathL;

    % Gera o folder para salvas a imagem esquerda: 
    handles.param.pathToSaveImagesR= fullPathR;

    % Gera o folder para salvar as PCs do LiDAR: 
    handles.param.pathToSaveLidarMult= fullPathLidarMult;
    handles.param.pathToSaveLidarSingle= fullPathLidarSingle;

    msg= sprintf('As imagens serão salvas em:\n   %s \n   %s \n \nAs nuvens de ponto do LiDAR serão salvas em:\n   %s \n   %s', ...
                handles.param.pathToSaveImagesL, handles.param.pathToSaveImagesR, handles.param.pathToSaveLidarMult, handles.param.pathToSaveLidarSingle);

    handles.editMsgs.String= msg;

    msg= sprintf('O path foi alterado com sucesso.');
    handles.msg= msg; 
    
    % Cria flag para sinalizar que os paths foram criados:
    handles.pathsGerados= 1;
else
    if strcmp(handles.param.pathToSave,"")
        handles.pathsGerados= 0;
        msg= sprintf('A definição do path continua indefinida.');
        handles.msg= msg;    
    else
        msg= sprintf('O path continua sendo o anterior. \nAs imagens serão salvas em:\n   %s \n   %s \n \nAs nuvens de ponto do LiDAR serão salvas em:\n   %s \n   %s', ...
             handles.param.pathToSaveImagesL, handles.param.pathToSaveImagesR, handles.param.pathToSaveLidarMult, handles.param.pathToSaveLidarSingle);

        handles.editMsgs.String= msg;
        
        msg= sprintf('O path continua sendo o anterior.');
        handles.msg= msg;            
    end
end
end