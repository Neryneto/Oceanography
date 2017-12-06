diretorio='C:\Users\nery.neto\Desktop\figuras';

a=figure(1)
subplot(2,1,1)
plot(gua(:,1),gua(:,2));
hold on
plot(gua(:,1),gua(:,3),'r')
ylim([-1.2 1.7])
datetick('x','dd/mm HH:MM','keepticks','keeplimits')
ylabel('Altura (m)')
title('Maré medida em Guamaré','FontSize',14);
grid on
legend({'Dado medido','Média Móvel 15 minutos'},'Location','NorthEast','FontSize',6)

print(mare_crua,'-dpng',[diretorio '\mare_guamare_filtro'],'-r300')
close(a)

b=figure(2)
subplot(2,4,1:4)
plot(gua(:,1),gua(:,3),'b')
hold on
plot(mia(:,1),mia(:,2),'r')
ylim([-1.2 1.7])
xlim([gua(1,1)-0.1 gua(end,1)-0.05+0.15])
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Altura (m)')
title('Comparação de dados de maré no RN','FontSize',14);
grid on
legend({'Guamaré','Miassaba'},'Location','NorthEast','FontSize',6)

subplot(2,4,5)
plot(gua(:,1),gua(:,3),'b')
hold on
plot(mia(:,1),mia(:,2),'r')
ylim([-1.2 1.7])
xlim([gua(1225,1) gua(1450,1)])
xticks5=datenum(2016,1,27,12,0,0):10/24/60:datenum(2016,2,2,12,0,0);
set(gca,'XTick',xticks5,'XTickLabel',xticks5)
datetick('x','HH:MM','keepticks','keeplimits')
set(gca,'Fontsize',6)
title('Dia 28/01','FontSize',8);
grid on

subplot(2,4,6)
plot(gua(:,1),gua(:,3),'b')
hold on
plot(mia(:,1),mia(:,2),'r')
ylim([-1.2 1.7])
xlim([gua(2300,1) gua(2575,1)])
set(gca,'XTick',xticks5,'XTickLabel',xticks5)
datetick('x','HH:MM','keepticks','keeplimits')
set(gca,'fontsize',6);
title('Dia 29/01','FontSize',8);
grid on

subplot(2,4,7)
plot(gua(:,1),gua(:,3),'b')
hold on
plot(mia(:,1),mia(:,2),'r')
ylim([-1.2 1.7])
xlim([gua(4200,1) gua(4400,1)])
set(gca,'XTick',xticks5,'XTickLabel',xticks5)
datetick('x','HH:MM','keepticks','keeplimits')
set(gca,'Fontsize',6)
title('Dia 30/01','FontSize',8);
grid on

subplot(2,4,8)
plot(gua(:,1),gua(:,3),'b')
hold on
plot(mia(:,1),mia(:,2),'r')
ylim([-1.2 1.7])
xlim([gua(5250,1) gua(5500,1)])
set(gca,'XTick',xticks5,'XTickLabel',xticks5)
datetick('x','HH:MM','keepticks','keeplimits')
set(gca,'Fontsize',6)
title('Dia 31/01','FontSize',8);
grid on

print('-dpng',[diretorio '\mare_guamare'],'-r300')
close(a)