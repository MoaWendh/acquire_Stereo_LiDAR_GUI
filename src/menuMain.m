function choice = menuMain()

    fprintf('*************** Main Menu ******************\n');
    fprintf('********************************************\n');    
    fprintf('   0- Menu Stereo\n');
    fprintf('   1- Exibe Preview stereo & LiDAR\n');
    fprintf('   C- Capturar stereo & LiDAR\n');
    fprintf('   L- Limpar Menu\n');    
    fprintf('   S- Sair\n');
    fprintf('********************************************\n');
    msgChoice= sprintf('   Escolha uma das opções acima: \n');
    choice= input(msgChoice,'s'); 
    if isempty(choice)
        str = 'L';
    end
    clc;
end