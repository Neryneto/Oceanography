function [elementos]=le_plota_pitch_roll_aqd(nome_figura,nome_arquivo,caminho,corte_in,corte_fin)

%lê arquivo. Deve estar codificado como ANSI
arquivo = uigetfile({'*.dat'},'Selecionar arquivo .dat',caminho)
% fid = fopen([caminho '\' arquivo],'r','n','Unicode');
[fid, errormsg] = fopen([caminho '\' arquivo],'r');
leitor=[repmat('%f ',[1 19]) '%*[^\n]']; 
arq_txt=textscan(fid, leitor);
% [arq_txt]=fread(fid, '*char','%s %d %s %s %f');

% arquivo = uigetfile({'*.dat'},'Selecionar arquivo de velocidade de corrente',caminho)
% [fid, errormsg] = fopen([caminho '\' arquivo],'r+');
% arq_txt=textscan(fid, '%*s %d %d %s %s %f');
% fclose(fid);

%%
%organiza vetores
aux_data=[arq_txt{1,3},arq_txt{1,1},arq_txt{1,2},arq_txt{1,4},arq_txt{1,5},arq_txt{1,6}];
data=datenum(double(aux_data));

%encontra inclinação alta antes de cortar dados iniciais e finais
pitch=arq_txt{1,18};
roll=arq_txt{1,19};
elementos=find(pitch>30 | roll>30 | pitch<-30 | roll<-30);

data=data(1+corte_in:end-corte_fin);
%%
a=figure(1);

subplot(2,1,1)
plot(data,arq_txt{1,18}(1+corte_in:end-corte_fin),'b')
hold on
plot(data,arq_txt{1,19}(1+corte_in:end-corte_fin),'r')
xlim([data(1,1) data(end,1)]);
plot(data,repmat(-30,length(data),1),'--k');
plot(data,repmat(30,length(data),1),'--k');

ylim([-40 40])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Inclinação (°)')
title(['Inclinação do equipamento em ' nome_figura],'FontSize',14);
legend({'Pitch','Roll','Limite de inclinação - correntes'},'Location','SouthWest','FontSize',8)
grid on
print('-dpng',[caminho '\PitchRoll_' nome_arquivo '.png']);
close
end