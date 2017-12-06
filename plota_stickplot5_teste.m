function [teta_rad,raio]=stickplot(velocidade,direcao,hora,scala,local,celula,caminho,intervalo,maximo,maximoV,answer)
% raio = magnitude
% teta = direcao em graus convencao nautica
% check_bins(direcao)
% %preparar para quiver c
% maximo=0.3;
ultima=hora(end);
aux_arredon=1/intervalo*15;
split_plot_aux=hora(1):15:hora(end);num_plot=numel(split_plot_aux);
velocidade(end+1:num_plot*aux_arredon+1)=0;direcao(end+1:num_plot*aux_arredon+1)=0;

for i=numel(hora)+1:num_plot*aux_arredon+1
hora(i)=hora(i-1)+intervalo;
end
espac_y=zeros(numel(velocidade),1);
if cell2mat(answer)==num2str(1)
    [u,v]=veldir2uv(velocidade,direcao);ind_vel=maximo;
else
[v,u]=veldir2uv(velocidade,direcao);ind_vel=maximo;
end

for c=1:num_plot
tabela_diferencas(:,c) = abs(split_plot_aux(c)-hora);
end

[in_l in_c]=find(tabela_diferencas==0);
split_plot=in_l;

n=figure(1);
subplot(3,1,1)

[hh,escala]=quiverc([hora(split_plot(1):split_plot(2));hora(split_plot(2))+.5],[espac_y(split_plot(1):split_plot(2));0],...
    ([u(split_plot(1):split_plot(2))/10;0]),[(v(split_plot(1):split_plot(2))/10);ind_vel/10]);
limiteY=ceil(escala*maximoV)/10;
if cell2mat(answer)==num2str(2)
    limiteY=ceil(escala*nanmax(u))/10;
