%rotina para checar confiabilidade da rosa de ondas

function [vetor_final]=check_bins(dir,varargin)

% dir � o seu vetor de dados de dire��o
% bins � o vetor de espa�amento moldado pelo usu�rio. Default � para rosa
% com 8 divis�es de �ngulo
% out � o vetor com as divis�es de �ngulo
% ue � o n�emro de dados por intervalo


if length(varargin)==0;
    bins=[22.5:45:360];
else
    bins=varargin{:,1};
end
  
ue=[];
a=sort(dir);

for i=1:size(a,1)
    for j=1:size(bins,2)-1
        ue(1)=sum(a<bins(1));
ue(j+1)= sum(a>=bins(j) & a<bins(j+1));
ue(length(bins)+1)=sum(a>bins(end));
    end
end
bins(1,length(bins)+1)=360;
vetor_final=[bins' ue'];
end