function [temp_out tempo num_range_temp num_gap_temp num_sinc dados_excluidos,...
dados_eliminados_temp percent_good_temp]=confere_erros_temperatura(temp_in,...
time,corte_in,corte_fin)

% Identifica erros na matriz como a confere_erros_pressao, porém
% desconsiderando erros de valores repetidos
%%
%Valores a serem estabelecidos em reunião

%Range do equipamento -5 a +5 m/s
dados_excluidos=corte_in+corte_fin;
tempo=time(corte_in+1:size(time,1)-corte_fin,1);

temp_in=temp_in(corte_in+1:size(temp_in,1)-corte_fin,1);

temp_min=-4;temp_max=40;
temp_out=temp_in;
%%
%encontra os gaps 
num_gap_temp=sum(isnan(temp_in));

%encontra valores fora do range do equipamento
num_range_temp=sum(temp_in<=temp_min | temp_in>=temp_max);

temp_out(temp_in<temp_min | temp_in>temp_max)=nan;


%encontra erros de sincronismo do relógio
% vetor=datevec(tempo);
dif_time=diff(tempo);
moda=mode(dif_time);
[l,c]=find((round(abs(dif_time*10^8)) ~= round(moda*10^8)));
tabela_sinc=repmat(numel(temp_in)/2,size(temp_in,2),1);
num_sinc=round(numel(l)/2);
temp_out(l(2:2:end),1)=nan; 
tempo(l(2:2:end),1)=nan;

dados_eliminados_temp=num_range_temp+num_gap_temp+num_sinc;
percent_good_temp=(numel(temp_in)-dados_eliminados_temp)*100/numel(temp_in);
matriz_out=[tempo temp_out];
end







    