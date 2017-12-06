function [out_vel out_dir num_range num_rep num_spike num_gap num_sinc num_amb,...
    num_inc dados_excluidos dados_eliminados tempo u v]=confere_erros_Cor(in_vel,...
    in_dir,corte_in,corte_fin,time,caminho,eleCor,nome_est)
% Identifica erros na matriz, sendo:

% out a matriz já com NaNs
% num_range o número de dados fora do range do equipamento
% num_ambient o número de dados fora da faixa ambiental
% num_rep o número de dados repetidos
% num_spike o número de spikes
% num_gap o número de dados não coletados
% num_sinc o número de dados fora do relógio

%%
% exclui valores de inclinação
dados_excluidos=corte_in+corte_fin;
in_vel=in_vel(corte_in+1:end-corte_fin,:);out_vel=in_vel;
in_dir=in_dir(corte_in+1:end-corte_fin,:);out_dir=in_dir;
tempo=time(corte_in+1:end-corte_fin,1);
count=[];
for i=1:length(eleCor)
    if eleCor(i)-corte_in>=1 && eleCor(i)<length(tempo)
out_vel(eleCor-corte_in,:)=nan;out_dir(eleCor-corte_in,:)=nan;
count=count+1;
    end
end
num_inc=numel(count);

%Range do equipamento -5 a +5 m/s
cor_range_min=-5; cor_range_max=5;
wave_range_min=-15; wave_range_max=15;

%%
%encontra os gaps 
[lg cg]=find(isnan(in_vel));
num_gap=sum(isnan(in_vel))-numel(intersect(lg,eleCor-corte_in));
out_vel(in_vel==0 & in_dir==0)=nan;
out_dir(in_vel==0 & in_dir==0)=nan;

%encontra valores fora do range do equipamento
num_range=numel(out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max));
out_vel(out_vel<=cor_range_min | out_vel>=cor_range_max)=nan;
out_dir(out_vel<=cor_range_min | out_vel>=cor_range_max)=nan;

%encontra valores fora da faixa ambiental
switch nome_est
    case 'BDR'
        corte_vel=0.5;
    case 'CAB'
        corte_vel=1;
    case 'GUA1'
        corte_vel=0.6;
    case 'GUA2'
        corte_vel=0.6;
    case 'GUA3'
        corte_vel=0.6;
    case 'JAC'
        corte_vel=1.5;
    case 'SER1'
        corte_vel=1;
    case 'SER2'
        corte_vel=1;
    case 'SER3'
        corte_vel=1;
    case 'SER4'
        corte_vel=2;
end
[fxAmb aux]=find(in_vel>corte_vel);
num_amb=length(fxAmb);
out_vel(out_vel>corte_vel)=nan;

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

% num_spike=0;
clear lixo lixo_2

dados_eliminados=num_range+num_gap+num_rep+num_sinc+num_spike+num_inc+num_amb;
end







    