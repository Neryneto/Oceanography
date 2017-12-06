function [press_out temp_out num_range_press num_range_temp,...
    num_gap_press num_gap_temp num_sinc, dados_excluidos,...
    dados_eliminados_press dados_eliminados_temp,...
percent_good_press percent_good_temp]=confere_erros_PT(press_in,...
temp_in,time,corte_in_p,corte_fin_p,corte_in_t,corte_fin_t)

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
temp_in=temp_in(corte_in+1:size(temp_in,1)-corte_fin,1);

temp_min=-4;temp_max=40;
press_min=0;press_max=100;

%%
matriz_out=[press_in temp_in];

%encontra os gaps 
num_gap_press=sum(isnan(press_in));
num_gap_temp=sum(isnan(temp_in));

%encontra valores fora do range do equipamento
num_range_press=sum(press_in<press_min | press_in>press_max);
num_range_temp=sum(temp_in<temp_min | temp_in>temp_max);

matriz_out(press_in<press_min | press_in>press_max)=nan;
matriz_out(temp_in<temp_min | temp_in>temp_max)=nan;

%encontra valores repetidos
% [zero_linha_t zero_coluna_t]=find(diff(temp_in)==0);
% [zero_linha_p zero_coluna_p]=find(diff(press_in)==0);
%   
% press_out(diff(press_in)==0)=nan;
% temp_out(diff(temp_in)==0)=nan;

%encontra erros de sincronismo do relógio
% vetor=datevec(tempo);
dif_time=diff(tempo);
moda=mode(dif_time);
[l,c]=find((round(abs(dif_time*10^8)) ~= round(moda*10^8)));
tabela_sinc=repmat(numel(press_in)/2,size(press_in,2),1);
num_sinc=round(numel(l)/2);
press_out(l(2:2:end),c)=nan;
temp_out(l(2:2:end),c)=nan;        

dados_eliminados_press=num_range_press+num_gap_press+num_sinc;
dados_eliminados_temp=num_range_temp+num_gap_temp+num_sinc;
percent_good_press=(numel(press_in)-dados_eliminados_press)*100/numel(press_in);
percent_good_temp=(numel(temp_in)-dados_eliminados_temp)*100/numel(temp_in);
end







    