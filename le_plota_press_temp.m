function le_plota_press_temp (nome_figura,nome_arquivo,caminho)

%lê arquivo. Deve estar codificado como ANSI
arquivo = uigetfile({'*.dat'},'Selecionar arquivo de pressão e temperatura',caminho)
% fid = fopen([caminho '\' arquivo],'r','n','Unicode');
fid = fopen([caminho '\' arquivo],'r');
[arq_txt]=textscan(fid, '%s %d %s %s %f');
% [arq_txt]=fread(fid, '*char','%s %d %s %s %f');

%%
%organiza vetores
num_dados=max(arq_txt{1,2});
formatIn='mm/dd/yyyy';
dia=datevec(arq_txt{1,3},formatIn);

formatIn2='HH:MM';
hora=datevec(arq_txt{1,4},formatIn2);

time=datenum([dia(:,1:3) hora(:,4:6)]);
tempo(:,1)=time(1:num_dados);

parametros={'Pressao','Temperatura'};
parametros_valores=reshape(arq_txt{1,5},num_dados,length(parametros));
for ind = 1:length(parametros)
  PT.(parametros{ind}) = parametros_valores(:,ind);
end
clearvars -except PT tempo caminho nome_figura nome_arquivo
%%
% salva variáveis brutas
save ([caminho '\Dados_Brutos_PressTemp_' nome_arquivo],'PT','tempo')

%%
%confere erros
corte_in_p=input('Cortar ... dados no início (pressão): ');
corte_fin_p=input('Cortar ... dados no final (pressão): ');

% corte_in_t=input('Cortar ... dados no início (temperatura): ');
% corte_fin_t=input('Cortar ... dados no final (temperatura): ');

[press_out num_range_press num_gap_press num_rep_press num_sinc dados_excluidos_press,...
    dados_eliminados_press tempo_press percent_good_press]=confere_erros_pressao(PT.Pressao,...
tempo,corte_in_p,corte_fin_p);

[temp_out tempo_out num_range_temp num_gap_temp num_sinc dados_excluidos dados_eliminados_temp,...
    percent_good_temp]=confere_erros_temperatura(PT.Temperatura,tempo,corte_in_p,corte_fin_p);
%%
% salva variáveis tratadas
diretorio=uigetdir(caminho,'Selecionar pasta para exportar');
save ([diretorio '\Dados_Processados_PressTemp_' nome_arquivo],'press_out','temp_out','tempo_out')
gravar_excel_temppress(nome_arquivo,tempo_press,press_out,temp_out,diretorio)

%%
PT.Pressao=press_out;
PT.Temperatura=temp_out;
tempo=tempo_press;

a=figure(1);

subplot(2,1,1)
plot(tempo(1:2:end),PT.Pressao(1:2:end),'b')

xlim([tempo(1,1)-1 tempo(end,1)+1]);
% ylim([22.2 24.1])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel({'Altura da coluna d''água (m)';'acima do sensor'})
title(['Profundidade em ' nome_figura],'FontSize',14);
grid on

subplot(2,1,2)
plot(tempo,PT.Temperatura,'r')

xlim([tempo(1,1)-1 tempo(end,1)+1]);
% ylim([21.6 22.4])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('ºC')
title(['Temperatura da água em ' nome_figura],'FontSize',14);
grid on

print('-dpng',[diretorio '\PressTemp_' nome_arquivo '.png']);
close
end