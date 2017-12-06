function calcula_mare(tempo,ele)

% infername=['K2'];inferfrom=['S2'];infamp=[.27215];
%        infphase=[-7.07;-22.40];
       
       % The call (see t_demo code for details).
       [tidestruc,pout]=t_tide(elevacao,...
       'interval',1/6, ...                   % 1=1 hora
       'start',data(1),...               % start time is datestr(tuk_time(1))
       'latitude',-(5+2/60),...               % Latitude of obs%        'inference',infername,inferfrom,infamp,infphase      
       'shallow','K2',...                   % Add a shallow-water constituent 
       'error','linear',...                   % coloured boostrap CI
       'synthesis',1);                       % Use SNR=1 for synthesis. 
   
% [NAME,FREQ,TIDECON,XOUT]=t_tide(ele,'start time',tempo(1),'interval',(mode(diff(tempo(:,1)))*24),'shallow','K2');
% [NAME,FREQ,TIDECON,XOUT]=t_tide(ele,'start time',tempo(1),'interval',mode(diff(tempo(:,1)))*24,'synthesis',1);

x0=2.83;
k1=0.0431;
o1=0.0601;
m2=0.9317;
s2=0.2890;
c=(k1+o1)/(m2+s2)
n2=0.1884;
k2=0.1016;
nr=x0-(m2+s2+n2+k2)

f=figure(1)
subplot(2,1,1)
plot(tempo,ele-2.931)
xlim([tempo(1,1)-1 tempo(end,1)+1]);

data_ini=floor(tempo(1,1));
data_fim=ceil(tempo(end,1));
if (data_ini-data_fim)==~0
aux_data=data_ini:data_fim;
xtickss=aux_data(1:16:end);
%para menos de um dia
else
xtickss=floor(data_ini):5:ceil(data_fim);
set(gca,'XTick',xtickss);
end
datetick('x','dd/mm','keepticks','keeplimits')
set(gca,'fontsize',8)
ylabel({'Elevação (m)'},'fontsize',8)
% ylim([-.5 0])
title(['Maré medida em ST004 - Nivelamento IBGE'],'FontSize',14);
grid on
pp=legend('NR IBGE = 2.931','location','NorthWest','Orientation','Horizontal')
set(pp,'Fontsize',7)

subplot(2,1,2)
plot(tempo,ele-x0,'r')
xlim([tempo(1,1)-1 tempo(end,1)+1]);

data_ini=floor(tempo(1,1));
data_fim=ceil(tempo(end,1));
if (data_ini-data_fim)==~0
aux_data=data_ini:data_fim;
xtickss=aux_data(1:16:end);
%para menos de um dia
else
xtickss=floor(data_ini):5:ceil(data_fim);
set(gca,'XTick',xtickss);
end
datetick('x','dd/mm','keepticks','keeplimits')
set(gca,'fontsize',8)
ylabel({'Elevação (m)'},'fontsize',8)
% ylim([-.5 0])
title(['Maré medida em ST004 - Nivelamento DHN'],'FontSize',14);
grid on
pp=legend('NR DHN = 1.319','location','NorthWest','Orientation','Horizontal')
set(pp,'Fontsize',7)
caminho='I:\Trabalhos\1-Oceanografia\2-Guamaré(RN)_Correntômetro\6ªCampanha_Jul_2016\7-Relatório\Anexos\Anexo 5 - Figuras\ST004';
print('-dpng',[caminho '\ST004.png']);
end