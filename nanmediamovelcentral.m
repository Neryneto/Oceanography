function [out,num_nan] = nanmediamovelcentral(X,F)

%Fun��o desenvolvida por Nery para calcular a m�dia m�vel central sendo que
%o �nico NaN ser� onde n�o havia o dado. Para inserir NaN em todo o grupo
%da m�dia m�vel, usar a rotina nanmmcentral.

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


