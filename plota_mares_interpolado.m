function plota_mares_interpolado (data,elevacao,local)

if data(1,1)<50000
    data(:,1)=data(:,1)+693960;
end

data_interp=data(1,1):1/10^5:data(end,1);
elevacao_interp=interp1(data,elevacao,data_interp,'cubic');
% intervalo=mean(diff(data))
% [NAME,FREQ,TIDECON,XOUT]=t_tide(elevacao,'interval',intervalo*24,'rayleigh',1);
% [NAME,FREQ,TIDECON,XOUT]=t_tide(mare(:,2),'interval',1/(24*4),'rayleigh',1);

ele=figure(1)
subplot(2,1,2)
plot(data_interp,elevacao_interp)
title(['Maré medida em ' local],'FontSize',12)
xticks=floor(data(1,1)):1:round(data(end,1));
xlim([floor(data(1,1))-1 round(data(end,1))+1]);
set(gca,'XTick',xticks,'Fontsize',9);
datetick('x','dd/mm/yyyy','keepticks','keeplimits');
xticklabel_rotate([],90,[],'Fontsize',8)
set(gca,'FontSize',8)
grid on
xlabel('Data','FontSize',8)
ylabel('Elevação (m)','FontSize',8)
rectangle('Position',[datenum(2015,6,1,0,0,0),-0.19,2,1.76],'EdgeColor','r','LineWidth',2)
ylim([-0.2 1.6])
print(ele,['C:\Users\usuario\Desktop\Trabalhos\dados_huly' local],'-dpng','-r300');

% com=figure(2)
% plot(data,elevacao)
% hold on
% xout=XOUT+nanmean(elevacao);
% plot(data,xout,'r')
% plot(data,xout-elevacao,'k')
% erro=rmse(xout,elevacao);
% title(['Maré medida e prevista em ' local],'FontSize',12)
% datetick('x','dd/mm','keepticks','keeplimits')
% set(gca,'FontSize',8);
% gtext(['EQM: ' num2str(round(erro*10^2)/100)])
% legend({'Maré medida','Maré prevista','Maré meteorológica'})
% grid on
% xlabel('Data','FontSize',8)
% ylabel('Elevação (m)','FontSize',8)
% print(com,['C:\Users\nery.neto\Desktop\figuras\mare_meteor_' local],'-dpng','-r300');

close all
end