caminho = 'Y:\15.038.411 (Shore Approach)\2-Topobatimetria\RAC_Jan16\Serra\Steer Sounding Beam';
AllFile = dir(fullfile(caminho,'*.xyz'));

for i=1:size(AllFile,1)
[fid, errormsg] = fopen([caminho '\' AllFile(i,1).name],'r+');
format=['%f64 %f64 %f64'] ;
A1(i,:) = textscan(fid,format);
end

clear fid errormsg

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
distPlot=[];
for i=1:4
    eval(['lat_dist_' num2str(i) '=[];'])
eval(['lat_dist_' num2str(i) '=[A1{' num2str(i) ',2} A1{' num2str(i) ',3}];'])
eval(['[Y_' num2str(i) ',I_' num2str(i) ']=sort(lat_dist_' num2str(i) '(:,1),''ascend'');'])
eval(['perfil_' num2str(i) '=zeros(length(lat_dist_' num2str(i) '),2);'])
eval(['perfil_' num2str(i) '=lat_dist_' num2str(i) '(I_' num2str(i) ',:);'])
eval(['perfil_' num2str(i) '(1,3:4)=0;'])
end

for j=2:length(perfil_1)
    perfil_1(j,3)=(perfil_1(j,1)-perfil_1(j-1,1));
    perfil_1(j,4)=perfil_1(j-1,3)+perfil_1(j-1,4);
end


for j=2:length(perfil_2)
    perfil_2(j,3)=(perfil_2(j,1)-perfil_2(j-1,1));
    perfil_2(j,4)=perfil_2(j-1,3)+perfil_2(j-1,4);
end


for j=2:length(perfil_3)
    perfil_3(j,3)=(perfil_3(j,1)-perfil_3(j-1,1));
    perfil_3(j,4)=perfil_3(j-1,3)+perfil_3(j-1,4);
end


for j=2:length(perfil_4)
    perfil_4(j,3)=(perfil_4(j,1)-perfil_4(j-1,1));
    perfil_4(j,4)=perfil_4(j-1,3)+perfil_4(j-1,4);
end

a=figure;
subplot(2,1,1)
plot(perfil_1(:,4),-perfil_1(:,2),'linewidth',1.2);
hold on
plot(perfil_2(:,4),-perfil_2(:,2),'r','linewidth',1.2);
plot(perfil_3(:,4),-perfil_3(:,2),'k','linewidth',1.2);
plot(perfil_4(:,4),-perfil_4(:,2),'g','linewidth',1.2);

grid on
% xlim([0 5100]) %Guamaré
xlim([0 4000]) %Guamaré

ylabel('Profundidade (m)')
xlabel('Distância (m)')
% p=get(gca,'XTick')';
% set(gca,'XTick',p,'XTickLabel',-p);
% set(gca,'XDir','Reverse')
title('Remove Heave Drift (RHD) - Serra')

hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','NorthEast','FontSize',6,'boxoff');
% hh=legend({'RHD 1';'RHD 5';'RHD 12';'RHD 25'},'Orientation', 'horizontal','Location','NorthEast','FontSize',6,'boxoff');
% print('-dpng',[caminho '\RHD_'],'-r300')

subplot(2,1,2)
plot(perfil_1(:,4),-perfil_1(:,2),'linewidth',1.2);
hold on
plot(perfil_2(:,4),-perfil_2(:,2),'r','linewidth',1.2);
plot(perfil_3(:,4),-perfil_3(:,2),'k','linewidth',1.2);
plot(perfil_4(:,4),-perfil_4(:,2),'g','linewidth',1.2);
grid on

ylabel('Profundidade (m)')
xlabel('Distância (m)')
p=get(gca,'XTick');
pp=0:50:4000;
% set(gca,'XTick',fliplr(-pp),'XTickLabel',fliplr(pp));
% set(gca,'XDir','Reverse')
title('Remove Heave Drift (RHD) - Serra')
% xlim([perfil_3(600,4) perfil_3(800,4)])
xlim([700 1050]) %Serra
% xlim([3800 4000]) %Guamaré
% ylim([-6 -2])
% set(gca,'XDir','Reverse')
% grid on
hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','SouthEast','FontSize',6,'boxoff');
% hh=legend({'RHD 1';'RHD 5';'RHD 12';'RHD 25'},'Orientation', 'horizontal','Location','SouthWest','FontSize',6,'boxoff');
% p=get(gca,'XTick')';
% set(gca,'XTick',p,'XTickLabel',-p);
% set(gca,'XDir','Reverse')
print('-dpng',[caminho '\RHD_Serra'],'-r300')

% close all


