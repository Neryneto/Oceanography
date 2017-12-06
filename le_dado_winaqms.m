pathroot = 'C:\Users\nery.neto\Desktop\teste_andre\dados\2015';
%% pasta de cada localidade
MyNumericalDir = {'01';'02';'03';'04';'05';'06';'07';'08';'09';'10'};
% Vetor de output
AllResult = [];
FinalSheet=[];

%% loop para cada folder numérico
AllFile=[];
tempo_aux=[];
report=[];
arquivos=[];
A1=[];
for i = 1:length(MyNumericalDir)
%      pega todos arquivos ".LOG" na pasta do CO
    CurrentDir = fullfile(pathroot,MyNumericalDir{i});
    arquivos = dir(fullfile(CurrentDir,'*.wad'));
    
    for j=1:size(arquivos,1)
[fid, errormsg] = fopen([CurrentDir '\' arquivos(j,1).name],'r+');
nCols = 23;
format_aux = repmat(' %f32 %s', [1 nCols]);
format=['%s %s %s' format_aux  ' %*[^\n]'] ;
A1 = [A1;textscan(fid,format,'EmptyValue',9999,'delimiter',',','headerLines', 2)];
clear fid errormsg
    end
end    
    clear arquivos CurrentDir i j
%%

%escolher o período
tempo_esc=[];
for tam_a1=1:size(A1,1)
% for tam_a1=185:189
     if strncmpi('2015-',A1{tam_a1,3}(1,1),5)==1;
        tempo_esc=[tempo_esc;datenum(A1{tam_a1,3}(1,1))];
    elseif strncmpi('2015/',A1{tam_a1,3}(1,1),5)==1;
        tempo_esc=[tempo_esc;datenum(A1{tam_a1,3}(1,1),'yyyy/mm/dd HH:MM')];
    elseif strcmp('',A1{tam_a1,3}(1,1))==1;
        tempo_esc=[tempo_esc;nan];
     end
end

aux_ini=datenum(input('Inserir data inicial entre aspas simples no formato dd/mm/yy : '),'dd/mm/yy')
aux_fim=datenum(input('Inserir data final entre aspas simples no formato dd/mm/yy : '),'dd/mm/yy')

[ini, t_ind] = find(min(abs(tempo_esc-aux_ini)));
[fim, t_ind2] = find(min(abs(tempo_esc-aux_fim)));
%%
%usar esta sessão para ler dados a cada hora

for tam_a1=ini:fim
    for tam_cada=1:size(A1{tam_a1,1},1)
        [x y] = ind2sub(size(A1{tam_a1,3}),find(cellfun(@(x)strcmp(x,'001'),A1{tam_a1,3},'UniformOutput',1)));
    end
end
   
    for tam_a1=1:size(A1,1)
    for tam_cada=1:size(A1{tam_a1,1},1)
        [x y] = ind2sub(size(A1{tam_a1,2}),find(cellfun(@(x)strcmp(x,'001'),A1{tam_a1,2},'UniformOutput',1)));
        for colunas=1:size(A1,2)
            eval(['Dados{tam_a1,' num2str(colunas) '}=A1{tam_a1,' num2str(colunas) '}(x,1);']);
        end
    end
end
    
    
    
    
%%
%usar esta sessão quando quiser todos os dados
% 
% for strings={'temp' 'co' 'no' 'so2' 'no2' 'nox' 'pts' 'pm10' 'pm25' 'vv' 'dv'};    
% eval(['str_i_' cell2mat(strings) '=[];']);
% eval(['valor_i_' cell2mat(strings) '=[];']);
% eval(['str_' cell2mat(strings) '=[];']);
% eval(['valor_' cell2mat(strings) '=[];']);
% end
% 
% % data_ini=datenum(caminho(2,1),'dd/mm/yyyy HH:MM');
% % data_dim=datenum(caminho(3,1),'dd/mm/yyyy HH:MM');
% 
% for i=1:size(A1,1)
% str_i_temp=[str_i_temp;A1{i,5}(:,1)];
% str_i_co=[str_i_co;A1{i,7}(:,1)];
% str_i_no=[str_i_no;A1{i,9}(:,1)];
% str_i_no2=[str_i_no2;A1{i,11}(:,1)];
% str_i_nox=[str_i_nox;A1{i,13}(:,1)];
% str_i_so2=[str_i_so2;A1{i,15}(:,1)];
% str_i_pts=[str_i_pts;A1{i,17}(:,1)];
% str_i_pm10=[str_i_pm10;A1{i,19}(:,1)];
% str_i_pm25=[str_i_pm25;A1{i,21}(:,1)];
% str_i_vv=[str_i_vv;A1{i,23}(:,1)];
% str_i_dv=[str_i_dv;A1{i,25}(:,1)];
% 
% valor_i_temp=[valor_i_temp;A1{i,4}(:,1)];
% valor_i_co=[valor_i_co;A1{i,6}(:,1)];
% valor_i_no=[valor_i_no;A1{i,8}(:,1)];
% valor_i_no2=[valor_i_no2;A1{i,10}(:,1)];
% valor_i_nox=[valor_i_nox;A1{i,12}(:,1)];
% valor_i_so2=[valor_i_so2;A1{i,14}(:,1)];
% valor_i_pts=[valor_i_pts;A1{i,16}(:,1)];
% valor_i_pm10=[valor_i_pm10;A1{i,18}(:,1)];
% valor_i_pm25=[valor_i_pm25;A1{i,20}(:,1)];
% valor_i_vv=[valor_i_vv;A1{i,22}(:,1)];
% valor_i_dv=[valor_i_dv;A1{i,24}(:,1)];
% 
% tempo_aux=[tempo_aux;A1{i,3}(:,1)];
% report=[report;(A1{i,2}(:,1))];
% end
% 
% clear i
% 
% for i=1:length(tempo_aux)
%     if strncmpi('2015-',tempo_aux(i),5)==1;
%         tempo(i,1)=datenum(tempo_aux(i,1));
%     elseif strncmpi('2015/',tempo_aux(i),5)==1;
%         tempo(i,1)=datenum(tempo_aux(i,1),'yyyy/mm/dd HH:MM');
%     elseif strcmp('',tempo_aux(i))==1;
%         tempo(i,1)=nan;
%     end
% end
% 
% tempo(isnan(tempo))=[];
% clear i

%%
%encontra e separa os valores horários
logico=strcmp(report,'001');
[indices coluna]=find(logico==1);
str_tempo=tempo(indices);
for strings={'temp' 'co' 'no' 'so2' 'no2' 'nox' 'pts' 'pm10' 'pm25' 'vv' 'dv'};    
eval(['str_' cell2mat(strings) '=str_i_' cell2mat(strings) '(indices,1);']);
eval(['valor_' cell2mat(strings) '=valor_i_' cell2mat(strings) '(indices,1);']);
%encontra valores iguais a -9999 | -9.999 | 9999 e substitui por "II"
eval(['str_' cell2mat(strings) '(valor_' cell2mat(strings) '==9999)=cellstr(''II'');'])
eval(['str_' cell2mat(strings) '(valor_' cell2mat(strings) '==9.999)=cellstr(''II'');'])
eval(['str_' cell2mat(strings) '(valor_' cell2mat(strings) '==-9999)=cellstr(''II'');'])
eval(['valor_' cell2mat(strings) '(valor_' cell2mat(strings) '==9999)=NaN;']);
eval(['valor_' cell2mat(strings) '(valor_' cell2mat(strings) '==9.999)=NaN;']);
eval(['valor_' cell2mat(strings) '(valor_' cell2mat(strings) '==-9999)=NaN;']);
%encontra valores negativos e substitui por "?S"
eval(['str_' cell2mat(strings) '(valor_' cell2mat(strings) '<0)=cellstr(''?S'');'])
%encontra valores repetidos
eval(['str_' cell2mat(strings) '(diff(valor_' cell2mat(strings) ')==0)=cellstr(''?S'');'])
end

%critérios para os gases
str_nox(valor_nox>=0 & valor_nox<0.4906)=cellstr('<');
str_no2(valor_no2>=0 & valor_no2<0.4906)=cellstr('<');
valor_no(valor_no>=-0.4906 & valor_no<0)=0.2453;

for i=1:size(valor_no,1)
    if valor_no>=-0.4906 & valor_no<0
valor_no2(i)=valor_nox(i)-valor_no(i);
    end
end
str_no(valor_no>=-0.4906 & valor_no<0)=cellstr('<');

str_nox(valor_no>=-0.4906 & valor_no<0)=cellstr('V');
str_no2(valor_no>=-0.4906 & valor_no<0)=cellstr('VC');

str_no(valor_no<-0.4906)=cellstr('IS');
str_no2(valor_no2<-0.4906)=cellstr('IS');
str_nox(valor_nox<-0.4906)=cellstr('IS');
str_no(valor_nox<valor_no)=cellstr('IS');
str_nox(valor_nox<valor_no)=cellstr('IS');
str_no2(valor_nox<valor_no)=cellstr('IS');
    
%critérios para CO
str_co(valor_co>=-57.2462 & valor_co<=0)=cellstr('<');
valor_co(valor_co>=-57.2462 & valor_co<=0)=28.6231;
str_co(valor_co>=0 & valor_co<=57.2462)=cellstr('<');
str_co(valor_co<-57.2462)=cellstr('IS');

%critérios para SO
str_so2(valor_so2>=-1.3093 & valor_so2<=0)=cellstr('<');
valor_so2(valor_so2>=-1.3093 & valor_so2<=0)=0.6547;

str_so2(valor_so2>=0 & valor_so2<=1.3093)=cellstr('<');
str_so2(valor_so2<-1.3093)=cellstr('IS');

%critérios para O
% str_so2(valor_so2>=-1.3093 & valor_so2<=0)=cellstr('<');
% valor_so2(valor_so2>=-1.3093 & valor_so2<=0)=0.6547;
% str_so2(valor_so2>=0 & valor_so2<=1.3093)=cellstr('<');
% str_so2(valor_so2<-1.3093)=cellstr('IS');

%critérios para material Particulado
str_pts(valor_pts>=-5 & valor_pts<0)=cellstr('<');
valor_pts(valor_pts>=-5 & valor_pts<0)=2.5;
str_pm10(valor_pm10>=-5 & valor_pm10<0)=cellstr('<');
valor_pm10(valor_pm10>=-5 & valor_pm10<0)=2.5;
str_pm25(valor_pm25>=-5 & valor_pm25<0)=cellstr('<');
valor_pm25(valor_pm25>=-5 & valor_pm25<0)=2.5;

str_pts(valor_pts<valor_pm10-3)=cellstr('IS');
str_pm10(valor_pts<valor_pm10-3)=cellstr('IS');

str_pts(valor_pts<valor_pm25-3)=cellstr('IS');
str_pm25(valor_pts<valor_pm25-3)=cellstr('IS');

str_pts(valor_pts<valor_pm10-3)=cellstr('IS');
str_pm10(valor_pts<valor_pm10-3)=cellstr('IS');

str_pts(valor_pts==0)=cellstr('IC')
str_pm10(valor_pm10==0)=cellstr('IC')
str_pm25(valor_pm25==0)=cellstr('IC')

%critérios para o vento
str_vv(valor_vv<0)=cellstr('IS');
str_vv(valor_vv>10)=cellstr('?S');
str_dv(valor_dv>0 | valor_dv>360)=cellstr('IS');

for strings={'temp' 'co' 'no' 'so2' 'no2' 'nox' 'pts' 'pm10' 'pm25' 'vv' 'dv'};    
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''128''))=cellstr(''VS'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''129''))=cellstr(''VS'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''130''))=cellstr(''?S'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''131''))=cellstr(''?S'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''0''))=cellstr(''II'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''1''))=cellstr(''I%'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''64''))=cellstr(''IC'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''65''))=cellstr(''IC'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''33''))=cellstr(''IS'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''34''))=cellstr(''ID'');']);
eval(['str_' cell2mat(strings) '(strcmp(str_' cell2mat(strings) ',''36''))=cellstr(''IF'');']);
end


