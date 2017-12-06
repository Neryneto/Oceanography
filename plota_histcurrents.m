function plota_histcurrents(velocidade,direcao,local,celula,caminho,maximo,maximoHistograma)

%Rotina criada por Nery em 18/05/2015 para gerar a tabela do histograma de
%correntes direcionais.
% maximo=0.33
xbin = [0:22.5:360];
ybin = [0:0.025:maximo];
if ybin(end)~=maximo
ybin(end+1)=ybin(end)+mode(diff(ybin));
end

hspotx = repmat(xbin, length(ybin), 1);
hspoty = repmat(ybin', 1, length(xbin));

[a,h] = binsort(direcao,velocidade,velocidade,xbin(:),ybin(:));

d_xbin = (mean(diff(xbin))/2);
d_ybin = (mean(diff(ybin))/2);

[m,n] = size(hspotx);

a2 = a(2:end,2:end);
h2 = h(2:end,2:end);

hmax = maximoHistograma;
hmin = min(min(h));
colormap jet
ax=gca;
load('MyColormaps','mycmap')
colormap(ax,mycmap)
caxis([0 maximoHistograma])
% cm = colormap jet;
% cm(1,:) = [1 1 1];
% colormap(cm)

axis([0 380 -.04*ybin(end) ybin(end)])

h2(end+1,:) = 0;
h2(:,end+1) = 0;


theRange = [hmin hmax];
theSpacing = diff(theRange)/64;   %Find the colorbar divisions

toPlot = h2;
% toBump = find(toPlot > 0 & toPlot <= (hmin+theSpacing));
% toPlot(toBump) = hmin+theSpacing;
toBump = find(toPlot > 0 & toPlot <= theSpacing);
toPlot(toBump) = theSpacing+0.01;
% toPlot(toPlo==0)=nan;
H = surface(hspotx,hspoty,toPlot)

set(H, 'edgealpha', 0.9)
shading faceted
ax1 = gca;
% set(ax1,'ydir','reverse')
set(ax1,'Box','on')
set(ax1,'XTick',11.25:22.5:360,'FontSize',[7],'xaxisLocation','bottom')
% set(ax1,'YTick',ybin,'FontSize',[8],'xaxisLocation','bottom')


% hpos = find(h2 > (hmin+theSpacing));
hpos = find(h2 > 0);
hfin = h2(hpos);
hxpos = hspotx(hpos) + (d_xbin);
hypos = hspoty(hpos) + (d_ybin);

for i = 1:length(hpos),
    hname = hfin(i);
%     if hname < 1
        hval = sprintf('%4.2f',hname);
%     else
%         hval = sprintf('%4.1f',hname);
%     end
     if hname > (hmin+10*theSpacing) & hname < (hmin+60*theSpacing)
        t(i) = text(hxpos(i),hypos(i),hfin(i)+1,hval,'color',[0 0 0],'HorizontalAlignment','center',...
            'FontSize',[7],'FontWeight','bold');
    else
        t(i) = text(hxpos(i),hypos(i),hfin(i)+1,hval,'color',[1 1 1],'HorizontalAlignment','center',...
            'FontSize',[7],'FontWeight','bold');

    end
%     set(t(i), 'erase', 'none')
end


for i = 1:size(h2,2)-1
    text(i*22.5-11.25, -.015*maximo, sprintf('%4.2f', sum(h2(:,i))), 'color', 'k', ...
        'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
        'FontSize',[7],'FontWeight','bold')
end
clear i
for i = 1:size(h2,1)-1
%         text(370, i*(maximo./(size(h2,1)-1)), sprintf('%4.2f', sum(h2(i,:))), 'color', 'k', ...
%         'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
%         'FontSize',[7],'FontWeight','bold')
%     text(370, i*(maximo./(size(h2,1)-1))-.25*mean(diff(hspoty(:,1))), sprintf('%4.2f', sum(h2(i,:))), 'color', 'k', ...
%         'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
%         'FontSize',[7],'FontWeight','bold')
text(370, hypos(1)+(i-1)*mode(diff(hypos)), sprintf('%4.2f', sum(h2(i,:))), 'color', 'k', ...
        'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
        'FontSize',[7],'FontWeight','bold')
end
clear i
text(370, -.015*maximo, sprintf('%4.2f', sum(sum(h2))), 'color', 'k', ...
    'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
    'FontSize',[7],'FontWeight','bold')
set(gca,'YTick',ybin,'YTickLabel',num2str(ybin'));
p=local;
title(['Histograma direcional de correntes em ' p ' - Célula ' num2str(celula)],'FontSize',12);

cb = colorbar;
totalNumber=numel(direcao);
percentGood = 100*length(find(~isnan(direcao)))/totalNumber;

xlabel({'Direção da corrente (graus)'; ...
    ['Total de amostras = ' num2str(length(find(~isnan(velocidade))), '%.0f') ...
    ', ' num2str(percentGood, '%.1f') '% das Observações Possíveis']})
ylabel('Velocidade da corrente (m/s)')
ylabel(cb,'Porcentagem')
print('-dpng', [caminho '\Hist_cor_' local '_celula_' num2str(celula) '.png'],'-r300');


close
end
