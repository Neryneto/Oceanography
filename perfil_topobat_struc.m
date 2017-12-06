arquivo.caminho{1,1} = 'Y:\15.038.411 (Shore Approach)\2-Topobatimetria\RAC_Jan16\Cabiúnas\R1';
arquivo.caminho{2,1} = 'Y:\15.038.411 (Shore Approach)\2-Topobatimetria\RAC_Jan16\Cabiúnas\R5';
arquivo.caminho{3,1} = 'Y:\15.038.411 (Shore Approach)\2-Topobatimetria\RAC_Jan16\Cabiúnas\R12';
arquivo.caminho{4,1} = 'Y:\15.038.411 (Shore Approach)\2-Topobatimetria\RAC_Jan16\Cabiúnas\R25';
str=[{'Latitude'};{'Longitude'}];
[latlong,ok]=listdlg('PromptString','Ordenar por: ','ListString',str);
format=['%f64 %f64 %f64'] ;

%para serra colocar ascend, deixar o cálculo de arquivo.perfil positivo
%para cabiúnas e jaconé colocar descend, mudar o cálculo de arquivo.perfil negativo
for i=1:size(arquivo.caminho,1)
arquivo.titulografico{i,1}=arquivo.caminho{i,1}(end-1:end);
arquivo.AllFile = dir(fullfile(arquivo.caminho{i,1},'*.xyz'));

for m=1:size(arquivo.AllFile,1)
[fid, errormsg] = fopen([arquivo.caminho{i,1} '\' arquivo.AllFile(m,1).name],'r+');
arquivo.arquivos{m,i} = textscan(fid,format);
if latlong==1
arquivo.lat_dist{m,i}=[arquivo.arquivos{m,i}{1,2} arquivo.arquivos{m,i}{1,3}];
elseif latlong==2
    arquivo.lat_dist{m,i}=[arquivo.arquivos{m,i}{1,1} arquivo.arquivos{m,i}{1,3}];
end

[arquivo.Y{m,i},arquivo.I{m,i}]=sort(arquivo.lat_dist{m,i}(:,1),'descend');
arquivo.perfil{m,i}=arquivo.lat_dist{m,i}(arquivo.I{m,i},:);
arquivo.perfil{m,i}(1,3:4)=0;

for tamanho=2:length(arquivo.perfil{m,i})
    arquivo.perfil{m,i}(tamanho,3)=-(arquivo.perfil{m,i}(tamanho,1)-arquivo.perfil{m,i}(tamanho-1,1));
    arquivo.perfil{m,i}(tamanho,4)=arquivo.perfil{m,i}(tamanho-1,3)+arquivo.perfil{m,i}(tamanho-1,4);
end
if arquivo.perfil{m,i}(tamanho,4)<0
for tamanho=2:length(arquivo.perfil{m,i})
    arquivo.perfil{m,i}(tamanho,3)=-(arquivo.perfil{m,i}(tamanho,1)-arquivo.perfil{m,i}(tamanho-1,1));
    arquivo.perfil{m,i}(tamanho,4)=arquivo.perfil{m,i}(tamanho-1,3)+arquivo.perfil{m,i}(tamanho-1,4);
end
end

clear arquivo.Y arquivo.I;
if m==1
figure(i);
end

subplot(2,1,1)
if m==1
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'linewidth',1.2);
elseif m==2 
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'r','linewidth',1.2);
elseif m==3
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'k','linewidth',1.2);
elseif m==4
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'g','linewidth',1.2);   
end
hold on

subplot(2,1,2)
if m==1
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'linewidth',1.2);
elseif m==2 
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'r','linewidth',1.2);
elseif m==3
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'k','linewidth',1.2);
elseif m==4
plot(arquivo.perfil{m,i}(:,4),-arquivo.perfil{m,i}(:,2),'g','linewidth',1.2);   
end
hold on

end
clear fid errormsg 

subplot(2,1,1)
grid on
ylabel('Profundidade (m)')
xlabel('Distância (m)')
title(['Remove Heave Drift (RHD) = ' arquivo.titulografico{i}])
% p=get(gca,'XTick')';
% set(gca,'XTick',p,'XTickLabel',-p);
% set(gca,'XDir','Reverse')
% set(gca,'XDir','Reverse')
% xlim([0 2100]) %Jaconé
% xlim([0 1200]) %Serra
xlim([0 2500]) %Serra
% xlim([-5100 0]) %Guamaré
hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','NorthEast','FontSize',6);
% hh=legend({'RHD 1';'RHD 5';'RHD 25'},'Orientation', 'horizontal','Location','NorthEast','FontSize',6,'boxoff');

subplot(2,1,2)
ylabel('Profundidade (m)')
xlabel('Distância (m)')
% title('Remove Heave Drift (RHD) - Serra')
title(['Remove Heave Drift (RHD) = ' arquivo.titulografico{i}])% xlim([arquivo.perfil3(600,4) arquivo.perfil3(800,4)])
% xlim([800 1200]) %Jaconé
% xlim([700 1060]) %Serra
% xlim([-4000 -3800]) %Guamaré
xlim([800 1200]) %Serra
% ylim([-6 -3])
p=get(gca,'XTick');
% pp=0:50:4000;
% set(gca,'XTick',fliplr(-pp),'XTickLabel',fliplr(pp));
% set(gca,'XDir','Reverse')

grid on
hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','SouthWest','FontSize',6);
% hh=legend({'RHD 1';'RHD 5';'RHD 25'},'Orientation', 'horizontal','Location','SouthEast','FontSize',6,'boxoff');
% print('-dpng',[arquivo.caminho{i} '\RHD_novo_' arquivo.titulografico{i}],'-r300')
print('-dpng',[arquivo.caminho{i} '\RHD_novo_' arquivo.titulografico{i}],'-r300')

end
close all
%%

%para calcular a distância
% dist=[];
% dist2=[];
% for i=1:size(AllFile,1)
%     A1{i,2}(:,2)=sort(A1{i,2}(:,1))
%  
% 
%   for j=1:size(A1{i,1},1)-1
%  A1{i,2}(j,3)=(A1{i,2}(j+1,1)-A1{i,2}(j,1));
%   end
%   
%   if any(A1{i,2}(:,3)>250)
%      [l,c]=find(A1{i,2}(:,3)>250);
%      perfil_sup(:,1)=A1{i,1}(1:l,1);perfil_sup(:,2)=A1{i,2}(1:l,2);
% perfil_inf(:,1)=A1{i,1}(l+1:end,1);perfil_inf(:,2)=A1{i,2}(l+1:end,2);
% dist(i,1)=sqrt(((perfil_sup(1,1)-perfil_sup(end,1))^2)+((perfil_sup(1,2)-perfil_sup(end,2))^2));
% dist(i,2)=sqrt(((perfil_inf(1,1)-perfil_inf(end,1))^2)+((perfil_inf(1,2)-perfil_inf(end,2))^2));   
%   else
%      for j=1:size(A1{i,1},1)-1
%      dist(i,1)=sqrt(((A1{i,1}(1,1)-A1{i,1}(end,1))^2)+((A1{i,2}(1,2)-A1{i,2}(end,2))^2));
%      dist(i,2)=nan;
%      end
%   end
%  clear perfil_inf perfil_sup l c
% 
% 
% end

%%
%para plotar



% close all


