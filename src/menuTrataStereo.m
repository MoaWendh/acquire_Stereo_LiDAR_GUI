function choice = menuTrataStereo(param, tempCam)

    fprintf('*************** C�mera ***************\n');
    fprintf('   Fabricante     = %s \n',param(1).deviceName);
    fprintf('   Modelo         = %s \n',param(1).deviceModel);
    fprintf('   N/S cam. esq   = %s - Temp. %3.2fC� \n', param(1).deviceSerialNumber, tempCam(1) );
    fprintf('   N/S cam. dir   = %s - Temp. %3.2fC� \n', param(2).deviceSerialNumber, tempCam(2) );
    fprintf('**************************************\n');    
    fprintf('   0- Ler par�metros das c�meras\n');
    fprintf('   1- Ler par�metros do Arquivo ".dat"\n');
    fprintf('   2- Exibir os par�metros das c�meras\n');
    fprintf('   3- Exibir os par�metros do arquivo\n');
    fprintf('   4- Setar os par�metros das c�meras com o arquivo ".dat"\n');
    fprintf('   5- Testa captura par est�reo\n');
    fprintf('   6- Exibe Preview stereo\n');
    fprintf('   L- Limpar Menu\n');    
    fprintf('   R- Retornar\n');
    fprintf('********************************************\n');
    msgChoice= sprintf('   Escolha uma das op��es acima: \n');
    choice= input(msgChoice,'s');  
    if isempty(choice)
        str = 'L';
    end
    clc;
end