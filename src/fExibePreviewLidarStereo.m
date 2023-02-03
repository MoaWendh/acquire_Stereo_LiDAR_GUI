function fExibePreviewLidarCamera(handles)
    % Abre preview do LiDAR:
    xLim= [-2 2] ;
    yLim= [0 5];
    zLim= [-1 1];
    preview(handles.lidar.lidar,xLim, yLim, zLim);    
          
    f1=figure;  
    f1.Name= 'Preview par estéreo';
    f1.WindowState='maximized';
    subplot(1,2,1);   
    title('Câmera Esquerda');
    hImageCam1= image(zeros(2048,2048));
    %obj1 = videoinput("pointgrey",1);
    preview(handles.camObj(1), hImageCam1); 

    subplot(1,2,2);   
    hImageCam2= image(zeros(2048,2048));
    %obj2 = videoinput("pointgrey",2);
    preview(handles.camObj(2), hImageCam2); 

    msg= sprintf('Pressione OK Para sair do preview.');
    figureBox= msgbox(msg);
    uiwait(figureBox);

    % Fecha preview do LiDAR:
    closePreview(handles.lidar.lidar);
    % Fecha preview Stereo:    
    stoppreview(handles.camObj(1));
    stoppreview(handles.camObj(2));
    %delete(obj1);
    %delete(obj2);
    close all;   
end