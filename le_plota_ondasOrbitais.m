function le_plota_ondas(nome_figura,nome_arquivo,caminho,c_i,c_f)
%lê arquivo através da rotina readAWACWaveAscii.m
% [elementosOnda elementosCorrente]=le_plota_pitch_roll(nome_figura,nome_arquivo,caminho,c_i,c_f)

arquivo = uigetfile({'*.dat'},'Selecionar arquivo de ondas',caminho)
fid = fopen([caminho '\' arquivo],'r');
[arq_txt]=textscan(fid, '%s %d %s %s %f');

%identifica os parâmetros
num_dados=max(arq_txt{1,2});
formatIn='m/dd/yyyy';
ondadia=datevec(arq_txt{1,3},formatIn);

formatIn2='HH:MM';
ondahora=datevec(arq_txt{1,4},formatIn2);

time=datenum([ondadia(:,1:3) ondahora(:,4:6)]);
tempo(:,1)=time(1:num_dados);

parametros={'Hm0','H10','Hmax','Tp','Tm02','DirTp','SprTp','MeanDir'};
parametros_valores=reshape(arq_txt{1,5},num_dados,length(parametros));
for ind = 1:length(parametros)
  onda.(parametros{ind}) = parametros_valores(:,ind);
end
clearvars -except onda tempo parametros_valores nome_figura nome_arquivo caminho elementosOnda c_i c_f

decl=input ('Inserir declinação magnética em graus decimais: ');
%%
%salva variáveis brutas
save ([caminho '\Dados_Brutos_Ondas_' nome_arquivo '.mat'],'onda','tempo')

%%
%confere erros
parametros_valores(:,6)=parametros_valores(:,6)+decl;
parametros_valores(:,8)=parametros_valores(:,8)+decl;
dados_excluidos=c_i+c_f;

for i=1:length(parametros_valores(:,6))
    if(parametros_valores(i,6)<0) parametros_valores(i,6)=parametros_valores(i,6)+360;
    end
    if(parametros_valores(i,8)<0) parametros_valores(i,8)=parametros_valores(i,8)+360;
    end
end

[elementosOnda]=le_pitch_rollWav(caminho);num_inc=length(elementosOnda);
parametros_valores(elementosOnda,:)=nan;
global nome_est
gui_escolha_estacao
pause
[matriz_out num_rep num_gap num_sinc num_tilt T_amb Dir_amb H_amb,...
   dados_excluidos dados_eliminados percent_good tempo_out]=confere_erros_ondasOrbitais(parametros_valores,...
tempo,c_i,c_f,elementosOnda,nome_est);
diretorio=uigetdir(caminho,'Selecionar pasta para salvar documentos');
num_amb=T_amb+Dir_amb+H_amb;

gravar_excel_ondaOrbitais(nome_arquivo,tempo_out,matriz_out,diretorio,num_rep,...
    num_gap,num_sinc,num_amb,num_tilt,dados_excluidos,percent_good)

%%
%salva variáveis tratadas
save ([caminho '\Dados_Processados_Ondas_' nome_arquivo '.mat'],'matriz_out','tempo_out')
%%

% le_plota_SNR_ondas(caminho,local,nome,corte_in,corte_fin)
% Plota parâmetros de onda
a=figure(1);

subplot(2,1,1)
plot(tempo_out,matriz_out(:,1),'b')
hold on
plot(tempo_out,matriz_out(:,2),'g')
plot(tempo_out,matriz_out(:,3),'r')

xlim([tempo_out(1,1)-1 tempo_out(end,1)+1]);
ylim([0 7])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Altura (m)')
title(['Altura de onda em ' nome_figura],'FontSize',14);
grid on
% gridLegend({'Hm0','H10','Hmax'},3,'location','northoutside')
% columnlegend(3, ,'Location', 'NorthEast', 'boxon')
legend({'Hm0','H10','Hmax'},'Orientation', 'horizontal','Location','NorthWest','FontSize',6)

% diretorio=[caminho(1:end-19) '\7-Dados processados'];
print(a,'-dpng',[diretorio '\Altura_ondas_' nome_arquivo],'-r300')
close(a)

%%
% % Dados de período
b=figure(2);
subplot(2,1,1)

plot(tempo_out,matriz_out(:,4),'b')
hold on
plot(tempo_out,matriz_out(:,5),'g')

xlim([tempo_out(1,1)-1 tempo_out(end,1)+1]);
% ylim([0 30])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Período (s)')

grid on
legend({'Tp','Tm02'},'Orientation', 'horizontal','Location','NorthWest','FontSize',6,'boxoff')

title(['Período de onda em ' nome_figura],'FontSize',14);
print(b,'-dpng',[diretorio '\Periodo_ondas_' nome_arquivo],'-r300')
close(b)

%%
% Dados direcionais
c=figure(3)
subplot(2,1,1)

plot(tempo_out,matriz_out(:,6),'b')
hold on
plot(tempo_out,matriz_out(:,7),'g')
plot(tempo_out,matriz_out(:,8),'r')

xlim([tempo_out(1,1)-1 tempo_out(end,1)+1]);
datetick('x','dd/mm','keepticks','keeplimits')
ylim([0 360])
ylabel('Direção (º)')

grid on
hh=legend({'DirTp','SprTp','MeanDir'},'Orientation', 'horizontal','Location','NorthWest','FontSize',6);
title(['Direção de onda em ' nome_figura],'FontSize',14);
print('-dpng',[diretorio '\Direcao_ondas_' nome_arquivo],'-r300')
close(c)

%%
% rosa de ondas
d=figure(4);
wind_rose(anglextocompass(matriz_out(:,8)),matriz_out(:,1),'n',16,'lablegend',...
    'Hm0 (m)','quad',2,'labtitle',['Rosa de ondas em ' nome_figura],...
    'di',[0.5:0.25:3.5], 'ci',[10:10:40]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[diretorio '\Rosa_ondas_' nome_arquivo],'-r300')
close(d)

%%
% espectro direcional
% diretorio=caminho;
% [WAPdata] = getwap(diretorio,'\JAC03.wap')
% [freq, Spec, SpecNorm, Speclog] = getWAS(WAPdata,.02,caminho,1)
plota_espectro_onda(nome_figura,[nome_arquivo '_1'],caminho,tempo_out,c_i,c_f)

end