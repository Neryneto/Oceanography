%Rotina criada por Nery Neto em 11/05 para ler arquivos de corrente do AWAC
%output: vetor time e vetores vel_cel dir_cel

function le_plota_correntes(nome,caminho,local,num_cel,corte_in,corte_fin)
%plota parâmetros de qualidade
% [elementosOnda elementosCorrente]=le_plota_pitch_roll(local,nome,caminho,corte_in,corte_fin)

arquivo = uigetfile({'*.dat'},'Selecionar arquivo de velocidade de corrente',caminho)
[fid, errormsg] = fopen([caminho '\' arquivo],'r+');
arq_txt=textscan(fid, '%*s %d %d %s %s %f');
fclose(fid);

%Separa os dados de acordo com as células
num_cell=max(arq_txt{1,1});
num_dados=size(arq_txt{1,5},1)/num_cell;
vel_cel=reshape(arq_txt{1,5},size(arq_txt{1,5},1)/num_cell,num_cell);

%cria o vetor time
formatIn='m/dd/yyyy';
veldia=datevec(arq_txt{1,3},formatIn);

formatIn2='HH:MM';
velhora=datevec(arq_txt{1,4},formatIn2);

time=datenum([veldia(:,1:3) velhora(:,4:6)]);
tempo(:,1)=time(1:num_dados);

% clearvars -except num_cell vel_cel tempo local caminho nome corte_in corte_fin

%para direção
%Lê o arquivo e cria a estrutura de array
arquivo_dir=uigetfile({'*.dat'},'Selecionar arquivo de direção de corrente',caminho);
% fid_dir = fopen([caminho '\' arquivo_dir],'r','n','UTF-8');
fid_dir = fopen([caminho '\' arquivo_dir],'r');
var_dir=textscan(fid_dir, '%*s %d %d %s %s %f');

%Separa os dados de acordo com as células
dir_cel=reshape(var_dir{1,5},size(var_dir{1,5},1)/num_cell,num_cell);

%corrige declinação magnética
decl=input('Inserir valor da declinação magnética: ');
dir_cel=dir_cel+decl;

for i=1:size(dir_cel,1)
    for j=1:size(dir_cel,2)
        if dir_cel(i,j)<0 dir_cel2(i,j)=dir_cel(i,j)+360;
        elseif dir_cel(i,j)>360 dir_cel2(i,j)=dir_cel(i,j)-360;
        else dir_cel2=dir_cel;
        end
    end
end

% clearvars -except vel_cel dir_cel tempo nome caminho decl num_cell corte_in corte_fin
%%
%salva dados brutos
save ([caminho '\Dados_Brutos_Corrente_' nome '.mat'],'vel_cel','dir_cel','tempo')
% save('path\myfile.mat');
% saveas (['Dados_Brutos_Corrente_',nome],'-mat','K:\PETROBRAS\15.038.411 (Shore Approach)\1-Oceanografia\6-Barra do Riacho(ES)_ADCP\1ªCampanha_Agosto_2015\5-Dados brutos')

%%
%confere erros
diretorio=uigetdir(caminho);

[elementosCorrente]=le_pitch_rollCor(caminho);num_inc=repmat(length(elementosCorrente),1,3);
% elementosCorrente(elementosCorrente<corte_in | elementosCorrente>length(time)-corte_fin)=[];
% elementosCorrente=elementosCorrente-corte_in;
vel_cel(elementosCorrente,:)=nan;dir_cel(elementosCorrente,:)=nan;
global nome_est
gui_escolha_estacao
pause

for i=1:num_cel
 [velocidade(:,i) direcao(:,i) num_range(i) num_rep(i) num_spike(i),...
    num_gap(i) num_sinc(i) num_amb(i) num_inc(i) dados_excluidos(i) dados_eliminados(i),...
    tempo_out u(:,i) v(:,i)]=confere_erros_s(vel_cel(:,i),...
    dir_cel(:,i),corte_in,corte_fin,tempo,caminho,elementosCorrente,nome_est);
end

%para todas as células juntas
%  [velocidade(:,i) direcao(:,i) num_range(i) num_rep(i) num_spike(i),...
%     num_gap(i) num_sinc(i) dados_excluidos(i) dados_eliminados(i),...
%     tempo_out u(:,i) v(:,i)]=confere_erros_s_todas(vel_cel(:,1:num_cell),...
%     dir_cel(:,1:num_cell),corte_in,corte_fin,tempo);

% velocidade2=velocidade(1:2:end,:);
% direcao2=direcao(1:2:end,:);
% tempo_out2=tempo_out(1:2:end);
% % %gradiente vertical
% grad_vert=velocidade2';
% diff_mm=diff(grad_vert);
% aux_media_grad_vert=nanmmcentral(diff_mm,1.5/2,1);
% desvpad_vel=nanstd(aux_media_grad_vert);
% auxiliar=zeros(size(aux_media_grad_vert,1),size(aux_media_grad_vert,2));
% for n=1:size(aux_media_grad_vert,2)
%     for m=1:num_cell-1
%         if abs(aux_media_grad_vert(m,n))>=3.*(abs(desvpad_vel(1,n)));
%             if velocidade2(n,m+1)>velocidade2(n,m)
%                 velocidade2(n,m+1)=888;
%             else velocidade2(n,m)=888;
%             end
%         end
%     end
% end
% 
% velocidade2(velocidade2==888)=nan;
% direcao2(isnan(velocidade2))=nan;
% 
% for i=1:2:2*length(velocidade2)
%     for j=1:size(velocidade2,2)
% velocidade3(i,j)=velocidade2((i+1)/2,j);
%     end
% end
% 
% for i=1:2:2*length(direcao2)
%     for j=1:size(direcao2,2)
% direcao3(i,j)=direcao2((i+1)/2,j);
%     end
% end
% velocidade=velocidade3;
% direcao=direcao3;
% 
% velocidade(2:2:end,:)=nan;
% direcao(2:2:end,:)=nan;

%%
% cria gráficos
prompt = {'Entre 1 para o norte para cima e 2 para norte para esquerda:'};
dlg_title = 'Definir o norte';
num_lines = 1;
def = {'1'};
norte = inputdlg(prompt,dlg_title,num_lines,def);
% velocidadeAux=velocidade(:,1:5);
% velocidadeAux(velocidadeAux>0.225)=nan;
% velocidade(:,1:5)=velocidadeAux;
% direcao(isnan(velocidade))=nan;

%estabelecendo margem para histogama de correntes
maximosHistograma=[];
for i=1:num_cel
xbin = [0:22.5:360];
ybin = [0:0.025:nanmax(nanmax(velocidade))];
[a,h] = binsort(direcao(:,i),velocidade(:,i),velocidade(:,i),xbin(:),ybin(:));
a2 = a(2:end,2:end);
h2 = h(2:end,2:end);
maximosHistograma=[maximosHistograma;nanmax(nanmax(h2))];
end
maximoHistograma=max(maximosHistograma);
for i=1:num_cel
% plota_correntes(velocidade(1:2:end,i),direcao(1:2:end,i),tempo_out(1:2:end,1),i,local,diretorio);

plota_correntes(velocidade(:,i),direcao(:,i),tempo_out,i,local,diretorio);
plota_DVP(velocidade(:,i),direcao(:,i),0,1,tempo_out,i,local,diretorio);
plota_histcurrents(velocidade(:,i),direcao(:,i),local,i,diretorio,nanmax(nanmax(velocidade)),maximoHistograma);
plota_rosa_corr(velocidade(:,i),direcao(:,i),local,diretorio,i,nanmax(nanmax(velocidade)));

%escolhendo entre 4 ou 5 stickplots
if numel(velocidade)/num_cel<720
plota_stickplot1(velocidade(:,i),direcao(:,i),tempo_out,1,local,i,diretorio,mode(diff(tempo_out)),...
nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)    
elseif numel(velocidade)/num_cel>2160 && numel(velocidade)/num_cel<=2880
plota_stickplot4(velocidade(:,i),direcao(:,i),tempo_out,1,local,i,diretorio,mode(diff(tempo_out)),...
nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)
elseif numel(velocidade)/num_cel>2880 && numel(velocidade)/num_cel<=3600
    plota_stickplot5(velocidade(:,i),direcao(:,i),tempo_out,1,local,i,diretorio,mode(diff(tempo_out)),...
        nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)
else
    plota_stickplot6(velocidade(:,i),direcao(:,i),tempo_out,1,local,i,diretorio,mode(diff(tempo_out)),...
        nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)
end
end

plota_perfil(velocidade,direcao,local,diretorio);
%%
%salva dados processados
save ([caminho '\Dados_Processados_Corrente_' nome '.mat'], 'velocidade','direcao','tempo_out')

%%
%salvar dados em Excel
tempo_out_ex=tempo_out;velocidade_ex=velocidade;direcao_ex=direcao;
tempo_out_ex(isnan(tempo_out_ex))=999;velocidade_ex(isnan(velocidade_ex))=999;direcao_ex(isnan(direcao_ex))=999;

gravar_excel_corrente(nome,tempo_out_ex,velocidade_ex,direcao_ex,diretorio,decl);
elementos=[];
gravar_excel_estat(nome,tempo_out,velocidade,direcao,diretorio,...
    num_range,num_gap,num_rep,num_sinc,num_spike,num_inc,num_amb,corte_in+corte_fin,numel(elementos))
end