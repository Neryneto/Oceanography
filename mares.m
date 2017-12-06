registro=[Record;Record1;Record2];
elevacao=[TideLevel;TideLevel1;TideLevel2];
pressao=[TidePressure;TidePressure1;TidePressure2]
horario=[TimetagGmt;TimetagGmt1;TimetagGmt2];

registro=[registro;Record3];
elevacao=[elevacao;TideLevel3];
pressao=[pressao;TidePressure3];
horario=[horario;TimetagGmt3];

plot (TimetagGmt,TidePressure)
hold on
plot (TimetagGmt1,TidePressure1,'r')
plot (TimetagGmt2,TidePressure2,'k')
plot (TimetagGmt3,TidePressure3,'g')
data=horario;
xlim([data(1,1)-1 data(end,1)+1]);
data_ini=floor(data(1,1));
data_fim=ceil(data(end,1));
xtickss=floor(data_ini):10:ceil(data_fim);
set(gca,'XTick',xtickss);

datetick('x','dd/mm','keepticks','keeplimits')
set(gca,'fontsize',8)
ylabel({'Tide elevation (m)'},'fontsize',8)
% ylim([-.15 0.45])
title(['Tide Pressure in Guamaré between ' datestr(data(1,1),'dd/mm/yyyy') ' and ' datestr(data(end,1),'dd/mm/yyyy')],'FontSize',14);
grid on
% pp=legend('Hobo U-30','RTK Tide','location','Best','Orientation','Horizontal')
% set(pp,'Fontsize',7)
ylabel('Tide Pressure (kPa)')
print('-dpng',['I:\Trabalhos\mares\tidePressure_guamare.png']);
