function choice = menuTrataStereo(param, tempCam)

    fprintf('*************** Câmera ***************\n');
    fprintf('   Fabricante     = %s \n',param(1).deviceName);
    fprintf('   Modelo         = %s \n',param(1).deviceModel);
    fprintf('   N/S cam. esq   = %s - Temp. %3.2fCº \n', param(1).deviceSerialNumber, tempCam(1) );
    fprintf('   N/S cam. dir   = %s - Temp. %3.2fCº \n', param(2).deviceSerialNumber, tempCam(2) );
    fprintf('**************************************\n');    
    fprintf('   0- Ler parâmetros das câmeras\n');
    fprintf('   1- Ler parâmetros do Arquivo ".dat"\n');
    fprintf('   2- Exibir os parâmetros das câmeras\n');
    fprintf('   3- Exibir os parâmetros do arquivo\n');
    fprintf('   4- Setar os parâmetros das câmeras com o arquivo ".dat"\n');
    fprintf('   5- Testa captura par estéreo\n');
    fprintf('   6- Exibe Preview stereo\n');
    fprintf('   L- Limpar Menu\n');    
    fprintf('   R- Retornar\n');
    fprintf('********************************************\n');
    msgChoice= sprintf('   Escolha uma das opções acima: \n');
    choice= input(msgChoice,'s');  
    if isempty(choice)
        str = 'L';
    end
    clc;
end