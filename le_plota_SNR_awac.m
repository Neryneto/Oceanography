function le_plota_SNR_awac(caminho,colunas,nome_figura,nome_arquivo,corte_in,corte_fin)

arquivo = uigetfile({'*.a1'},'Selecionar arquivo a1',caminho);
fid = fopen([caminho '\' arquivo],'r');
line = fgetl(fid);
tmp = textscan(line, '%s');
n = size(tmp{1,1},1);
clear fid
fid = fopen([caminho '\' arquivo],'r');
a1=textscan(fid, repmat('%f ',[1 n]));

% clearvars -except a1 caminho n nome colunas corte_in corte_fin

arquivo = uigetfile({'*.a2'},'Selecionar arquivo a2',caminho);
fid = fopen([caminho '\' arquivo],'r');
a2=textscan(fid, repmat('%f ',[1 n]));

% clearvars -except a1 a2 caminho n nome colunas corte_in corte_fin

arquivo = uigetfile({'*.a3'},'Selecionar arquivo a3',caminho);
fid = fopen([caminho '\' arquivo],'r');
a3=textscan(fid, repmat('%f ',[1 n]));

% clearvars -except a1 a2 a3 caminho n nome colunas corte_in corte_fin

arquivo = uigetfile({'*.sen'},'Selecionar arquivo sen',caminho);
fid = fopen([caminho '\' arquivo],'r');
aux=[(repmat('%d ',[1 6])) '%*[^\n]'];
sen=textscan(fid, aux);

aux_data=[sen{1,3},sen{1,1},sen{1,2},sen{1,4},sen{1,5},sen{1,6}];
data=datenum(double(aux_data));

% clearvars -except a1 a2 a3 sen caminho n nome colunas data corte_in corte_fin

media=[];
for cols = 1:n;
    for tempo=1:size(a1{1,1},1)
        vetor=[a1{1,cols}(tempo,1);a2{1,cols}(tempo,1);a3{1,cols}(tempo,1)];
    media(tempo,cols)=nanmean(vetor)*0.43;
    end
end

media=media(corte_in+1:end-corte_fin,1:colunas);
data=data(corte_in+1:end-corte_fin,:);

f=figure(1);
pcolor(data,1:colunas,media(:,1:colunas)')
% shading interp
shading flat

xlim([data(1) data(end)]);
data_ini=floor(data(1,1));
data_fim=ceil(data(end,1));
aux_data=data_ini:data_fim;
xtickss=aux_data(1:7:end);
set(gca,'XTick',xtickss);
datetick('x','dd/mm','keepticks','keeplimits')
set(gca,'fontsize',8);
yticks=linspace(1,colunas,colunas+1);
yticklabel=1:colunas;
set(gca,'YTick',yticks,'YTickLabel',yticklabel);
ylim([1 colunas-0.1])
ylabel('Célula','fontsize',10)
title(['Signal-to-Noise Ratio (SNR) em ' nome_figura],'FontSize',14);
col=colorbar;
caxis([0, 100])
title(col,'Amplitude (dB)')
print('-dpng',[caminho '\SNR_em_' nome_arquivo],'-r300')
close (f)
end