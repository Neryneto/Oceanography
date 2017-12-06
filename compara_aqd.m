%plotar pressão
tempo_4570=datenum(aqua4570(:,3),aqua4570(:,1),aqua4570(:,2),aqua4570(:,4),aqua4570(:,5),aqua4570(:,6));
tempo_4571=datenum(aqua4571(:,3),aqua4571(:,1),aqua4571(:,2),aqua4571(:,4),aqua4571(:,5),aqua4571(:,6));
tempo_4804=datenum(aqua4804(:,3),aqua4804(:,1),aqua4804(:,2),aqua4804(:,4),aqua4804(:,5),aqua4804(:,6));
tempo_4814=datenum(aqua4814(:,3),aqua4814(:,1),aqua4814(:,2),aqua4814(:,4),aqua4814(:,5),aqua4814(:,6));
figure (1)
plot(tempo_4570,aqua4570(:,20),'r')
hold on
plot(tempo_4571,aqua4571(:,20),'k')
plot(tempo_4804,aqua4804(:,20),'b')
plot(tempo_4814,aqua4814(:,20),'g')
datetick('x','keepticks','keeplimits')

title('Série temporal de pressão');
grid on
legend ('4570','4571','4804','4814')

%%
figure (2)
plot(tempo_4570,aqua4570(:,21),'r')
hold on
plot(tempo_4571,aqua4571(:,21),'k')
plot(tempo_4804,aqua4804(:,21),'b')
plot(tempo_4814,aqua4814(:,21),'g')
datetick('x','keepticks','keeplimits')

title('Série temporal de temperatura');
grid on
legend ('4570','4571','4804','4814')
%%
figure (3)
subplot(2,1,1)

plot(tempo_4570,aqua4570(:,24),'r','LineWidth',1.5)
hold on

plot(tempo_4570,aqua4571(:,24),'k','LineWidth',1.5)

plot(tempo_4570,aqua4804(:,24),'b','LineWidth',1.5)

plot(tempo_4814,aqua4814(:,24),'g','LineWidth',1.5)


datetick('x','keepticks','keeplimits')
ylim([-0.1 0.8]);

title('Série temporal de velocidade de corrente');
grid on
% h=legend ('3294','3418','4571','4803','location','NorthWest')
% set(h,'FontSize',8)
xlim([tempo_4570(11,1)-1/24 tempo_4570(28,1)+1/24])
xlim([ans(1,1) ans(2,1)])

subplot(2,1,2)
plot(tempo_4570,aqua4570(:,25),'r','LineWidth',1.5)
hold on
plot(tempo_4570,aqua4571(:,25),'k','LineWidth',1.5)
plot(tempo_4570,aqua4804(:,25),'b','LineWidth',1.5)
plot(tempo_4814,aqua4814(:,25),'g','LineWidth',1.5)
datetick('x','keepticks','keeplimits')

title('Série temporal de direção de corrente');
grid on
xlim([tempo_4570(1,1)-1/24 tempo_4570(end,1)+1/24])
ylim([0 360]);
print('-dpng',['C:\Users\nery.neto\Desktop\figuras\aqd_corrente2.png'],'-r600');
close