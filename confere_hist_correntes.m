vel=figure(1)
limites=linspace(0,1,27);
b=velocidade;
[m,z]=histc(b,limites);
somas=sum(m);
m=m./somas;
subplot(2,1,1)
bar(limites,m)
xlim([0 1])
ylim([0 0.075])
set(gca,'XTick',limites,'XTickLabel',limites*100,'fontsize',8)
xlabel('Velocidade de corrente (cm/s)')
set(gca,'Ytick',0:.01:.1,'YTickLabel',0:1:10)
ylabel('%')
title ('Gráfico de barras de porcentual de velocidades','fontsize',8);

edges=[0:20:360];
a=direcao;
[n,x]=histc(a,edges);
soma=sum(n);
n=n/soma;
subplot(2,1,2)
bar(edges,n)
xlim([0 360])
ylim([0 0.1])
set(gca,'XTick',edges)
set(gca,'XtickLabel',edges,'FontSize',8)
set(gca,'Ytick',0:.01:.1,'YTickLabel',0:1:10)
title ('Gráfico de barras de porcentual de direções');
xlabel('Direção de corrente (º)')
ylabel('%')
print(vel,['C:\Users\nery.neto\Desktop\figuras\hist'],'-dpng','-r300');
