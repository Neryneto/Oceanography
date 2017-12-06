function le_plota_SNR_ondas(caminho,nome_figura,nome_arquivo,corte_in,corte_fin)

arquivo = uigetfile({'*.wap'},'Selecionar arquivo wap',caminho);
fid = fopen([caminho '\' arquivo],'r');
aux_onda=[(repmat('%d ',[1 6])) '%*[^\n]'];
wap=textscan(fid, aux_onda);

aux_data_onda=[wap{1,3},wap{1,1},wap{1,2},wap{1,4},wap{1,5},wap{1,6}];
data_onda=datenum(double(aux_data_onda));

%%
%plota parâmetro SNR ondas
folder_name = uigetdir(caminho);
wad={};
for i=0:1320
    if i>=0 &&  i<=9
campo = fopen([folder_name '\GMR1070200' num2str(i) '.wad'],'r');
leitura=[repmat('%*d ',[1 5]) '%d ' repmat('%*d ',[1 7])];
wad(i+1,1)=textscan(campo, leitura);
fclose('all')
    elseif i>=10 && i<=99
campo = fopen([folder_name '\GMR107020' num2str(i) '.wad'],'r');
leitura=[repmat('%*d ',[1 5]) '%d ' repmat('%*d ',[1 7])];
wad(i+1,1)=textscan(campo, leitura);
fclose('all')
    else
campo = fopen([folder_name '\GMR10702' num2str(i) '.wad'],'r');
leitura=[repmat('%*d ',[1 5]) '%d ' repmat('%*d ',[1 7])];
wad(i+1,1)=textscan(campo, leitura);
fclose('all')
    end
end

clear i

for i=1:size(wad,1)
    wad_aux(i,1)=nanmean(wad{i,1}*.43);
end

G=figure(2);
plot(data_onda(corte_in+3:end-corte_fin),wad_aux(corte_in+2:end-corte_fin));

xlim([data_onda(1+corte_in,1)-1 data_onda(end-corte_fin,1)+1]);
data_ini=floor(data_onda(1,1));
data_fim=ceil(data_onda(end,1));
aux_data=data_ini:data_fim;
xtickss=aux_data(1:5:end);
set(gca,'XTick',xtickss);
datetick('x','dd/mm','keepticks','keeplimits')
set(gca,'fontsize',8);
ylabel('Amplitude (dB)','fontsize',10)
xlabel('Data','fontsize',10)
ylim([0 100])
grid on
title(['Signal-to-Noise Ratio (SNR) do sensor AST em ' nome_figura],'FontSize',14);
print('-dpng',[caminho '\SNR_onda_' nome_arquivo],'-r300')
close(G)
end