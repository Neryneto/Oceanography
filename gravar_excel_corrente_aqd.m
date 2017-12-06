function gravar_excel_corrente(nome,tempo,velocidade,direcao,caminho,declinacao)

velocidade(velocidade==999)=nan;direcao(direcao==999)=nan;
[u,v]=veldir2uv(velocidade,direcao);
num_cel=size(velocidade,2);
str_uv=repmat({'U(m/s)' 'V(m/s)'},1,num_cel);
str_magdir=repmat({'Magnitude (m/s)' 'Direção (°)'},1,num_cel);


warning off

%cabeçalhos
mensagem=improved_xlswrite([caminho '\' nome],{'DADOS PROCESSADOS DE CORRENTE'},...
    'Dados de corrente processados','A1');

mensagem=improved_xlswrite([caminho '\' nome],{'Equipamento'},...
    'Dados de corrente processados','A3');
mensagem=improved_xlswrite([caminho '\' nome],{'Modelo'},...
    'Dados de corrente processados','A4');
mensagem=improved_xlswrite([caminho '\' nome],{'Head ID'},...
    'Dados de corrente processados','A5');
mensagem=improved_xlswrite([caminho '\' nome],{'Frequência acústica (kHz)'},...
    'Dados de corrente processados','A6');    
mensagem=improved_xlswrite([caminho '\' nome],{'Taxa de amostragem (Hz)'},...
    'Dados de corrente processados','A7');
mensagem=improved_xlswrite([caminho '\' nome],{'Intervalo entre medições (s)'},...
    'Dados de corrente processados','A8');
mensagem=improved_xlswrite([caminho '\' nome],{'Duração da medição (s)'},...
    'Dados de corrente processados','A9');
mensagem=improved_xlswrite([caminho '\' nome],{'Profundidade média do sensor de pressão (m)'},...
    'Dados de corrente processados','A10');
mensagem=improved_xlswrite([caminho '\' nome],{'Data Inicial'},...
    'Dados de corrente processados','A11');
mensagem=improved_xlswrite([caminho '\' nome],{'Data final'},...
    'Dados de corrente processados','A12');
mensagem=improved_xlswrite([caminho '\' nome],{'Tempo de coleta'},...
    'Dados de corrente processados','A13');

mensagem=improved_xlswrite([caminho '\' nome],{'Data'},...
    'Dados de corrente processados','B15');

mensagem=improved_xlswrite([caminho '\' nome],{'Declinação magnética'},...
    'Dados de corrente processados','H3');
mensagem=improved_xlswrite([caminho '\' nome],declinacao,...
    'Dados de corrente processados','K3');
mensagem=improved_xlswrite([caminho '\' nome],{'Dado extraído de <http://www.ngdc.noaa.gov/geomag-web/#declination>'},...
    'Dados de corrente processados','H4');

mensagem=improved_xlswrite([caminho '\' nome],{'Correntógrafo'},...
    'Dados de corrente processados','B3');
mensagem=improved_xlswrite([caminho '\' nome],{'Aquadopp Nortek'},...
    'Dados de corrente processados','B4');
mensagem=improved_xlswrite([caminho '\' nome],{'600'},...
    'Dados de corrente processados','B6');
mensagem=improved_xlswrite([caminho '\' nome],{'0,92'},...
    'Dados de corrente processados','B7');
mensagem=improved_xlswrite([caminho '\' nome],{'1800'},...
    'Dados de corrente processados','B8');
mensagem=improved_xlswrite([caminho '\' nome],{'300'},...
    'Dados de corrente processados','B9');
mensagem=improved_xlswrite([caminho '\' nome],tempo(1)-693960,...
    'Dados de corrente processados','B11');
mensagem=improved_xlswrite([caminho '\' nome],tempo(end)-693960,...
    'Dados de corrente processados','B12');
mensagem=improved_xlswrite([caminho '\' nome],tempo(end)-tempo(1),...
    'Dados de corrente processados','B13');
mensagem=improved_xlswrite([caminho '\' nome],{'dias'},...
    'Dados de corrente processados','C13');

%grava os nomes das células
cont=[];
for i=1:num_cel
str_cel=[{'Célula';num2str(i)}];
cont=[cont;str_cel];
strs_UV(1:2*num_cel,1)=str_uv;
end

aux(1:num_cel,1)={'Célula '};
aux_1(1:num_cel,1)=1:1:num_cel;
aux_2=num2str(aux_1);
strs_cel=strcat(aux,aux_2);

mensagem=improved_xlswrite([caminho '\' nome],cont',...
    'Dados de corrente processados','C14');
mensagem=improved_xlswrite([caminho '\' nome],str_uv,...
    'Dados de corrente processados','C15');
    
mensagem=improved_xlswrite([caminho '\' nome],tempo-693960,...
    'Dados de corrente processados','B16');

%cria o vetor_uv 
vtr_uv=[];
for i=1:num_cel
    vtr_uv(:,2*i-1)=u(:,i);
    vtr_uv(:,2*i)=v(:,i);
end
    vtr_uv(isnan(vtr_uv))=999;
mensagem=improved_xlswrite([caminho '\' nome],vtr_uv,...
    'Dados de corrente processados','C16');

xls_delete_sheets([caminho '\' nome '.xls'],{'Plan1';'Plan2';'Plan3'})

warning on
end