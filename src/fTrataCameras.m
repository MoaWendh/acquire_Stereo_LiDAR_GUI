%*************************************************************************
% Name: Moa
% Data: 17/08/2022
% Descri��o: Esta fun��o executa as configura��es, parametriza��o das
% c�meras. Tamb�m possibilitar testar as aquisi��es antes do ensaio.
%*************************************************************************

function handles= fTrataCameras(handles)

clc;
manterLoop= 1;


while manterLoop
    
    % Escolha da fun��o a ser executada:
    choiceA = questdlg('Escolha uma das op��es abaixo:', 'Trata C�meras', ...
             'Ler par�metros do arquivo', 'Ler par�metros da c�mera', ...
             'Configurar c�meras', 'Ler par�metros do arquivo');
         
    switch choiceA
        case 'Ler par�metros do arquivo'
            handles= fLerParametrosDoArquivo(handles);
            if handles.ArquivoParamLido 
                msg= sprintf('Ok! Par�metros lidos do arquivo.');
                handles.editMsgs.String= msg;

                % Exibe os pr�metros lidos do arquivo de dados:
                fShowParamFile(handles);
            else
                msg= sprintf(' Problemas ao ler arquivos de par�metros.\n Verifique se o arquivo n�o est� corrompido!');
                msgbox(msg, 'Aten��o!', 'warn');
            end
            
        case 'Ler par�metros do c�mera'
            if (handles.camObjStarted)
                fShowParamCam(handles);
            else
                msg= sprintf(' As c�meras n�o foram abertas ainda.\n Primeiro crie os objetos das c�meras.!');
                msgbox(msg, 'Aten��o!', 'warn')    
            end
            
        case 'Configurar c�meras'
            % Chama fun��o para gravar os par�metros do arquivo na c�mera:
            if handles.ArquivoParamLido 
                fGravarParametrosNaCamera(handles);
                handles.msg= sprintf('Ok! Par�metros gravados nas c�meras.');
                handles.editMsgs.String= handles.msg;
                msg= msgbox(handles.msg, 'Conclu�do.');
                uiwait(msg);
            else
                handles.msg= sprintf('Primeiro carregue os arquivos de dados. ');
                msg= msgbox(handles.msg, 'Aten��o!', 'warn');
                uiwait(msg);
            end
            % Efetua a leitura dos par�metros das c�meras:
            handles= fLerParametrosDaCamera(handles); 
            % Exibe os par�metros da c�mera; 
            fShowParamCam(handles);        
    end
    
    % Dialogo Box para manter ou retonra a tela principal:
    choiceB = questdlg('Retornar � tela principal?', 'Sim', 'N�o', 'N�o');
    switch choiceA
        case 'Sim'
            ManterLoop= 0;
        case 'N�o'
            ManterLoop= 1;
    end
end



