%Rotina criada por Nery Neto em 11/05 para ler arquivos de corrente do AWAC
%output: vetor time e vetores vel_cel dir_cel

function le_plota_correntes_aqd(nome_figura,nome_arquivo,caminho,corte_in,corte_fin)
%plota pitch e roll
% [corteInclinacao]=le_plota_pitch_roll_aqd(nome_figura,nome_arquivo,caminho,corte_in,corte_fin);

arquivo = uigetfile({'*.dat'},'Selecionar arquivo de velocidade de corrente',caminho)
[fid, errormsg] = fopen([caminho '\' arquivo],'r+');
arq_txt=textscan(fid, '%*s %d %d %s %s %f');
fclose(fid);

%cria o vetor time
formatIn='m/dd/yyyy';
veldia=datevec(arq_txt{1,3},formatIn);

formatIn2='HH:MM';
velhora=datevec(arq_txt{1,4},formatIn2);
vel_cel=arq_txt{1,5};

time=datenum([veldia(:,1:3) velhora(:,4:6)]);
tempo=time;

% clearvars -except num_cell vel_cel tempo nome_figura caminho nome_arquivo

%para direção
%Lê o arquivo e cria a estrutura de array
arquivo_dir=uigetfile({'*.dat'},'Selecionar arquivo de direção de corrente',caminho);
% fid_dir = fopen([caminho '\' arquivo_dir],'r','n','UTF-8');
fid_dir = fopen([caminho '\' arquivo_dir],'r');
var_dir=textscan(fid_dir, '%*s %d %d %s %s %f');

%Separa os dados de acordo com as células
dir_cel=var_dir{1,5};

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

% clearvars -except vel_cel dir_cel tempo nome_arquivo caminho decl

%%
%salva dados brutos
save ([caminho '\Dados_Brutos_Corrente_' nome_arquivo '.mat'],'vel_cel','dir_cel','tempo');

%%
%plota parâmetros de qualidade
% le_plota_SNR_awac(caminho,size(dir_cel,2),nome_arquivo);

%%
%confere erros
diretorio=uigetdir(caminho);

% [elementosCorrenteAqd]=le_pitch_rollCorAqd(caminho);
elementosCorrenteAqd=[];
num_inc=length(elementosCorrenteAqd);
% vel_cel(elementosCorrenteAqd,:)=nan;dir_cel(elementosCorrenteAqd,:)=nan;
global nome_est
gui_escolha_estacao
pause

[velocidade direcao num_range num_rep num_spike num_gap num_sinc num_amb,...
    dados_excluidos dados_eliminados tempo_out u v]=confere_erros_s(vel_cel,...
    dir_cel,corte_in,corte_fin,tempo,caminho,elementosCorrenteAqd,nome_est);


%%
% cria gráficos
prompt = {'Entre 1 para o norte para cima e 2 para norte para esquerda:'};
dlg_title = 'Definir o norte';
num_lines = 1;
def = {'1'};
norte = inputdlg(prompt,dlg_title,num_lines,def);
num_cell=1;
maximosHistograma=[];
for i=1:num_cell
xbin = [0:22.5:360];
ybin = [0:0.025:nanmax(nanmax(velocidade))];
[a,h] = binsort(direcao(:,i),velocidade(:,i),velocidade(:,i),xbin(:),ybin(:));
a2 = a(2:end,2:end);
h2 = h(2:end,2:end);
maximosHistograma=[maximosHistograma;nanmax(nanmax(h2))];
end
maximosHistograma=max(maximosHistograma);
for i=1:num_cell
plota_correntes(velocidade(:,i),direcao(:,i),tempo_out,i,nome_figura,diretorio);
plota_DVP(velocidade(:,i),direcao(:,i),0,1,tempo_out,i,nome_figura,diretorio);
plota_histcurrents(velocidade(:,i),direcao(:,i),nome_figura,i,diretorio,nanmax(nanmax(velocidade)),maximosHistograma);
plota_rosa_corr(velocidade(:,i),direcao(:,i),nome_figura,diretorio,i,nanmax(velocidade));
if numel(velocidade)/num_cell<=2160
    plota_stickplot3(velocidade(:,i),direcao(:,i),tempo_out,1,nome_figura,i,diretorio,mode(diff(tempo_out)),...
nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)
elseif numel(velocidade)/num_cell>2160 && numel(velocidade)/num_cell<=2880
plota_stickplot4(velocidade(:,i),direcao(:,i),tempo_out,1,nome_figura,i,diretorio,mode(diff(tempo_out)),...
nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)
else
    plota_stickplot5(velocidade(:,i),direcao(:,i),tempo_out,1,nome_figura,i,diretorio,mode(diff(tempo_out)),...
        nanmax(nanmax(velocidade)),nanmax(nanmax(v)),norte)
end
end

%%
%salva dados processados
save ([caminho '\Dados_Processados_Corrente_' nome_arquivo '.mat'], 'velocidade','direcao','tempo_out')

%%
%salvar dados em Excel
tempo_out_ex=tempo_out;velocidade_ex=velocidade;direcao_ex=direcao;
tempo_out_ex(isnan(tempo_out_ex))=999;velocidade_ex(isnan(velocidade_ex))=999;direcao_ex(isnan(direcao_ex))=999;
% 
gravar_excel_corrente_aqd(nome_arquivo,tempo_out_ex,velocidade_ex,direcao_ex,diretorio,decl);
gravar_excel_estat_aqd(nome_arquivo,tempo_out,velocidade,direcao,diretorio,...
    num_range,num_gap,num_rep,num_spike,corte_in+corte_fin,numel(elementosCorrenteAqd));

%plota presstemp
le_plota_press_temp (nome_figura,nome_arquivo,caminho)

end