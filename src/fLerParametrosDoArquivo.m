%*************************************************************************
% Name: Moa
% Data: 11/02/2022
% Descri��o: Efetua a leitura dos par�metros gravados no arquivo.
% Caso o arquivo n�o exista, os par�metros ser�o criados de forma gen�rica,
% posteriormente o arquivo dever� ser gerado com os par�metros da c�mera,
% autom�tico ou manualmente.
% Esta fun��o retorna os par�metros que est�o gravados no arquivo "*.dat"
%*************************************************************************
function handles = fLerParametrosDoArquivo(handles)
handles.numParams= 13;

[handles.nameFileParam handles.pathFileParam]= uigetfile('C:\Projetos\Matlab\Experimentos\Calibracao\*.dat');

if (handles.nameFileParam~= 0)
    fullPath= fullfile( handles.pathFileParam, handles.nameFileParam);    
    fileID=fopen(fullPath,'r');
    
    if (fileID==-1)
        strA= sprintf(' Erro ao abrir arquivo %s -> C�digo do erro = %d\n', handles.pathFileParam, fileID);
        strB= sprintf(' Possivelmente inexistente ou nome errado!!!!!');
        handles.msg= sprintf(' %s \n %s \n', strA, strB);        
        handles.ArquivoParamLido= 0;
        
        % Criando uma struct com os par�metros gen�ricos!!!
        handles.paramFile.Fabricante      = '???';
        handles.paramFile.Brightness      = -100;
        handles.paramFile.Exposure        = -100;
        handles.paramFile.ExposureMode    = '???';
        handles.paramFile.FrameRate       = -100;
        handles.paramFile.FrameRateMode   = '???';
        handles.paramFile.Gain            = -100;
        handles.paramFile.GainMode        = '???';
        handles.paramFile.Shutter         = -100;
        handles.paramFile.ShutterMode     = '???';
        handles.paramFile.TriggerDelay    = -100;
        handles.paramFile.TriggerDelayMode= '???';
        handles.paramFile.TriggerParameter= -100;
    else
        % linha{1}= regexp(fgetl(fileID),'\s','split');      
        % ctFinal= 14;
        ctParam=0;
        while 1 % Efetua a leitura do arquivo at� fget() retornar o valor -1.
            ctParam= ctParam + 1;
            linhaAux= fgetl(fileID);
            if (linhaAux>0)
                linha{ctParam} = regexp(linhaAux,'\s','split');
            else
                if (ctParam== handles.numParams + 1)
                    handles.msg= sprintf('Foram lidos %d par�metros do arquivo de dados: \n "%s"', handles.numParams, fullPath);
                    handles.ArquivoParamLido= 1;
                    break;
                else 
                    strA= sprintf('Arquivo: \n "%s" \n com n�mero de par�metros diferente de %d.\n', fullPath, handles.numParams);
                    strB= sprintf('Verifique se o Arquivo "%s" est� corrompido.\n', handles.nameFileParam);
                    handles.msg= sprintf(' %s \n %s \n', strA, strB);                    
                    handles.ArquivoParamLido= 0;
                    break;
                end
            end
        end 
        fclose(fileID); % Fecha o arquivo.
        
        % Criando uma struct com os par�metros lidos do arquivo 'handles.paramFile.dat'.
        % Se o n�mero de par�metros for menor que numParam, os parametros receber�o
        % valores gen�ricos. 
        
        if (ctParam==(handles.numParams + 1))     
            handles.paramFile.Fabricante      = linha{1}{2};
            handles.paramFile.Brightness      = round(str2double(linha{2}{2}),2);
            handles.paramFile.Exposure        = round(str2double(linha{3}{2}),2);
            handles.paramFile.ExposureMode    = linha{4}{2};
            handles.paramFile.FrameRate       = round(str2double(linha{5}{2}),2);
            handles.paramFile.FrameRateMode   = linha{6}{2};
            handles.paramFile.Gain            = round(str2double(linha{7}{2}),2);
            handles.paramFile.GainMode        = linha{8}{2};
            handles.paramFile.Shutter         = round(str2double(linha{9}{2}),2);
            handles.paramFile.ShutterMode     = linha{10}{2};
            handles.paramFile.TriggerDelay    = round(str2double(linha{11}{2}),2);
            handles.paramFile.TriggerDelayMode= linha{12}{2};
            handles.paramFile.TriggerParameter= str2num(linha{13}{2}); 
        else
             % Criando uma struct com os par�metros genericos!!!
            handles.paramFile.Fabricante      = '???';
            handles.paramFile.Brightness      = -100;
            handles.paramFile.Exposure        = -100;
            handles.paramFile.ExposureMode    = '???';
            handles.paramFile.FrameRate       = -100;
            handles.paramFile.FrameRateMode   = '???';
            handles.paramFile.Gain            = -100;
            handles.paramFile.GainMode        = '???';
            handles.paramFile.Shutter         = -100;
            handles.paramFile.ShutterMode     = '???';
            handles.paramFile.TriggerDelay    = -100;
            handles.paramFile.TriggerDelayMode= '???';
            handles.paramFile.TriggerParameter= -100;       
        end             
    end 
else
    strA= sprintf(' Arquivo de par�metros n�o foi aberto.\n  Opera��o de abertura de arquivo foi cancelada.');
    handles.msg= sprintf(' %s \n', strA);   
end
end