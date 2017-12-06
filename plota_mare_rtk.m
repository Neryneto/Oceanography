function plota_mare_rtk (data,radar,data_rtk,rtk,nome_figura,nome_arquivo)

difer=diff(data_rtk);
[l c]=find(difer>1/24); 
l(end+1,1)=numel(rtk);
rtk_fim=[];data_rtk_fim=[];

if isempty(l)==0;
for i=1:size(l,1)
 eval(['a' num2str(i) '=[];']);eval(['b' num2str(i) '=[];'])
  if i==1
     eval(['a' num2str(i) '=data_rtk(1:l(' num2str(i) '));'])
     eval(['b' num2str(i) '=rtk(1:l(' num2str(i) '));'])
 elseif i>=2 && i<=7
     eval(['a' num2str(i) '=data_rtk(l(' num2str(i) '-1):l(' num2str(i) '));'])
     eval(['b' num2str(i) '=rtk(l(' num2str(i) '-1):l(' num2str(i) '));'])
     eval(['a' num2str(i) '(1)=nan;'])
     eval(['b' num2str(i) '(1)=nan;'])
 else
     eval(['a' num2str(i) '=data_rtk(l(' num2str(i) '):end);'])
     eval(['b' num2str(i) '=rtk(l(' num2str(i) '):end);'])
     eval(['a' num2str(i) '(1)=nan;'])
     eval(['b' num2str(i) '(1)=nan;'])
 end
 eval(['rtk_fim=[rtk_fim;b' num2str(i) '];'])
 eval(['data_rtk_fim=[data_rtk_fim;a' num2str(i) '];'])
 end

clear rtk data_rtk
rtk=rtk_fim; data_rtk=data_rtk_fim;
end
subplot(2,1,1)
plot (data,radar,'Color',[0 0 1],'LineWidth',1)
% plot (data,radar,'LineWidth',1)
hold on
plot (data_rtk,rtk,'Color',[1 0 0],'LineWidth',1.2)
% plot (data_rtk,rtk,'r','LineWidth',1.2)
xlim([data(1,1)-1 data(end,1)+1]);

data_ini=floor(data(1,1));
data_fim=ceil(data(end,1));
if (data_ini-data_fim)==~0
aux_data=data_ini:data_fim;
xtickss=aux_data(1:200:end);
set(gca,'XTick',xtickss);
%para menos de um dia
else
xtickss=floor(data_ini):5:ceil(data_fim);
set(gca,'XTick',xtickss);
end
datetick('x','mm/dd','keepticks','keeplimits')
set(gca,'fontsize',8)
ylabel({'Pressure (kPa)'},'fontsize',8)
ylim([1 5])
title(['Dados de maré em ' nome_figura ' entre ' datestr(data(1,1),'dd/mm/yyyy') ' e ' datestr(data(end,1),'dd/mm/yyyy')],'FontSize',14);
grid on
pp=legend('Hobo U-30','RTK Tide','location','Best','Orientation','Horizontal')
set(pp,'Fontsize',7)
print('-dpng',['I:\Trabalhos\mares\' nome_arquivo '.png']);
% close all

end

