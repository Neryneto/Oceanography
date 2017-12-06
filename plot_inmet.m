function plot_inmet(data,temperatura,pressao,vel_vento,dir_vento,nome)

% h=figure(1)
% subplot(2,1,1)
% pressao(pressao==0)=nan;
% temperatura(temperatura==0)=nan;
% % title ('Temperatura do ar e pressão atmosférica','Fontsize',12)
% hold on
% % rectangle('Position',[datenum(2015,9,23,0,0,0),20,2,20],'FaceColor','y','EdgeColor','k')
% plot(data,temperatura,'r')
% legend ('Temperatura (º)','Location','NorthEast','FontSize',6)
% xlim([data(1,1)-0.1 data(end,1)+0.1])
% ylim([20 40])
% vetor_data=[floor(data(1,1)):2:ceil(data(end,1))];
% set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
% % set(gca,'XTick',datenum(2015,6,17,12,0,0):0.5:datenum(2015,6,20,12,0,0),'FontSize',8)
% datetick('x','dd-mm','keeplimits','keepticks')
% % h(10:10:end,:,:) = 0;       %# Change every tenth row to black
% % h(:,10:10:end,:) = 0; 
% grid on
% set(gca,'Layer','top')
% ylabel('°C')
% box on
% 
% subplot(2,1,2)
% rectangle('Position',[datenum(2015,9,23,0,0,0),1000,2,20],'FaceColor','y','EdgeColor','k')
% hold on
% plot(data,pressao)
% y=legend ('Pressão atmosférica (hPa)','Location','SouthEast');
% set(y,'FontSize',8)
% xlim([data(1,1)-0.1 data(end,1)+0.1])
% ylim([1005 1020])
% grid on
% vetor_data=[floor(data(1,1)):2:ceil(data(end,1))];
% set(gca,'XTick',vetor_data,'XTickLabel',vetor_data,'FontSize',8)
% % set(gca,'XTick',datenum(2015,6,17,12,0,0):0.5:datenum(2015,6,20,12,0,0),'FontSize',8)
% % set(gca,'YTick',[1000:5:1030],'FontSize',8)
% datetick('x','dd-mm','keeplimits','keepticks')
% box on
% ylabel('hPa')
% print(h,'-dpng',['C:\Users\usuario\Desktop\Trabalhos\dados_huly\' nome],'-r300')
% close(h)

plota_ventos (data,vel_vento,dir_vento,nome)
end
