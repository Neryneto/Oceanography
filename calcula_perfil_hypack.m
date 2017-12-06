caminho = 'Y:\15.038.411 (Shore Approach)\2-Topobatimetria\RAC_Jan16\Serra\P05B\R25';
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
eval(['[Y_' num2str(i) ',I_' num2str(i) ']=sort(lat_dist_' num2str(i) '(:,1));'])
eval(['perfil_' num2str(i) '=zeros(length(lat_dist_' num2str(i) '),2);'])
eval(['perfil_' num2str(i) '=lat_dist_' num2str(i) '(I_' num2str(i) ',:);'])
eval(['perfil_' num2str(i) '(1,3:4)=0;'])
end

for j=2:length(perfil_1)
    perfil_1(j,3)=perfil_1(j,1)-perfil_1(j-1,1);
    perfil_1(j,4)=perfil_1(j-1,3)+perfil_1(j-1,4);
end


for j=2:length(perfil_2)
    perfil_2(j,3)=perfil_2(j,1)-perfil_2(j-1,1);
    perfil_2(j,4)=perfil_2(j-1,3)+perfil_2(j-1,4);
end


for j=2:length(perfil_3)
    perfil_3(j,3)=perfil_3(j,1)-perfil_3(j-1,1);
    perfil_3(j,4)=perfil_3(j-1,3)+perfil_3(j-1,4);
end


for j=2:length(perfil_4)
    perfil_4(j,3)=perfil_4(j,1)-perfil_4(j-1,1);
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

ylabel('Profundidade (m)')
xlabel('Distância (m)')
title('Remove Heave Drift (RHD) = 25')

grid on
hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','SouthEast','FontSize',6,'boxoff');
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
title('Remove Heave Drift (RHD) = 25')
xlim([perfil_4(600,4) perfil_4(800,4)])
grid on
hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','SouthEast','FontSize',6,'boxoff');
% hh=legend({'Smooth 0';'Smooth 13';'Smooth 32';'Smooth 64'},'Orientation', 'horizontal','Location','SouthEast','FontSize',6,'boxoff');
print('-dpng',[caminho '\RHD_'],'-r300')

close all


