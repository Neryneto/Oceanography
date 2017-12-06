function [elementosCorrenteAqd]=le_plota_pitch_roll_correnteAqd(caminho)

%lê arquivo. Deve estar codificado como ANSI
arquivo = uigetfile({'*.dat'},'Selecionar arquivo .dat',caminho)
% fid = fopen([caminho '\' arquivo],'r','n','Unicode');
[fid, errormsg] = fopen([caminho '\' arquivo],'r');
leitor=[repmat('%f ',[1 18]) '%*[^\n]']; 
arq_txt=textscan(fid, leitor);

%organiza vetores
aux_data=[arq_txt{1,3},arq_txt{1,1},arq_txt{1,2},arq_txt{1,4},arq_txt{1,5},arq_txt{1,6}];
data=datenum(double(aux_data));

pitchCorrente=arq_txt{1,17};
rollCorrente=arq_txt{1,18};
elementosCorrenteAqd=find(pitchCorrente>30 | rollCorrente>30 | pitchCorrente<-30 | rollCorrente<-30);
end