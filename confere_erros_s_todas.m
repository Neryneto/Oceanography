function [out_vel out_dir num_range num_rep num_spike num_gap num_sinc,...
    dados_excluidos dados_eliminados tempo u v]=confere_erros_amb(in_vel,...
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
out_vel(in_vel==0 & in_dir==0)=nan;
out_dir(in_vel==0 & in_dir==0)=nan;


%encontra valores fora do range do equipamento
num_range=numel(out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max));
out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max)=nan;
out_dir(out_vel<=cor_range_min | out_vel>=cor_range_max)=nan;

%encontra valores fora da faixa ambiental
fundo=out_vel(:,1:5);
meio=out_vel(:,6:10);
superficie=out_vel(:,11:15);
subsuperficie=out_vel(:,16:18);

num_ambFundo=numel(find(fundo>0.45));
num_ambMeio=numel(find(meio>0.45));
num_ambSuperficie=numel(find(superficie>0.5));
num_ambSubsuperficie=numel(find(subsuperficie>0.6));
num_amb=num_ambFundo+num_ambMeio+num_ambSuperficie+num_ambSubsuperficie;

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

out_vel(intersect(zero_linha_u,zero_linha_v)+1,1)=nan;
out_dir(intersect(zero_linha_u,zero_linha_v)+1,1)=nan;

%encontra erros de sincronismo do relógio
% vetor=datevec(tempo);
dif_time=diff(tempo);
moda=mode(dif_time);
[l,c]=find((round(abs(dif_time*10^8)) ~= round(moda*10^8)));
num_sinc=round(numel(l)/2);
out_vel(l(2:2:end),c)=nan;
out_dir(l(2:2:end),c)=nan;        


%encontra os spikes - verificar a metodologia
auxmedia_v=nanmmcentral(out_vel,1.5/2);
diff_mm=diff(auxmedia_v);
desvpad_vel=nanstd(diff_mm);

[l_spike c_spike]=find(abs(diff_mm)>=4*abs(desvpad_vel));

% auxmedia_v=nanmmcentral(out_vel,1.5/2);
% desvpad_vel=nanstd(out_vel);
% 
% [l_spike c_spike]=find(auxmedia_v>=4*desvpad_vel);

num_spike=numel(l_spike);
try out_vel(l_spike-1,c_spike)=nan;
out_dir(l_spike-1,c_spike)=nan;    
catch 'Subscript indices must either be real positive integers or logicals.'
    out_vel(l_spike,c_spike)=nan;
    out_dir(l_spike,c_spike)=nan;
end

num_spike=0;
clear lixo lixo_2

dados_eliminados=num_range+num_gap+num_rep+num_sinc+num_spike;
end







    