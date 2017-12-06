function [out,num_nan] = nanmediamovelcentral(X,F)

%Função desenvolvida por Nery para calcular a média móvel central sendo que
%o único NaN será onde não havia o dado. Para inserir NaN em todo o grupo
%da média móvel, usar a rotina nanmmcentral.

fator=(F-1)/2;
cel_ini=(F+1)/2;
for i=cel_ini:size(X,1)-fator
    aux(i,:)=nansum(X([i-fator:i+fator]))/F;
end

aux_nan=[];
aux_nan(1:fator,:)=nan;

aux(1:fator,:)=nan;
out=[aux;aux_nan];

%identifica nan
[l c]=find(isnan(X));
out(l,c)=nan;
num_nan=size(l,1);
end


