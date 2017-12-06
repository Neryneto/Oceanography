caminho='I:\Trabalhos\Jurong';
[Filename,Pathname] = uigetfile({'*.dat'},'Selecionar arquivo de ondas',caminho)
fid = fopen([Pathname,Filename],'r');
[arq_txt]=textscan(fid, '%s %d %s %s %f');

%identifica os parâmetros
num_dados=max(arq_txt{1,2});
formatIn='m/dd/yyyy';
ondadia=datevec(arq_txt{1,3},formatIn);

formatIn2='HH:MM';
ondahora=datevec(arq_txt{1,4},formatIn2);

time=datenum([ondadia(:,1:3) ondahora(:,4:6)]);
tempo(:,1)=time(1:num_dados);

parametros={'Hm0','H10','Hmax','Hmean','H3','Tp','Tm02','Tz','DirTp','SprTp','MeanDir'};
parametros_valores=reshape(arq_txt{1,5},num_dados,length(parametros));
for ind = 1:length(parametros)
  onda.(parametros{ind}) = parametros_valores(:,ind);
end

decl=input ('Inserir declinação magnética em graus decimais: ');

%salva variáveis brutas
nome_arquivo='Jurong_abr';
save ([caminho '\Dados_Brutos_Ondas_' nome_arquivo '.mat'],'onda','tempo')

hs1=onda.Hm0(3:31);hs2=onda.Hm0(100:124);
dirtp1=onda.DirTp(3:31);dirtp2=onda.DirTp(100:124);
meandir1=onda.MeanDir(3:31);meandir2=onda.MeanDir(100:124);
diretorio='I:\Trabalhos\Jurong\abril';
%%
figure(1)
wind_rose(anglextocompass(meandir1+decl),hs1,'n',16,'lablegend',...
    'Altura (m)','di',[0.7:0.1:1.4],'quad',2,'labtitle',[{'Ponto 1 - Dia 22/12/2015'}],...
    'ci',[0:5:30]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[diretorio '\Rosa_ondas_Jurong_p1'],'-r300')

figure(2)
wind_rose(anglextocompass(meandir2+decl),hs2,'n',16,'lablegend',...
    'Altura (m)','di',[0.7:0.1:1.4],'quad',2,'labtitle',[{'Ponto 2 - Dia 23/12/2015'}],...
    'ci',[0:15:60]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[diretorio '\Rosa_ondas_Jurong_p2'],'-r300')

figure(3)
wind_rose(anglextocompass(dirtp1+decl),hs1,'n',16,'lablegend',...
    'Altura (m)','di',[0.7:0.1:1.4],'quad',2,'labtitle',[{'Ponto 1 - Dia 22/12/2015'}],...
    'ci',[0:15:60]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[diretorio '\Rosa_ondas_tpdir_Jurong_p1'],'-r300')

figure(4)
wind_rose(anglextocompass(dirtp2+decl),hs2,'n',16,'lablegend',...
    'Altura (m)','di',[0.7:0.1:1.4],'quad',2,'labtitle',[{'Ponto 2 - Dia 23/12/2015'}],...
    'ci',[0:15:60]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[diretorio '\Rosa_ondas_tpdir_Jurong_p2'],'-r300')

%%
%histogramas onda
bins_T = 3:2:12;
lim_T1=[3 12];

