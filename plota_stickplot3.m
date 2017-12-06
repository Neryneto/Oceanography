function [teta_rad,raio]=stickplot(velocidade,direcao,hora,scala,local,celula,caminho,intervalo,maximo,maximoV,answer)
% raio = magnitude
% teta = direcao em graus convencao nautica
% check_bins(direcao)
% %preparar para quiver c
% maximo=0.78;
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
limiteY=ceil(escala*maximoV/100)/10;
if cell2mat(answer)==num2str(2)
    limiteY=ceil(escala*nanmax(u))/10;
end
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
yticks=[0 .2 .4 .6 .8 1 1.15];
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(1),1),hora(split_plot(2)),9);
xlim([hora(split_plot(1))-1 hora(split_plot(2))+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
    ylim([-limiteY+.8 limiteY-.8]) 
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
ylim([-limiteY+.8 limiteY-.8]) 
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
quiverc([hora(split_plot(3):end);hora(end)+.5],[espac_y(split_plot(3):end);0],...
    ([u(split_plot(3):end)/10;0]),[(v(split_plot(3):end)/10);ind_vel/10]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(3),1),hora(end),9);
xlim([hora(split_plot(3))-1 hora(end)+1]);
if cell2mat(answer)==num2str(2) ylim([-limiteY*2-.35 limiteY*2+.35]) 
end
ylim([-limiteY+.8 limiteY-.8]) 
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(3),1),'dd/mm') ' e ' datestr(ultima,...
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
text(hora(end)+.6,0.2,[num2str(ind_vel) ' m/s'],'fontsize',6)
print('-dpng',[caminho '\Stickplot_1_' local '_celula_' num2str(celula)],'-r300');
close
end