end
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
yticks=[0 .1 .2 .3 .4 .52];
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(1),1),hora(split_plot(2)),9);
xlim([hora(split_plot(1))-1 hora(split_plot(2))+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
if maximoV<.1 
    ylim([-limiteY limiteY])  
    elseif maximoV>=.1 && maximoV<.2 
        ylim([-limiteY-.1 limiteY+.1])
elseif maximoV>=.2 && maximoV<.3 
    ylim([-limiteY-.1 limiteY+.1])
    elseif maximoV>=.3 && maximoV<.4 
    ylim([-limiteY limiteY])
    elseif maximoV>=.4 && maximoV<.5 
    ylim([-limiteY limiteY])
elseif maximoV>=.5 
    ylim([-limiteY limiteY])
end
aux=0.75*ylim;
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(1,1),'dd/mm') ' e ' datestr(hora(split_plot(2)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
% title (['Stick plot entre ' datestr(hora(1,1),'dd/mm') ' e ' datestr(hora(2),...
%     'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
if cell2mat(answer)==num2str(1)
arrow([hora(split_plot(1))-0.8 aux(2)-.1],[hora(split_plot(1))-0.8 aux(2)+.1],'Length',6)
text(hora(split_plot(1))-0.7,aux(2)+0.05,'N')
%seta na horizontal
else
arrow([hora(split_plot(1)) aux(2)-.05],[hora(split_plot(1))-0.75 aux(2)-.05],'Length',6)
text(hora(split_plot(1))-.5,aux(2)+.05,'N')
end
text(hora(split_plot(2))+.6,0.2,[num2str(ind_vel) ' m/s'],'fontsize',6)

subplot(3,1,2)
quiverc([hora(split_plot(2):split_plot(3));hora(split_plot(3))+.5],[espac_y(split_plot(2):split_plot(3));0],...
    ([u(split_plot(2):split_plot(3))/10;0]),[(v(split_plot(2):split_plot(3))/10);ind_vel/10]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(2),1),hora(split_plot(3)),9);
xlim([hora(split_plot(2))-1 hora(split_plot(3))+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
if maximoV<.1 
    ylim([-limiteY limiteY])  
    elseif maximoV>=.1 && maximoV<.2 
        ylim([-limiteY-.1 limiteY+.1])
elseif maximoV>=.2 && maximoV<.3 
    ylim([-limiteY-.1 limiteY+.1])
    elseif maximoV>=.3 && maximoV<.4 
    ylim([-limiteY limiteY])
    elseif maximoV>=.4 && maximoV<.5 
    ylim([-limiteY limiteY])
elseif maximoV>=.5 
    ylim([-limiteY limiteY])
end
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(2),1),'dd/mm') ' e ' datestr(hora(split_plot(3)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
if cell2mat(answer)==num2str(1)
arrow([hora(split_plot(2))-0.8 aux(2)-.1],[hora(split_plot(2))-0.8 aux(2)+.1],'Length',6)
text(hora(split_plot(2))-.7,aux(2)+0.05,'N')
else
%seta na horizontal
arrow([hora(split_plot(2)) aux(2)-.05],[hora(split_plot(2))-0.75 aux(2)-.05],'Length',6)
text(hora(split_plot(2))-.5,aux(2)+.05,'N')
end

text(hora(split_plot(3))+.6,0.2,[num2str(ind_vel) ' m/s'],'fontsize',6)

subplot(3,1,3)
quiverc([hora(split_plot(3):split_plot(4));hora(split_plot(4))+.5],[espac_y(split_plot(3):split_plot(4));0],...
    ([u(split_plot(3):split_plot(4))/10;0]),[(v(split_plot(3):split_plot(4))/10);ind_vel/10]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(3),1),hora(split_plot(4)),9);
xlim([hora(split_plot(3))-1 hora(split_plot(4))+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
if maximoV<.1 
    ylim([-limiteY limiteY])  
    elseif maximoV>=.1 && maximoV<.2 
        ylim([-limiteY-.1 limiteY+.1])
elseif maximoV>=.2 && maximoV<.3 
    ylim([-limiteY-.1 limiteY+.1])
    elseif maximoV>=.3 && maximoV<.4 
    ylim([-limiteY limiteY])
    elseif maximoV>=.4 && maximoV<.5 
    ylim([-limiteY limiteY])
elseif maximoV>=.5 
    ylim([-limiteY limiteY])
end
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(3),1),'dd/mm') ' e ' datestr(hora(split_plot(4)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
if cell2mat(answer)==num2str(1)
arrow([hora(split_plot(3))-0.8 aux(2)-0.1],[hora(split_plot(3))-0.8 aux(2)+.1],'Length',6)
text(hora(split_plot(3))-.7,aux(2)+0.05,'N')
else
%seta na horizontal
arrow([hora(split_plot(3)) aux(2)-.05],[hora(split_plot(3))-0.75 aux(2)-.05],'Length',6)
text(hora(split_plot(3))-.5,aux(2)+.05,'N')
end
text(hora(split_plot(4))+.6,0.2,[num2str(ind_vel) ' m/s'],'fontsize',6)
print('-dpng',[caminho '\Stickplot_1_' local '_celula_' num2str(celula)],'-r300');

figure(2)
subplot(3,1,1)
quiverc([hora(split_plot(4):split_plot(5));hora(split_plot(5))+.5],[espac_y(split_plot(4):split_plot(5));0],...
    [u(split_plot(4):split_plot(5))/10;0],[(v(split_plot(4):split_plot(5))/10);ind_vel/10]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(4),1),hora(split_plot(5)),9);
xlim([hora(split_plot(4))-1 hora(split_plot(5))+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
if maximoV<.1 
    ylim([-limiteY limiteY])  
    elseif maximoV>=.1 && maximoV<.2 
        ylim([-limiteY-.1 limiteY+.1])
elseif maximoV>=.2 && maximoV<.3 
    ylim([-limiteY-.1 limiteY+.1])
    elseif maximoV>=.3 && maximoV<.4 
    ylim([-limiteY limiteY])
    elseif maximoV>=.4 && maximoV<.5 
    ylim([-limiteY limiteY])
elseif maximoV>=.5 
    ylim([-limiteY limiteY])
end
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(4),1),'dd/mm') ' e ' datestr(hora(split_plot(5)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
if cell2mat(answer)==num2str(1)
arrow([hora(split_plot(4))-0.8 aux(2)-.1],[hora(split_plot(4))-0.8 aux(2)+.1],'Length',6)
text(hora(split_plot(4))-.7,aux(2)+0.05,'N')
%seta na horizontal
else
arrow([hora(split_plot(4)) aux(2)-.05],[hora(split_plot(4))-0.75 aux(2)-.05],'Length',6)
text(hora(split_plot(4))-.5,aux(2)+.05,'N')
end

text(hora(split_plot(5))+.6,0.2,[num2str(ind_vel) ' m/s'],'fontsize',6)

subplot(3,1,2)
quiverc([hora(split_plot(5):end);hora(end)+.5],[espac_y(split_plot(5):end);0],...
    [u(split_plot(5):end)/10;0],[v(split_plot(5):end)/10;ind_vel/10]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(5)),hora(end)+intervalo,9);
xlim([hora(split_plot(5))-1 hora(end)+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
if maximoV<.1 
    ylim([-limiteY limiteY])  
    elseif maximoV>=.1 && maximoV<.2 
        ylim([-limiteY-.1 limiteY+.1])
elseif maximoV>=.2 && maximoV<.3 
    ylim([-limiteY-.1 limiteY+.1])
    elseif maximoV>=.3 && maximoV<.4 
    ylim([-limiteY limiteY])
    elseif maximoV>=.4 && maximoV<.5 
    ylim([-limiteY limiteY])
elseif maximoV>=.5 
    ylim([-limiteY limiteY])
end
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(5),1),'dd/mm') ' e ' datestr(ultima,...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
if cell2mat(answer)==num2str(1)
arrow([hora(split_plot(5))-0.7 aux(2)-.1],[hora(split_plot(5))-0.7 aux(2)+.1],'Length',6)
text(hora(split_plot(5))-.6,aux(2),'N')
%seta na horizontal
else
arrow([hora(split_plot(5)) aux(2)-.05],[hora(split_plot(5))-0.75 aux(2)-.05],'Length',8)
text(hora(split_plot(5))-.5,aux(2)+0.05,'N')
end
text(hora(end)+.6,0.2,[num2str(ind_vel) ' m/s'],'fontsize',6)
       
print('-dpng',[caminho '\Stickplot_2_' local '_celula_' num2str(celula)],'-r300');
close all


%%
%exclusivamente para dados repetidos
% elseif numel(aux_i)==2;
% aux_n=1:num_fig;
% 
% n=aux_n(1);
% i=aux_i(1);
% l=figure(n);
% subplot(3,1,1)
% quiverc(hora(split_plot(i):split_plot(2)+1),[espac_y(split_plot(i):split_plot(2));0],...
%     ([u(split_plot(i):split_plot(2))/10; ind_vel/10]),[(v(split_plot(i):split_plot(2))/10);0]);
% h1=colorbar;
% set(gca, 'CLim', [0, ind_vel])
% % yticks=linspace(0,0.75,5);
% yticks=[0 0.1 0.2 0.3 0.4 0.5];
% set(h1, 'YTick',yticks,'YTickLabel',yticks)
% title(h1,'Velocidade (m/s)','Fontsize',9);
% vetor_data=linspace(hora(split_plot(i),1),hora(split_plot(i+1)+1),9);
% xlim([hora(split_plot(i))-1 hora(split_plot(i+1))+1]);
% ylim([-0.5 0.5])
% set(gca,'XTick',vetor_data);
% set(gca,'fontsize',7);
% set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
% datetick('x','dd-mm HH:MM','keepticks','keeplimits');
% title (['Stick plot entre ' datestr(hora(i,1),'dd/mm') ' e ' datestr(hora(split_plot(i+1)),...
%     'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
% grid on
% 
% subplot(3,1,2)
% quiverc(hora(split_plot(i+1):split_plot(3)+1),[espac_y(split_plot(i+1):split_plot(3));0],...
%     ([u(split_plot(i+1):split_plot(3))/10;ind_vel/10]),[(v(split_plot(i+1):split_plot(3))/10);0]);
% h1=colorbar;
% set(gca, 'CLim', [0, ind_vel])
% % yticks=linspace(0,ind_vel,5);
% set(h1, 'YTick',yticks,'YTickLabel',yticks)
% title(h1,'Velocidade (m/s)','Fontsize',9);
% vetor_data=linspace(hora(split_plot(i+1),1),hora(split_plot(3)+1),9);
% xlim([hora(split_plot(i+1))-1 hora(split_plot(3))+1]);
% ylim([-0.5 0.5])
% set(gca,'XTick',vetor_data);
% set(gca,'fontsize',7);
% set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
% datetick('x','dd-mm HH:MM','keepticks','keeplimits');
% title (['Stick plot entre ' datestr(hora(split_plot(i+1),1),'dd/mm') ' e ' datestr(hora(split_plot(3)),...
%     'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
% grid on
% 
% subplot(3,1,3)
% quiverc(hora(split_plot(3):split_plot(i+3)+1),[espac_y(split_plot(3):split_plot(i+3));0],...
%     ([u(split_plot(3):split_plot(i+3))/10; ind_vel/10]),[(v(split_plot(3):split_plot(i+3))/10);0]);
% h1=colorbar;
% set(gca, 'CLim', [0, ind_vel])
% % yticks=linspace(0,ind_vel,5);
% set(h1, 'YTick',yticks,'YTickLabel',yticks)
% title(h1,'Velocidade (m/s)','Fontsize',9);
% vetor_data=linspace(hora(split_plot(3),1),hora(split_plot(i+3)+1),9);
% xlim([hora(split_plot(3))-1 hora(split_plot(i+3))+1]);
% ylim([-0.5 0.5])
% set(gca,'XTick',vetor_data);
% set(gca,'fontsize',7);
% set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
% datetick('x','dd-mm HH:MM','keepticks','keeplimits');
% title (['Stick plot entre ' datestr(hora(split_plot(3),1),'dd/mm') ' e ' datestr(hora(split_plot(i+3)),...
%     'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
% grid on
% print('-dpng',[caminho '\Stickplot_' num2str(n) '_' local '_celula_' num2str(celula)],'-r300');
% close (l)
% 
% l=figure(2);
% i=aux_i(2);
% subplot(3,1,1)
% quiverc([hora(split_plot(i):end);hora(end)+mode(diff(hora))],[espac_y(split_plot(i):end);0],...
%     [u(split_plot(i):end)/10;ind_vel/10],[v(split_plot(i):end)/10;0]);
% h1=colorbar;
% set(gca, 'CLim', [0, ind_vel])
% % yticks=linspace(0,ind_vel,5);
% set(h1, 'YTick',yticks,'YTickLabel',yticks)
% title(h1,'Velocidade (m/s)','Fontsize',9);
% vetor_data=linspace(hora(split_plot(i)),hora(end)+mode(diff(hora)),9);
% xlim([hora(split_plot(i))-1 hora(end)+1]);
% ylim([-0.5 0.5])
% set(gca,'XTick',vetor_data);
% set(gca,'fontsize',7);
% set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
% datetick('x','dd-mm HH:MM','keepticks','keeplimits');
% title (['Stick plot entre ' datestr(hora(split_plot(i),1),'dd/mm') ' e ' datestr(hora(end),...
%     'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
% grid on
%         end
% clear i
% print('-dpng',[caminho '\Stickplot_' num2str(num_fig) '_' local '_celula_' num2str(celula)],'-r300');
% close all
end