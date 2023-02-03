function handles= fGeraPaths(handles)

handles.param.pathToSaveImages= uigetdir('C:\Projetos\Matlab\Experimentos');

% gera paths para salvar o par estéreo, o folder considera as data atual:
% Define o formato da data:
formatOut = 'dd_mm_yy';
nameFolder= datestr(now, formatOut);
ctNameFolder= 65; % 65 equivale ao caracter A na tabela ASCII:
fullPath= sprintf('%s\\%s_%s',handles.param.pathToSaveImages, nameFolder, char(ctNameFolder));
pathDefinido= 0;

while ~(pathDefinido)
    if (isdir(fullPath))
        ctNameFolder= ctNameFolder + 1;
        if (ctNameFolder<91)
            % Conta até "Z" depois o contador volta a 65 e duplica o
            % caracter no final do nome. Mas esta é uma situação muito
            % remota, implica em existir um nº de folders maior que o alfabeto. 
            fullPath= sprintf('%s\\%s_%s',handles.param.pathToSaveImages, nameFolder, char(ctNameFolder))
        else
            %Retorna a contagem:
            ctNameFolder= 65;
            fullPath= sprintf('%s\\%s_%s',handles.param.pathToSaveImages, nameFolder, char(ctNameFolder));
        end
    else
        fullPathL= fullfile(fullPath, 'Camera\L');
        fullPathR= fullfile(fullPath, 'Camera\R');
        fullPathLidar= fullfile(fullPath, 'LiDAR');
        mkdir(fullPathL);
        mkdir(fullPathR);
        mkdir(fullPathLidar);
        pathDefinido= 1;
    end
end

% Gera o folder para salvas a imagem esquerda: 
handles.param.pathToSaveImagesL= fullPathL;

% Gera o folder para salvas a imagem esquerda: 
handles.param.pathToSaveImagesR= fullPathR;

% Gera o folder para salvar as PCs do LiDAR: 
handles.param.pathToSaveImagesLidar= fullPathLidar;

msg= sprintf('As imagens serão salvas em:\n   %s \n   %s \n \n As nuvens de ponto do LiDAR serão salvas em:\n   %s ', ...
            handles.param.pathToSaveImagesL, handles.param.pathToSaveImagesR, handles.param.pathToSaveImagesLidar);

handles.editMsgs.String= msg;

% Cria flag para sinalizar que os paths foram criados:
handles.pathsGerados= 1;

end