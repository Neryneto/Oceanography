function [elementosOnda elementosCorrente]=le_plota_pitch_roll(nome_figura,nome_arquivo,caminho,c_i,c_f)

%lê arquivo. Deve estar codificado como ANSI
arquivo = uigetfile({'*.whd'},'Selecionar arquivo .whd',caminho)
% fid = fopen([caminho '\' arquivo],'r','n','Unicode');
[fid, errormsg] = fopen([caminho '\' arquivo],'r');
leitor=[repmat('%f ',[1 14]) '%*[^\n]']; 
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

%%

pitch=arq_txt{1,13};
roll=arq_txt{1,14};
elementosCorrente=find(pitch>30 | roll>30 | pitch<-30 | roll<-30);
elementosOnda=find(pitch>10.5 & pitch<=30 | roll>10.5 & roll<30 | pitch<-10.5 & pitch>=-30 | roll<-10.5 & roll>-30);

data=data(1+c_i:end-c_f);
arq_txt{1,13}=arq_txt{1,13}(1+c_i:end-c_f);
arq_txt{1,14}=arq_txt{1,14}(1+c_i:end-c_f);

a=figure(1);
subplot(2,1,1)
plot(data,arq_txt{1,13},'b')
hold on
plot(data,arq_txt{1,14},'r')
xlim([data(1) data(end,1)]);

plot(data,repmat(-10,length(data),1),'--k');
plot(data,repmat(-30,length(data),1),'-k');

plot(data,repmat(10,length(data),1),'--k');
plot(data,repmat(30,length(data),1),'-k');
ylim([-40 40])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Inclinação (°)')
title(['Inclinação do equipamento em ' nome_figura],'FontSize',14);
hh=legend('Pitch','Roll','Limite de inclinação para ondas', 'Limite de inclinação para correntes','Location','SouthEast');
set(hh,'FontSize',6)
grid on
print('-dpng',[caminho '\PitchRoll_' nome_arquivo '.png']);
close
end