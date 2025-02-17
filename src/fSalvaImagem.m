%*************************************************************************
% Name: Moa
% Data: 16/02/2022
% Descri��o: 
%*************************************************************************

function handles= fSalvaImagem(handles)

% Incrementa o contador de captura e salvamento de imagem:
ct= handles.ctCapture + 1;

% tempoFinalEnsaio= datestr(now,'HH:MM:SS.FFF');

for (i=1:length(handles.camObj))
    % i=1 indica a c�mera esquerda "L":
    if (i==1)
        % Define o path geral e nome do arquivo a ser salvo:
        nameFileL= sprintf('%0.4d%s', ct, handles.extImageFile);
        fullPath= fullfile(handles.param.pathToSaveImagesL, nameFileL);
        fullPathL= fullPath;
    else
        % Define o path geral e nome do arquivo a ser salvo:
        nameFileR= sprintf('%0.4d%s', ct, handles.extImageFile);
        fullPath= fullfile(handles.param.pathToSaveImagesR, nameFileR);           
        fullPathR= fullPath;
    end
    % Captura imagem:
    imageCap= getsnapshot(handles.camObj(i));
    % Salva a imagem:
    imwrite(imageCap, fullPath);   
end

msg= sprintf('Foi salva a imagem %s em:\n -> %s \nFoi salva a imagem %s em:\n -> %s', ...
    nameFileL, handles.param.pathToSaveImagesL, nameFileR, handles.param.pathToSaveImagesR);

handles.msg= msg;

% Atualiza o contador de imagens salvas:
handles.ctCapture= ct;
end