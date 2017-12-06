function [press_out num_range_press num_gap_press num_rep_press num_sinc,...
    dados_excluidos dados_eliminados_press tempo percent_good_press]=confere_erros_pressao(press_in,...
time,corte_in,corte_fin)

% Identifica erros na matriz, sendo:

% out a matriz já com NaNs
% num_range o número de dados fora do range do equipamento
% num_ambient o número de dados fora da faixa ambiental
% num_rep o número de dados repetidos
% num_spike o número de spikes
% num_gap o número de dados não coletados
% num_sinc o número de dados fora do relógio

%%
%Valores a serem estabelecidos em reunião

%Range do equipamento -5 a +5 m/s
dados_excluidos=corte_in+corte_fin;
tempo=time(corte_in+1:size(time,1)-corte_fin,1);

press_in=press_in(corte_in+1:size(press_in,1)-corte_fin,1);

press_min=0;press_max=100;
press_out=press_in;
%%
%encontra os gaps 
num_gap_press=sum(isnan(press_in));

%encontra valores fora do range do equipamento
num_range_press=sum(press_in<press_min | press_in>=press_max);

press_out(press_in<press_min | press_in>press_max)=nan;

%encontra valores repetidos
[zero_linha_p zero_coluna_p]=find(diff(press_in)==0);
press_out(diff(press_in)==0)=nan;
num_rep_press=numel(zero_linha_p);

%encontra erros de sincronismo do relógio
% vetor=datevec(tempo);
dif_time=diff(tempo);
moda=mode(dif_time);
[l,c]=find((round(abs(dif_time*10^8)) ~= round(moda*10^8)));
tabela_sinc=repmat(numel(press_in)/2,size(press_in,2),1);
num_sinc=round(numel(l)/2);
press_in(l(2:2:end),1)=nan;
tempo(l(2:2:end),1)=nan;

dados_eliminados_press=num_range_press+num_gap_press+num_rep_press+num_sinc;
percent_good_press=(numel(press_in)-dados_eliminados_press)*100/numel(press_in);
matriz_out=[tempo press_out];
end







    