%Histograma Tz - Ponto 1
figure(6)
[h_ocor_Tz1]=histogram(onda.Tz(3:31),bins_T);
ylim([0 25])
% bar(bins_T',h_ocor_Tz1)  
% title('Histograma dos Períodos de Pico das Ondas');
  ylabel('Ocorrências');
  xlabel('Período Médio (s)');
  set(gca,'Ylim',[0 25],'YTick',0:5:25);
%cor das barras
  g = findobj(gca,'Type','patch');
  set(g,'FaceColor',[43/255 148/255 255/255])
  title('Ponto 1 - Dia 12/04/2016')
  print('-dpng',[diretorio '\HistTz_Jurong_p1'],'-r300')

%Histograma Tp - Ponto 1
figure(7)
[h_ocor_Tp1]=histogram(onda.Tp(3:31),bins_T);
% bar(bins_T',h_ocor_Tp1)  
% title('Histograma dos Períodos de Pico das Ondas');
  ylabel('Ocorrências');
  xlabel('Período de pico (s)');
set(gca,'Ylim',[0 25],'YTick',0:5:25);
%cor das barras
  g = findobj(gca,'Type','patch');
  set(g,'FaceColor',[43/255 148/255 255/255])
  title('Ponto 1 - Dia 12/04/2016')
  print('-dpng',[diretorio '\HistTp_Jurong_p1'],'-r300')  

%Histograma Tz - Ponto 2
figure(8)
[h_ocor_Tz2]=histogram(onda.Tz(100:124),bins_T);
% bar(bins_T',h_ocor_Tz2)  
% title('Histograma dos Períodos de Pico das Ondas');
  ylabel('Ocorrências');
  xlabel('Período Médio (s)');
set(gca,'Ylim',[0 25],'YTick',0:5:25);
%cor das barras
  g = findobj(gca,'Type','patch');
  set(g,'FaceColor',[43/255 148/255 255/255])
  title('Ponto 2 - Dia 13/04/2016')
  print('-dpng',[diretorio '\HistTz_Jurong_p2'],'-r300')

%Histograma Tp - Ponto 2
figure(9)
[h_ocor_Tp2]=histogram(onda.Tp(100:124),bins_T);
% bar(bins_T',h_ocor_Tp2)  
% title('Histograma dos Períodos de Pico das Ondas');
  ylabel('Ocorrências');
  xlabel('Período de pico (s)');
set(gca,'Ylim',[0 25],'YTick',0:5:25);
%cor das barras
  g = findobj(gca,'Type','patch');
  set(g,'FaceColor',[43/255 148/255 255/255])
  title('Ponto 2 - Dia 13/04/2016')
  print('-dpng',[diretorio '\HistTp_Jurong_p2'],'-r300') 
close all
  %%
  
[arquivo,caminho] = uigetfile({'*.dat'},'Selecionar arquivo de velocidade de corrente',caminho)
[fid, errormsg] = fopen([caminho arquivo],'r+');
arq_txt=textscan(fid, '%*s %d %d %s %s %f');
fclose(fid);

%Separa os dados de acordo com as células
num_cell=max(arq_txt{1,1});
num_dados=size(arq_txt{1,5},1)/num_cell;
vel_cel=reshape(arq_txt{1,5},size(arq_txt{1,5},1)/num_cell,num_cell);

%cria o vetor time
formatIn='mm/dd/yyyy';
veldia=datevec(arq_txt{1,3},formatIn);

formatIn2='HH:MM';
velhora=datevec(arq_txt{1,4},formatIn2);

time=datenum([veldia(:,1:3) velhora(:,4:6)]);
tempo(:,1)=time(1:num_dados);

clearvars -except num_cell vel_cel tempo local caminho nome onda

%para direção
%Lê o arquivo e cria a estrutura de array
[arquivo_dir,caminho_dir]=uigetfile({'*.dat'},'Selecionar arquivo de direção de corrente',caminho);
% fid_dir = fopen([caminho '\' arquivo_dir],'r','n','UTF-8');
fid_dir = fopen([caminho_dir arquivo_dir],'r');
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

clearvars -except vel_cel dir_cel tempo nome caminho

%separa os fundeios
vel1=vel_cel(2:32,1:14);dir1=dir_cel(2:32,1:14);
vel2=vel_cel(100:125,1:14);dir2=dir_cel(100:125,1:14);

[index1]=find(dir1<0);
dir1(index1)=dir1(index1)+360;
[index11]=find(dir1>360);
dir1(index11)=dir1(index11)-360;

[index2]=find(dir2<0);
dir1(index2)=dir1(index2)+360;
[index22]=find(dir2>360);
dir1(index22)=dir1(index22)-360;

%transforma para u e v, calcula média
[u1 v1]=veldir2uv(vel1,dir1);[u2 v2]=veldir2uv(vel2,dir2);
mediau1=mean(u1);mediav1=mean(v1);
mediau2=mean(u2);mediav2=mean(v2);

[mediavel1 mediadir1]=uv2veldir(mediau1,mediav1);
[mediavel2 mediadir2]=uv2veldir(mediau2,mediav2);

%média geral
media1=mean(mediavel1);media2=mean(mediavel2);

minimas1=min(vel1);minimas2=min(vel2);
maximas1=max(vel1);maximas2=max(vel2);

%media para elaboração das rosas
media_u1=mean(u1,2);media_v1=mean(v1,2);
media_u2=mean(u2,2);media_v2=mean(v2,2);

[media1_v,media1_d]=uv2veldir(media_u1,media_v1);
[media2_v,media2_d]=uv2veldir(media_u2,media_v2);

figure(9)
wind_rose(anglextocompass(media1_d),media1_v,'n',16,'lablegend',...
    'Intensidade (m/s)','di',[0.015:0.015:0.09],'quad',2,'labtitle',[{'Rosa de correntes em Jurong - Ponto 1'},{'Dia 12/04/2016'}],...
    'ci',[20:20:80]);
% wind_rose(anglextocompass(media1_d),media1_v,'n',16,'lablegend',...
%     'Intensidade (m/s)','quad',2,'labtitle',[{'Rosa de correntes em Jurong - Ponto 1'},{'Dia 12/04/2016'}],...
%     'ci',[20:20:80]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[caminho '\Rosa_correntes_Jurong_p1'],'-r300')

figure(10)
wind_rose(anglextocompass(media2_d),media2_v,'n',16,'lablegend',...
    'Intensidade (m/s)','di',[0.015:0.015:0.09],'quad',4,'labtitle',[{'Período de ondas em Jurong - Ponto 2'},{'Dia 13/04/2016'}],...
    'ci',[20:20:80]);
% wind_rose(anglextocompass(media2_d),media2_v,'n',16,'lablegend',...
%     'Intensidade (m/s)','quad',4,'labtitle',[{'Período de ondas em Jurong - Ponto 2'},{'Dia 13/04/2016'}],...
%     'ci',[20:20:80]);
set(gcf,'InvertHardcopy','off') 
print('-dpng',[caminho '\Rosa_correntes_Jurong_p2'],'-r300')

t1=tempo(13:42);t2=tempo(109:133);
figure(11)
subplot(3,1,1)
espac_y=zeros(numel(v1(:,1)),1);
[u,v]=veldir2uv(v1(:,12),dir1(:,12));
maximo=max(v1);
quiverc(t1,espac_y,u,v);
h1=colorbar;
set(gca, 'CLim', [0, maximo]);
yticks=linspace(0,maximo,5);
set(h1,'YTick',yticks,'YTickLabel',yticks);
ylim([-0.05 0.05]);
set(gca,'YTick',[])
title(h1,'Velocidade (m/s)','Fontsize',9);xlim([t1(1)-0.3 t1(end)+0.3]);
hora=t1;
% vetor_data=linspace(hora(1,1),hora(split(2)),9);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
vetor_data=[floor(t1(1,1)):0.05:ceil(t1(end,1))];
set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
set(gca,'fontsize',8);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
xlim([hora(1)-0.02 hora(end)+0.02])

title ('Stick plot dia 22/12/2015 no Ponto 1 - Superfície')
grid on

subplot(3,1,2)
espac_y=zeros(numel(v1(:,1)),1);
[u,v]=veldir2uv(v1(:,1),d1(:,1));
maximo=max(v1(:,1));maximo=0.4;
quiverc(t1,espac_y,u,v,.4);
h1=colorbar;
set(gca, 'CLim', [0, maximo]);
yticks=linspace(0,maximo,5);
set(h1,'YTick',yticks,'YTickLabel',yticks);
ylim([-0.03 0.03]);
set(gca,'YTick',[])
title(h1,'Velocidade (m/s)','Fontsize',9);xlim([t1(1)-0.3 t1(end)+0.3]);
hora=t1;
% vetor_data=linspace(hora(1,1),hora(split(2)),9);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
vetor_data=[floor(t1(1,1)):0.05:ceil(t1(end,1))];
set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
set(gca,'fontsize',8);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
xlim([hora(1)-0.02 hora(end)+0.02])
grid on

subplot(3,1,3)
espac_y=zeros(numel(v1(:,15)),1);
[u,v]=veldir2uv(v1(:,15),d1(:,15));
maximo=max(v1(:,16));maximo=0.4;
quiverc(t1,espac_y,u,v);
h1=colorbar;
set(gca, 'CLim', [0, maximo]);
yticks=linspace(0,maximo,5);
set(h1,'YTick',yticks,'YTickLabel',yticks);
ylim([-0.03 0.03]);
set(gca,'YTick',[])
title(h1,'Velocidade (m/s)','Fontsize',9);xlim([hora(1)-0.3 hora(end)+0.3]);
hora=t1;
% vetor_data=linspace(hora(1,1),hora(split(2)),9);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
vetor_data=[floor(hora(1,1)):0.05:ceil(hora(end,1))];
set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
set(gca,'fontsize',8);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
xlim([hora(1)-0.02 hora(end)+0.02])
grid on

clear u v espac_y

figure(12)
subplot(3,1,1)
espac_y=zeros(numel(v2(:,1)),1);
[u,v]=veldir2uv(v2(:,1),d2(:,1));
maximo=max(v2(:,1));maximo=0.4;
quiverc(t2,espac_y,u,v);
h1=colorbar;
set(gca, 'CLim', [0, maximo]);
yticks=linspace(0,maximo,5);
set(h1,'YTick',yticks,'YTickLabel',yticks);
ylim([-0.03 0.03]);
set(gca,'YTick',[])
title(h1,'Velocidade (m/s)','Fontsize',9);xlim([hora(1)-0.3 hora(end)+0.3]);
hora=t1;
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
vetor_data=[floor(t2(1,1)):0.05:ceil(t2(end,1))];
set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
set(gca,'fontsize',8);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
xlim([t2(1)-0.03 t2(end)+0.03])
grid on

subplot(3,1,2)
espac_y=zeros(numel(v2(:,8)),1);
[u,v]=veldir2uv(v2(:,8),d2(:,8));
maximo=max(v2(:,8));maximo=0.4;
quiverc(t2,espac_y,u,v);
h1=colorbar;
set(gca, 'CLim', [0, maximo]);
yticks=linspace(0,maximo,5);
set(h1,'YTick',yticks,'YTickLabel',yticks);
ylim([-0.03 0.03]);
set(gca,'YTick',[])
hora=t2;
% vetor_data=linspace(hora(1,1),hora(split(2)),9);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
vetor_data=[floor(t2(1,1)):0.05:ceil(t2(end,1))];
set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
set(gca,'fontsize',8);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
xlim([t2(1)-0.02 t2(end)+0.02])
grid on

subplot(3,1,3)
espac_y=zeros(numel(v2(:,14)),1);
[u,v]=veldir2uv(v2(:,14),d2(:,14));
maximo=max(v2(:,14));maximo=0.4;
quiverc(t2,espac_y,u,v);
h1=colorbar;
set(gca, 'CLim', [0, maximo]);
yticks=linspace(0,maximo,5);
set(h1,'YTick',yticks,'YTickLabel',yticks);
ylim([-0.03 0.03]);
set(gca,'YTick',[])
hora=t2;
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
vetor_data=[floor(hora(1,1)):0.05:ceil(hora(end,1))];
set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
set(gca,'fontsize',8);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
xlim([t2(1)-0.02 t2(end)+0.02])
grid on
%%
%organizar matriz em u e v
matriz_out=[];
for i=1:size(velocidade,2)
    [matriz_out(:,i*2-1),matriz_out(:,i*2)]=veldir2uv(velocidade(:,i),direcao(:,i));
end

%ou
velocidade=[];direcao=[];
for i=1:size(matriz,2)/2
    [velocidade(:,i),direcao(:,i)]=uv2veldir(matriz(:,i*2-1),matriz(:,i*2));
end

%comparar matrizes
for i=1:size(matriz_out,2)
    resultado(:,i)=find(matriz_out(:,i)~=comparar(:,i));
end