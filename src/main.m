%*************************************************************************
% Name: Moa
% Data: 17/08/2022
% Descrição: Programa para captura um par de imagens durante o procedimento
% de calibração. Câmera PointGrey ou Flir.
%*************************************************************************

clc;
clear;
close all;

% Definição inicial dos parâmetros do LiDAR:
paramLidar.Timeout= 15;
paramLidar.Model= 'VLP16';
paramLidar.extFile= '.pcd';
paramLidar.PathToWrite='C:\Projetos\Matlab\Experimentos\LiDAR_Estereo\Plano\12_11_2022_A\LiDAR'; 
paramLidar.PathToRead= 'C:\Projetos\Matlab\Experimentos\LiDAR_Estereo\Plano\12_11_2022_A\LiDAR';
paramLidar.fileCalibration= 'vlp16.xml';
paramLidar.numPointCloudMode= 'latest';
paramLidar.numPointCloudToSave= 1;

% Definição inicial dos parâmetros das câmeras:
paramCamGeral.PathToImageL  = 'C:\Projetos\Matlab\Experimentos\LiDAR_Estereo\Plano\12_11_2022_A\Camera\L'; 
paramCamGeral.PathToImageR  = 'C:\Projetos\Matlab\Experimentos\LiDAR_Estereo\Plano\12_11_2022_A\Camera\R'; 
paramCamGeral.PathToArqParam= 'C:\Projetos\Matlab\Experimentos\LiDAR_Estereo\Plano\12_11_2022_A';
paramCamGeral.nameArqParam  = '\camParametrosEnsaio.dat';
paramCamGeral.numParam= 13;
paramCamGeral.nameFileL= '';
paramCamGeral.nameFileR= '';
paramCamGeral.extFile= '.png';
% Contador do número de imgens capturaas e salvas: 
countCapturaImagem= 0;

% Abre o device LiDAR VPL-16:
lidar= velodynelidar(paramLidar.Model, 'Timeout', paramLidar.Timeout);
% Chama função para abrir reconhecer os devices e abrir câmera:
[camObj paramCamHW]= openCam();

parametrosDaCamera= lerParametrosDaCamera(camObj, paramCamHW);
parametrosDoArq= lerParametrosDoArquivo(paramCamGeral);
countCaptura= 0;

 % Principal extrutura para operação do mainMenu.
while 1
    choice= menuMain();
    if (choice=='s' || choice=='S' )     
        break;    
    elseif (choice=='A' || choice=='a' )     
        continue;
    else
        switch choice
            case '0'
                fTrataStereo(camObj, paramCamHW, paramCamGeral);                
            case '1'
                fExibePreviewLidarStereo(lidar, camObj);
            case 'C' 
                countCaptura= fSalvaImagem(camObj, paramCamGeral, countCaptura); 
                fCapturaSalvaNuvemDePontos(lidar, paramLidar, ctCap);
            case 'c' 
                countCaptura= fSalvaImagem(camObj, paramCamGeral, countCaptura);
                fCapturaSalvaNuvemDePontos(lidar, paramLidar, countCaptura);
            otherwise
                disp('Escolha um valor válido!!!');
        end 
    end
end

% Fecha o hardware e reseta todas as variáveis:
imaqreset; % Fecha o hardware.
delete(camObj); % Deleta o objeto aberto.



