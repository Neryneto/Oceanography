function [elementosCorrente]=le_pitch_rollCor(caminho)

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
end