function InternalQualityWave (caminho,nome)

arquivos = dir(fullfile(caminho,'*.wad'))

media_arquivo=[];
for j = 1:size(arquivos,1)
          % current file
          CurrentFile = fullfile(caminho,arquivos(j).name);
          
          [fid, errormsg] = fopen(CurrentFile, 'r+');
          dado=textscan(fid, repmat('%f ',[1 13]));
          media_cada=nanmean(dado{1,6})
          media_arquivo=[media_arquivo;media_cada];
end

clearvars -except media_arquivo caminho nome

arquivo = uigetfile({'*.whd'},'Selecionar arquivo .whd',caminho)
fid = fopen([caminho '\' arquivo],'r');
aux=[(repmat('%d ',[1 6])) '%*[^\n]'];
sen=textscan(fid, aux);

aux_data=[sen{1,3},sen{1,1},sen{1,2},sen{1,4},sen{1,5},sen{1,6}];
data=datenum(double(aux_data));

plot(data,media_arquivo*0.43);
end