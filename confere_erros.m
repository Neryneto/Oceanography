function [out_vel out_dir tabela_range num_range tabela_rep num_rep,...
    tabela_spike num_spike tabela_gap num_gap tabela_sinc num_sinc,...
    dados_excluidos dados_eliminados tempo u v]=confere_erros(in_vel,...
    in_dir,corte_in,corte_fin,time)

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

in_vel=in_vel(corte_in+1:end-corte_fin,:);out_vel=in_vel;
in_dir=in_dir(corte_in+1:end-corte_fin,:);out_dir=in_dir;
tempo=time(corte_in+1:end-corte_fin,1);

cor_range_min=-5; cor_range_max=5;
wave_range_min=-15; wave_range_max=15;

%precisa estabelecer também a metodologia de detecção de spikes
%%
%encontra os gaps 
num_gap=sum(isnan(in_vel));
tabela_gap=find(isnan(in_vel));
out_vel(in_vel==0 & in_dir==0)=nan;
out_dir(in_vel==0 & in_dir==0)=nan;

%encontra valores fora do range do equipamento
num_range=numel(out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max));
tabela_range=find(out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max));

out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max)=nan;
out_dir(out_vel<=cor_range_min | out_vel>=cor_range_max)=nan;

%encontra valores fora da faixa ambiental
% [amb_max_l amb_max_c]=find(in_vel>=4 & in_vel<5);
% [amb_min_l amb_min_c]=find(in_vel<=-4 & in_vel>-5);
% num_ambient=numel(amb_max_l)+numel(amb_min_l);
% 
% for i=1:size(in_vel,2)
%     tabela_amb_min(1,i)=numel(find(amb_min_c==i));
%     tabela_amb_max(1,i)=numel(find(amb_max_c==i));
% end
% tabela_amb=tabela_amb_min+tabela_amb_max;
% 
% out_vel(amb_max_l,amb_max_c)=nan;
% out_vel(amb_min_l,amb_min_c)=nan;
% out_dir(amb_max_l,amb_max_c)=nan;
% out_dir(amb_min_l,amb_min_c)=nan;

%encontra valores repetidos
[u v]=veldir2uv(in_vel,in_dir);
[zero_linha_u zero_coluna_u]=find(diff(u)==0);
[zero_linha_v zero_coluna_v]=find(diff(v)==0);
  
num_rep=numel(intersect(zero_linha_u,zero_linha_v));

for i=1:size(in_vel,2)
    tabela_rep(1,i)=numel(find(zero_coluna_u==i));
end

out_vel(intersect(zero_linha_u,zero_linha_v)+1,1)=nan;
out_dir(intersect(zero_linha_u,zero_linha_v)+1,1)=nan;

%encontra erros de sincronismo do relógio
% vetor=datevec(tempo);
dif_time=diff(tempo);
moda=mode(dif_time);
[l,c]=find((round(abs(dif_time*10^8)) ~= round(moda*10^8)));
tabela_sinc=repmat(numel(l)/2,size(u,2),1);
num_sinc=round(numel(l)/2);
out_vel(l(2:2:end),c)=nan;
out_dir(l(2:2:end),c)=nan;        


%encontra os spikes - verificar a metodologia
auxmedia_v=nanmmcentral(out_vel,1.5/2);
desvpad_vel=nanstd(out_vel);

[l_spike c_spike]=find(auxmedia_v>=4*desvpad_vel);
tabela_spike=l_spike;

num_spike=numel(l_spike);
clear lixo lixo_2

dados_eliminados=num_range+num_gap+num_rep+num_sinc+num_spike;
end







    