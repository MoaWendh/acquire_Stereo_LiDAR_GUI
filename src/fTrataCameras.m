%*************************************************************************
% Name: Moa
% Data: 17/08/2022
% Descrição: Esta função executa as configurações, parametrização das
% cãmeras. Também possibilitar testar as aquisições antes do ensaio.
%*************************************************************************

function handles= fTrataCameras(handles)

clc;
manterLoop= 1;


while manterLoop
    
    % Escolha da função a ser executada:
    choiceA = questdlg('Escolha uma das opções abaixo:', 'Trata Câmeras', ...
             'Ler parâmetros do arquivo', 'Ler parâmetros da câmera', ...
             'Configurar câmeras', 'Ler parâmetros do arquivo');
         
    switch choiceA
        case 'Ler parâmetros do arquivo'
            handles= fLerParametrosDoArquivo(handles);
            if handles.ArquivoParamLido 
                msg= sprintf('Ok! Parâmetros lidos do arquivo.');
                handles.editMsgs.String= msg;

                % Exibe os prâmetros lidos do arquivo de dados:
                fShowParamFile(handles);
            else
                msg= sprintf(' Problemas ao ler arquivos de parâmetros.\n Verifique se o arquivo não está corrompido!');
                msgbox(msg, 'Atenção!', 'warn');
            end
            
        case 'Ler parâmetros do câmera'
            if (handles.camObjStarted)
                fShowParamCam(handles);
            else
                msg= sprintf(' As câmeras não foram abertas ainda.\n Primeiro crie os objetos das câmeras.!');
                msgbox(msg, 'Atenção!', 'warn')    
            end
            
        case 'Configurar câmeras'
            % Chama função para gravar os parãmetros do arquivo na câmera:
            if handles.ArquivoParamLido 
                fGravarParametrosNaCamera(handles);
                handles.msg= sprintf('Ok! Parâmetros gravados nas câmeras.');
                handles.editMsgs.String= handles.msg;
                msg= msgbox(handles.msg, 'Concluído.');
                uiwait(msg);
            else
                handles.msg= sprintf('Primeiro carregue os arquivos de dados. ');
                msg= msgbox(handles.msg, 'Atenção!', 'warn');
                uiwait(msg);
            end
            % Efetua a leitura dos parãmetros das câmeras:
            handles= fLerParametrosDaCamera(handles); 
            % Exibe os parâmetros da câmera; 
            fShowParamCam(handles);        
    end
    
    % Dialogo Box para manter ou retonra a tela principal:
    choiceB = questdlg('Retornar à tela principal?', 'Sim', 'Não', 'Não');
    switch choiceA
        case 'Sim'
            ManterLoop= 0;
        case 'Não'
            ManterLoop= 1;
    end
end



