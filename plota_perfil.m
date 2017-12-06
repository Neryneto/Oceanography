function plota_perfil(vel,dir,nome,caminho)
[u,v]=veldir2uv(vel,dir);
celulas=size(u,2);
maximos=[nanmax(nanmax(u)) nanmax(nanmax(v))]
maximo=max(maximos);

U=-maximo:0.005:maximo;
V=-maximo:0.005:maximo;

for i=1:celulas
    m=u(:,i);
    n=v(:,i);
    for j=1:numel(U)-1
    Uu(j,i)=numel(m(m >= U(j) & m < U(j+1)));
    Vv(j,i)=numel(n(n >= V(j) & n < U(j+1)));
    end
    clear m n
end

figure(1)
Uu=[repmat(0,1,celulas);Uu];
Vv=[repmat(0,1,celulas);Vv];
Xx=(Uu./sum(sum(Uu)))*100;
Yy=(Vv./sum(sum(Vv)))*100;
Xx(Xx==0)=nan;
pcolor(U,1:celulas,Xx')
shading interp
colormap (jet)
% [C,H]=contour(x,z,v_test_1',10,'--b');
% clabel(C,H)
xticks=[floor(-maximo*10)/10:0.1:round(maximo*10)/10];
set(gca,'xtick',xticks);
xlabel('Velocidade (m/s)');
ylabel('Célula');
yticks=linspace(1,celulas,celulas+1);
yticklabel=1:celulas;
set(gca,'YTick',yticks,'YTickLabel',yticklabel);
ylim([1 celulas-0.1]);
title('Perfil vertical de correntes (m/s) em U')
col=colorbar;
title(col,'Ocorrência (%)','Fontsize',9);
print('-dpng',[caminho '\Perfil_U_' nome '.png']);


figure(2)
Yy(Yy==0)=nan;
% contourf(V,1:celulas,Yy')
pcolor(V,1:celulas,Yy')
shading interp
colormap (jet)
xticks=[floor(-maximo*10)/10:0.1:round(maximo*10)/10];
set(gca,'xtick',xticks);
xlabel('Velocidade (m/s)');
ylabel('Célula');
yticks=linspace(1,celulas,celulas+1);
yticklabel=1:celulas;
set(gca,'YTick',yticks,'YTickLabel',yticklabel);
ylim([1 celulas-0.1]);
title('Perfil vertical de correntes (m/s) em V')
col=colorbar;
title(col,'Ocorrência (%)','Fontsize',9);
print('-dpng',[caminho '\Perfil_V_' nome '.png']);
close all
end
