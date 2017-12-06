function [matriz_out num_rep num_gap num_sinc count num_amb_T num_amb_Dir num_amb_H,...
    dados_excluidos dados_eliminados percent_good tempo]=confere_erros_ondas(matriz_in,...
time,corte_in,corte_fin,eO,nome_est)
% Identifica erros na matriz, sendo:

% out a matriz já com NaNs
% num_range o número de dados fora do range do equipamento
% num_ambient o número de dados fora da faixa ambiental
% num_rep o número de dados repetidos
% num_spike o número de spikes
% num_gap o número de dados não coletados
% num_sinc o número de dados fora do relógio

%%
dados_excluidos=corte_in+corte_fin;
matriz_out=matriz_in(corte_in+1:end-corte_fin,:);
tempo=time(corte_in+1:size(matriz_in,1)-corte_fin,1);
%%
%encontra os gaps 
aux_gap=isnan(matriz_out);
[l_g c_g]=find(isnan(matriz_out));
errosGap=unique(l_g);
matriz_out(l_g,:)=nan;
%elimina tilt elevado
count=0;
for i=1:length(eO)
    if eO(i)<length(matriz_out)
matriz_out(eO-corte_in,:)=nan;
count=count+1;
    end
end

num_gap=numel(setdiff(l_g,eO));
switch nome_est
    case 'BDR'
        alturaC=1.5;
        periodoC=10;
        direcaoM=150;
        direcaom=10;
    case 'CAB'
        alturaC=6;
        periodoC=14;
        direcaoM=185;
        direcaom=75;
    case 'GUA1'
        alturaC=3.5;
        periodoC=8;
        direcaoM=130;
        direcaom=0;
    case 'JAC'
        alturaC=10;
        periodoC=12;
        direcaoM=230;
        direcaom=90;
end

%encontra erros ambientais de altura Hmax
altura=matriz_out(:,3);
[alturaAmb alturaAmbAux]=find(altura>alturaC);
num_amb_H=numel(alturaAmb);
altura(altura>alturaC)=nan;
matriz_out(:,3)=altura;
matriz_out(alturaAmb,:)=nan;

% num_amb_H=0;
%encontra erros ambientais de período Tp
% periodoPico=matriz_out(:,6);
% [periodoPicoAmb periodoPicoAmbAux]=find(periodoPico>20);
% num_amb_Tp=numel(periodoPicoAmb);
% periodoPico(periodoPico>20)=nan;
% matriz_out(:,6)=periodoPico;
% matriz_out(periodoPicoAmb,:)=nan;

%encontra erros ambientais de período Tm02
periodo=matriz_out(:,5);
[periodoAmb periodoAmbAux]=find(periodo>periodoC);
num_amb_T=numel(periodoAmb);
periodo(periodo>periodoC)=nan;
matriz_out(:,5)=periodo;
matriz_out(periodoAmb,:)=nan;

%encontra erros ambientais de direção MeanDir
direcao=matriz_out(:,8);
num_amb_dir_max=numel(find(direcao>direcaoM));
num_amb_dir_min=numel(find(direcao<direcaom));
num_amb_Dir=num_amb_dir_max+num_amb_dir_min;
direcao(direcao>direcaoM | direcao<direcaom)=nan;
matriz_out(:,8)=direcao;
[aux1 aux2]=find(isnan(direcao))
matriz_out(aux1,:)=nan;

%encontra valores repetidos
diferenca=diff(matriz_out);
tol = eps(0.5);
[l c]=find(abs(sum(diferenca,2)-0) < tol)
num_rep=numel(l);
matriz_out(l,:)=nan;

%encontra erros de sincronismo do relógio
% vetor=datevec(tempo);
dif_time=diff(tempo);
moda=mode(dif_time);
[l_s,c_s]=find((round(abs(dif_time*10^8)) ~= round(moda*10^8)));
tabela_sinc=repmat(numel(l_s)/2,size(matriz_in,1),1);
num_sinc=round(numel(l_s)/2);
matriz_out(l_s(2:2:end),:)=nan;

%encontra os spikes - verificar a metodologia
% auxmedia_v=nanmmcentral(out_vel,1.5/2);
% desvpad_vel=nanstd(out_vel);
% 
% [l_spike c_spike]=find(auxmedia_v>=4*desvpad_vel);
% 
% num_spike=numel(l_spike);
% clear lixo lixo_2

dados_eliminados=num_gap+num_rep+num_sinc+count;
percent_good=(size(matriz_in,1)-dados_eliminados)*100/size(matriz_in,1);
end







    