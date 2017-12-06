%Rotina criada por Nery em 15/05/2015 para plotar dados de corrente em u e
%v

function plotacorrentes(vel,dir,time,celula,local,caminho)

%caso os dados já estejam em u e v, comentar a linha abaixo:
[u v]=veldir2uv(vel,dir);
% limites=max([abs(min(u));abs(max(u));abs(min(v));abs(max(v))]);
limites=0.5;

h=figure;
subplot(2,1,1)
plot(time,u,'r','LineWidth',1.5)
ylim([-limites-0.01*limites limites+limites*0.01]);
xlim([time(1)-1 time(end)+1]);
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Componente u (m/s)')
title(['Série temporal de correntes em ' local ' - Célula ' num2str(celula)]);
grid on


subplot(2,1,2)
plot(time,v,'k','LineWidth',1.5)
ylim([-limites-0.01*limites limites+limites*0.01]);
xlim([time(1)-1 time(end)+1]);
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Componente v (m/s)')
grid on

% width = 5.6;     % Width in inches
% height = 4.2;    % Height in inches
% alw = 0.5;    % AxesLineWidth
% fsz = 14;      % Fontsize
% lw = 1.5;      % LineWidth
% msz = 8; 
% 
% % Here we preserve the size of the image when we save it.
% set(gcf,'InvertHardcopy','on');
% set(gcf,'PaperUnits', 3);
% papersize = get(gcf, 'PaperSize');
% left = (papersize(1)- width)/2;
% bottom = (papersize(2)- height)/2;
% myfiguresize = [left, bottom, width, height];
% set(gcf,'PaperPosition', myfiguresize);

% Save the file as PNG
print('-dpng',[caminho '\Serie_temporal_' local '_celula_' num2str(celula) '.png']);
close all


