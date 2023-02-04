function fShowPreviewLidar(handles)
   
%Define os limites dos eixos XYZ:
xLim= [-2 2] ;
yLim= [0 5];
zLim= [-1 1];

% Abre preview do LiDAR:
preview(handles.lidar.lidar, xLim, yLim, zLim);  

% Abre uma caixa de diálogo solictando para fechar o preview:
msg= sprintf(' Click com o mouse no gráfico para visualizar a nuvem de pontos. \n Ou "click Ok" para fehcar o preview.');
msgBox= msgbox(msg);
msgBox.Position= [50 200 250 70];
uiwait(msgBox);

% Fecha o preview do LiDAR:
closePreview(handles.lidar.lidar);
end