%%
%Transcrevendo para o arquivo final
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Data'},'Parâmetros','A1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Temperatura'},'Parâmetros','B1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag Temperatura'},'Parâmetros','C1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'CO'},'Parâmetros','D1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag CO'},'Parâmetros','E1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'NO'},'Parâmetros','F1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag NO'},'Parâmetros','G1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'NO2'},'Parâmetros','H1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag NO2'},'Parâmetros','I1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'NOx'},'Parâmetros','J1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag NOx'},'Parâmetros','K1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'SO2'},'Parâmetros','L1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag SO2'},'Parâmetros','M1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'PTS'},'Parâmetros','N1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag PTS'},'Parâmetros','O1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'PM10'},'Parâmetros','P1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag PM10'},'Parâmetros','Q1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'PM25'},'Parâmetros','R1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag PM25'},'Parâmetros','S1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Velocidade do vento'},'Parâmetros','T1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag Velocidade'},'Parâmetros','U1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Direção do vento'},'Parâmetros','V1');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 {'Flag Direção'},'Parâmetros','W1');

[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_tempo-693960,'Parâmetros','A2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_temp,'Parâmetros','B2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_temp,'Parâmetros','C2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_co,'Parâmetros','D2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_co,'Parâmetros','E2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_no,'Parâmetros','F2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_no,'Parâmetros','G2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_no2,'Parâmetros','H2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_no2,'Parâmetros','I2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_nox,'Parâmetros','J2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_nox,'Parâmetros','K2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_so2,'Parâmetros','L2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_so2,'Parâmetros','M2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_pts,'Parâmetros','N2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_pts,'Parâmetros','O2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_pm10,'Parâmetros','P2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_pm10,'Parâmetros','Q2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_pm25,'Parâmetros','R2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_pm25,'Parâmetros','S2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_vv,'Parâmetros','T2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_vv,'Parâmetros','U2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 valor_dv,'Parâmetros','V2');
[SUCCESS,MESSAGE]=xlswrite('C:\Users\nery.neto\Desktop\teste_andre\05\tabela_export',...
 str_dv,'Parâmetros','W2');