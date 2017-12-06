function plota_dpo(vel,dir,celula,nome)

D=0:180:360;
V=0:0.1:nanmax(vel);
vnum=numel(V);

    for j=1:numel(V)-1
    v(j)=numel(vel(vel >= V(j) & vel < V(j+1)));
    if vel(end) >= V (end)
       v(vnum)=numel(vel(end) >= v (end)); 
    end
    end

    for i=1:numel(D)-1
    d(i)=numel(dir(dir >= D(i) & dir < D(i+1)));
    if dir(end) >= D (end)
       d(end+1)=numel(dir(end) >= D (end)); 
    end
    end
    
[TH,R] = meshgrid(d,v);
[X,Y] = pol2cart(TH,R);
    
h = polar([0 2*pi], [0 1]);
delete(h)
hold on
contour(X,Y)

end

