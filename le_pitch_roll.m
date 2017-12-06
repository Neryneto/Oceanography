function [elementosOnda elementosCorrente]=le_plota_pitch_roll(caminho)

%lê arquivo. Deve estar codificado como ANSI
arquivo = uigetfile({'*.sen'},'Selecionar arquivo .sen',caminho)
% fid = fopen([caminho '\' arquivo],'r','n','Unicode');
[fid, errormsg] = fopen([caminho '\' arquivo],'r');
leitor=[repmat('%f ',[1 14]) '%*[^\n]']; 
arq_txt=textscan(fid, leitor);

%organiza vetores
aux_data=[arq_txt{1,3},arq_txt{1,1},arq_txt{1,2},arq_txt{1,4},arq_txt{1,5},arq_txt{1,6}];
data=datenum(double(aux_data));

pitchCorrente=arq_txt{1,13};
rollCorrente=arq_txt{1,14};
elementosCorrente=find(pitchCorrente>30 | rollCorrente>30 | pitchCorrente<-30 | rollCorrente<-30);

%%
%ondas
arquivo = uigetfile({'*.whd'},'Selecionar arquivo .whd',caminho)
% fid = fopen([caminho '\' arquivo],'r','n','Unicode');
[fid, errormsg] = fopen([caminho '\' arquivo],'r');
leitor=[repmat('%f ',[1 14]) '%*[^\n]']; 
arq_txt=textscan(fid, leitor);

aux_data=[arq_txt{1,3},arq_txt{1,1},arq_txt{1,2},arq_txt{1,4},arq_txt{1,5},arq_txt{1,6}];
data=datenum(double(aux_data));

pitch=arq_txt{1,13};
roll=arq_txt{1,14};

elementosOnda=find(pitch>10.5 & pitch<=30 | roll>10.5 & roll<30 | pitch<-10.5 & pitch>=-30 | roll<-10.5 & roll>-30);
end