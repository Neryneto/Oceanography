%abre os arquivos
%tempo
tempo=datenum([aqd_4571(:,3) aqd_4571(:,1:2) aqd_4571(:,4:6)]);

%%
%plota arquivos

%série de temperatura
figure (1)
plot(tempo,aqd_3294(:,21),'r')
hold on
plot(tempo,aqd_3418(:,21),'k')
plot(tempo,aqd_4571(:,21),'b')
plot(tempo,aqd_4803(:,21),'g')
datetick('x','keepticks','keeplimits')

title('Série temporal de temperatura');
grid on
h=legend ('3294','3418','4571','4803','location','NorthWest')
h=legend ('4571','4803','location','NorthEast')

set(h,'FontSize',8)
ylim([20 25])
print('-dpng',['C:\Users\nery.neto\Desktop\figuras\aqd_temperatura_t3.png'],'-r600');
close

%%
figure (2)
plot(tempo,aqd_3294(:,20),'r')
hold on
plot(tempo,aqd_3418(:,20),'k')
plot(tempo,aqd_4571(:,20),'b')
plot(tempo,aqd_4803(:,20),'g')
datetick('x','keepticks','keeplimits')

title('Série temporal de pressão');
grid on
h=legend ('3294','3418','4571','4803','location','NorthWest')
set(h,'FontSize',8)
% ylim([20 25])
print('-dpng',['C:\Users\nery.neto\Desktop\figuras\aqd_pressao_t3.png'],'-r600');
close

%%
figure (3)
subplot(2,1,1)
aqd_3294(:,26)=1.01*aqd_3294(:,24)+0.05;
aqd_3294(:,27)=1.01*aqd_3294(:,24)-0.05;
aqd_3418(:,26)=1.01*aqd_3418(:,24)+0.05;
aqd_3418(:,27)=1.01*aqd_3418(:,24)-0.05;
aqd_4571(:,26)=1.01*aqd_4571(:,24)+0.05;
aqd_4571(:,27)=1.01*aqd_4571(:,24)-0.05;
aqd_4803(:,26)=1.01*aqd_4803(:,24)+0.05;
aqd_4803(:,27)=1.01*aqd_4803(:,24)-0.05;

plot(tempo,aqd_3294(:,24),'r','LineWidth',1.5)
hold on
plot(tempo,aqd_3294(:,26),'-.r','LineWidth',0.5)
plot(tempo,aqd_3294(:,27),'-.r','LineWidth',0.5)
plot(tempo,aqd_3418(:,24),'k','LineWidth',1.5)
plot(tempo,aqd_3418(:,26),'-.k','LineWidth',0.5)
plot(tempo,aqd_3418(:,27),'-.k','LineWidth',0.5)
plot(tempo,aqd_4571(:,24),'b','LineWidth',1.5)
plot(tempo,aqd_4571(:,26),'-.b','LineWidth',0.5)
plot(tempo,aqd_4571(:,27),'-.b','LineWidth',0.5)
plot(tempo,aqd_4803(:,24),'g','LineWidth',1.5)
plot(tempo,aqd_4803(:,26),'-.g','LineWidth',0.5)
plot(tempo,aqd_4803(:,27),'-.g','LineWidth',0.5)

% [u_3294 v_3294]=veldir2uv(aqd_3294(:,24),aqd_3294(:,25));
% [u_3418 v_3418]=veldir2uv(aqd_3418(:,24),aqd_3418(:,25));
% [u_4571 v_4571]=veldir2uv(aqd_4571(:,24),aqd_4571(:,25));
% [u_4803 v_4803]=veldir2uv(aqd_4803(:,24),aqd_4803(:,25));

% plot(tempo,aqd_3294(:,24),'r')
% hold on
% plot(tempo,aqd_3418(:,24),'k')
% plot(tempo,aqd_4571(:,24),'b')
% plot(tempo,aqd_4803(:,24),'g')
datetick('x','keepticks','keeplimits')
ylim([0 0.4]);

title('Série temporal de velocidade de corrente');
grid on
% h=legend ('3294','3418','4571','4803','location','NorthWest')
% set(h,'FontSize',8)
xlim([tempo(1,1)-1/24 tempo(end,1)+1/24])

subplot(2,1,2)
plot(tempo,aqd_3294(:,25),'r','LineWidth',1.5)
hold on
plot(tempo,aqd_3418(:,25),'k','LineWidth',1.5)
plot(tempo,aqd_4571(:,25),'b','LineWidth',1.5)
plot(tempo,aqd_4803(:,25),'g','LineWidth',1.5)
plot(tempo,aqd_4803(:,25)-aqd_4571(:,25),'k','LineWidth',1.5)

datetick('x','keepticks','keeplimits')

title('Série temporal de direção de corrente');
grid on
xlim([tempo(1,1)-1/24 tempo(end,1)+1/24])
print('-dpng',['C:\Users\nery.neto\Desktop\figuras\aqd_corrente_t3.png'],'-r600');
close