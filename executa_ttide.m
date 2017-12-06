function [NAME,FREQ,TIDECON,XOUT]=executa_ttide(data,ele,intervalo)
[NAME,FREQ,TIDECON,XOUT]=T_TIDE(ele,'interval',intervalo,'start time',...
    data(1),'synthesis',0,'shallow',['K2']);

k1=0.0883;
o1=0.0538;
m2=0.9558;
s2=0.2589;
n2=0.1691;
k2=0.0721;
s0=2.72;
pause
C=(k1+o1)/(m2+s2);
if C<=0.25
    disp ('Maré semidiurna')
    nr=s0-(m2+s2+n2+k2)
end

end