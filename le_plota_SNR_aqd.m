function le_plota_SNR_aqd(nome_figura,nome_arquivo,caminho)

arquivo = uigetfile({'*.dat'},'Selecionar arquivo dat',caminho)
fid = fopen([caminho '\' arquivo],'r');
dado=textscan(fid, repmat('%f ',[1 25]));

aux_data=[dado{1,3},dado{1,1},dado{1,2},dado{1,4},dado{1,5},dado{1,6}];
data=datenum(double(aux_data));

media=[];
corte_in=input('Cortar ... dados no início: ');
corte_fin=input('Cortar ... dados no final: ');
tempo=data(1+corte_in:end-corte_fin);
for a=1:size(dado{1,13},1)
    vetor=[dado{1,12}(a,1);dado{1,13}(a,1);dado{1,14}(a,1)];
    media(a,1)=nanmean(vetor)*0.43;
end

f=figure(1);
plot(tempo,media(1+corte_in:end-corte_fin))
xlim([tempo(1,1)-1 tempo(end,1)+1]);
data_ini=floor(data(1,1));
data_fim=ceil(data(end,1));
aux_data=data_ini:data_fim;
xtickss=aux_data(1:10:end);
ylim([0 100]);
set(gca,'XTick',xtickss);
datetick('x','dd/mm','keepticks','keeplimits')
grid on
set(gca,'fontsize',8);
ylabel('Amplitude (dB)','fontsize',10)
title(['Signal-to-Noise Ratio (SNR) em ' nome_figura],'FontSize',14);
print('-dpng',[caminho '\SNR_' nome_arquivo],'-r300')
close all
end