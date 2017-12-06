function plota_rosa_corr(vel_cel,dir_cel,local,caminho,celula,maximo)

[u,v]=veldir2uv(vel_cel,dir_cel);
% 
fHand = figure;
aHand = axes('parent', fHand);
% % Make sure limits are correct.
pHand = polar(0, maximo, 'parent', aHand);
delete(pHand)

hold on;
compass (u(:,1),v(:,1))
title(['Gráfico polar de correntes em ' local ' - Célula ' num2str(celula)])
set(findall(gcf, 'String', '0'),'String', ' 90'); 
set(findall(gcf, 'String', '30'),'String', ' 60'); 
set(findall(gcf, 'String', '60'),'String', ' 30'); 
set(findall(gcf, 'String', '90'),'String', ' 0'); 
set(findall(gcf, 'String', '120'),'String', ' 330'); 
set(findall(gcf, 'String', '150'),'String', ' 300'); 
set(findall(gcf, 'String', '180'),'String', ' 270'); 
set(findall(gcf, 'String', '210'),'String', ' 240'); 
set(findall(gcf, 'String', '240'),'String', ' 210'); 
set(findall(gcf, 'String', '270'),'String', ' 180'); 
set(findall(gcf, 'String', '300'),'String', ' 150'); 
set(findall(gcf, 'String', '330'),'String', ' 120'); 

% Get the handles of interest (using volatile info above).
% hands = findall(fHand,'parent', aHand, 'Type', 'text');
% hands = hands(strncmp('  ', get(hands,'String'), 2));
% hands = sort(hands);
% pause
% % Relabel from inside out.
% labels = {'','','',''}
% for i = 1:4
%   set(hands(i),'String', labels{i})
% end
% escala={0.2,0.4,0.6,0.8}
% for i=escala
%     text(i,90,'sdfg')
% end

if maximo>=1.5
     arrow([maximo+.6 -.2],[maximo+1.1 -.2],'Length',4)
text(maximo+.7,-.3,'0.5 m/s','fontsize',8)
elseif maximo>=1 && maximo<1.5
     arrow([1.5+.3 -.2],[1.5+.6 -.2],'Length',4)
text(1.5+.3,-.25,'0.3 m/s','fontsize',6)
elseif maximo>0.8 && maximo<1
    arrow([maximo+.3 -.2],[maximo+.5 -.2],'Length',8)
text(maximo+.3,-.25,'0.2 m/s','fontsize',6)
elseif maximo >=0.6 && maximo <=0.8
 arrow([maximo+.3 -.2],[maximo+.4 -.2],'Length',8)
text(maximo+.3,-.25,'0.1 m/s','fontsize',6)
elseif maximo >0.3 && maximo <=0.6
arrow([maximo+.2 0.01],[maximo+.3 0.01],'Length',8)
text(maximo+.2,.04,'0.1 m/s')
elseif maximo >0.2 && maximo <=0.3
arrow([maximo+.1 0.01],[maximo+.15 0.01],'Length',8)
text(maximo+.1,.03,'0.05 m/s')
else 
    arrow([maximo+.05 0],[maximo+.075 0],'Length',8)
text(maximo+.05,.015,'0.25 m/s')

end

print('-dpng', [caminho '\GraficoPolar_' local '_celula_' num2str(celula) '.png'],'-r300');
close

end
