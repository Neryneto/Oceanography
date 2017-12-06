function [teta_rad,raio]=stickplot_curto(velocidade,direcao,hora,scala,local,celula,caminho)
% raio = magnitude
% teta = direcao em graus convencao nautica
% check_bins(direcao)
% %preparar para quiver c

ind_vel=0.53;velocidade(end+1)=ind_vel;direcao(end+1)=90;
hora(end+1)=hora(end)+mode(diff(hora));
split_plot_aux=hora(1):15:hora(end);
num_fig=ceil(numel(split_plot_aux)/3);num_plot=numel(split_plot_aux);
espac_y=zeros(numel(velocidade),1);
[u,v]=veldir2uv(velocidade,direcao);

split_plot=[];
tabela_diferencas=[];
for c=1:num_plot
tabela_diferencas(:,c) = abs(split_plot_aux(c)-hora);
end

[in_l in_c]=find(tabela_diferencas==0);
split_plot=in_l;
%%
%exclusivamente para dados intercalados
% [in_l in_c]=find(tabela_diferencas==0 | tabela_diferencas>=0.0207 & tabela_diferencas<=0.0209);
% in_l=in_l(1:2:end);in_c=in_c(1:2:end);
% split_plot=in_l;
%%
aux_i=1:3:numel(split_plot_aux);

if numel(split_plot_aux)==1
j=figure(1);
subplot(3,1,1)
quiverc(hora,espac_y,u/10,v/10);

h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(1,1),hora(end),9);
xlim([hora(1)-0.3 hora(end)+0.3]);
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(1,1),'dd/mm') ' e ' datestr(hora(end,...
    1)+1,'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
print(j,[caminho '\Stickplot_' local '_celula_' num2str(celula)],'-dpng','-r600');

elseif numel(aux_i)==2;
aux_n=1:num_fig;

n=aux_n(1);
i=aux_i(1);
l=figure(n);
subplot(3,1,1)

quiverc(hora(split_plot(i):split_plot(i+1)+1),[espac_y(split_plot(i):split_plot(i+1));0],...
    ([u(split_plot(i):split_plot(i+1))/10;ind_vel/10]),[(v(split_plot(i):split_plot(i+1))/10);0]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
yticks=[0 .15 0.3 .45 0.53];
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(i),1),hora(split_plot(i+1)),9);
xlim([hora(split_plot(i))-1 hora(split_plot(i+1))+1]);
ylim([-0.6 0.6]) 
aux=0.75*ylim;
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(i,1),'dd/mm') ' e ' datestr(hora(split_plot(i+1)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
arrow([hora(split_plot(i))-0.8 aux(2)-.1],[hora(split_plot(i))-0.8 aux(2)+.1],'Length',8)
% arrow([hora(split_plot(i))+0.5 aux(2)-.05],[hora(split_plot(i))-0.5 aux(2)-.05],'Length',8)
text(hora(split_plot(i))-0.65,aux(2),'N')

subplot(3,1,2)
quiverc(hora(split_plot(i+1):split_plot(i+2)+1),[espac_y(split_plot(i+1):split_plot(i+2));0],...
    ([u(split_plot(i+1):split_plot(i+2))/10;ind_vel/10]),[(v(split_plot(i+1):split_plot(i+2))/10);0]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(i+1),1),hora(split_plot(i+2)),9);
xlim([hora(split_plot(i+1))-1 hora(split_plot(i+2))+1]);
ylim([-0.6 0.6]) 
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(i+1),1),'dd/mm') ' e ' datestr(hora(split_plot(i+2)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
arrow([hora(split_plot(i+1))-0.8 aux(2)-.1],[hora(split_plot(i+1))-0.8 aux(2)+.1],'Length',8)
% arrow([hora(split_plot(i))+0.5 aux(2)-.05],[hora(split_plot(i))-0.5 aux(2)-.05],'Length',8)
text(hora(split_plot(i+1))-0.65,aux(2),'N')

subplot(3,1,3)
quiverc([hora(split_plot(i+2):end);hora(end)+mode(diff(hora))],[espac_y(split_plot(i+2):end);0],...
    ([u(split_plot(i+2):end)/10;ind_vel/10]),[(v(split_plot(i+2):end)/10);0]);
h1=colorbar;
set(gca, 'CLim', [0, ind_vel])
% yticks=linspace(0,ind_vel,5);
set(h1, 'YTick',yticks,'YTickLabel',yticks)
title(h1,'Velocidade (m/s)','Fontsize',9);
vetor_data=linspace(hora(split_plot(i+2),1),hora(end),9);
xlim([hora(split_plot(i+2))-1 hora(end)+1]);
ylim([-0.6 0.6]) 
set(gca,'XTick',vetor_data);
set(gca,'fontsize',7);
set(gca,'YTick',-1:0.5:1,'YtickLabel',[]);
datetick('x','dd-mm HH:MM','keepticks','keeplimits');
title (['Stick plot entre ' datestr(hora(split_plot(i+2),1),'dd/mm') ' e ' datestr(hora(split_plot(i+3)),...
    'dd/mm') ' em ' local ' - Célula ' num2str(celula)],'FontSize',12); 
grid on
arrow([hora(split_plot(i+2))-0.8 aux(2)-0.05],[hora(split_plot(i+2))-0.8 aux(2)+.05],'Length',8)
% arrow([hora(split_plot(i))+0.5 aux(2)-.05],[hora(split_plot(i))-0.5 aux(2)-.05],'Length',8)
text(hora(split_plot(i+2))-0.65,aux(2),'N')
print('-dpng',[caminho '\Stickplot_' num2str(n) '_' local '_celula_' num2str(celula)],'-r300');

close (l)

       end
clear i
close all
end