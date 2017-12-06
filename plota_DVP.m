function f_vecDiagram(vel,dir,theta,units,jdate,celula,local,caminho)

%Rotina criada por Nery para plotar Diagrama Vetorial Progressivo. A rotina 
%foi criada a partir da rotina f_vecDiagram (pacote FATHOM)

% - plot progressive vector diagrams
%
% USAGE: f_vecDiagram(u,v,theta,units,jdate)
%
% u,v    = vector components
% theta  = angle to rotate vectors ccw (default = 0)
% units  = m/s (1) or cm/s (2)         (default = 0)
% jdate  = Julian dates corresponding to u,v
%
% See also: f_vecPlot

% ----- Notes: -----
% This function is used to create progressive vector diagrams from time
% series data of wind or moored current meter velocity vectors. This type
% of diagram is used to produce a Lagrangian display of Eulerian
% measurements.

% UNITS is an optional parameter that allows calculation of the spatial
% units in the plot. A velocity vector specifying 1 m/s covers 3.6 km/hr
% (there is 3600 s in an hour).
%
% JDATE is an optional column vector of Julian dates corresponding to U,V.
% If provided plot symbols will only be drawn for vectors corresponding to
% whole Julian dates.
%
% The aspect ratio of the plot should provide an indication of the relative
% contribution of the U vs. V components to the net displacement. Note that
% the starting position of the diagram is the origin (0,0).

% ----- Author: -----
% by David L. Jones, Dec-2002
% 
% This file is part of the FATHOM Toolbox for Matlab and
% is released under the GNU General Public License, version 2.

% Oct-2003: optional angle of rotation (theta), updated documentation,
%           optionally plot symbols for only whole Julian dates
% Mar-2008: used logical indexing vs. find; set bg color


% ----- Check input & set defaults: -----
direction=mod(90-dir,360)
if dir<0
    direction=90-dir;
elseif(dir>=0.0 & dir<=90.0)
    direction= 90.0-dir;
elseif(dir>90.0)
    direction=450-dir;
end

[u,v]=veldir2uv(vel,dir)

u = inpaint_nans(u,1); % force column vector
v = inpaint_nans(v,1);

if (size(u,2)~=1)
	error('U & V must be column vectors!');
end

if (size(u) ~= size(v))
	error ('U & V must be same size!');	
end

if (nargin < 3), theta  = 0; end; % no vector rotation
if (nargin < 4), units  = 0; end; % no units provided

if (nargin < 5)
   pltAll = 1;       % plot symbols for all data
else
   pltAll = 0;       % only plot symbols for whole Julian dates
   jdate = jdate(:); % force column vector
   if size(jdate,1) ~= size(u,1)
      error('JDATE must have same # ROWS as U,V!');   
   end
end;

if theta<0, error('THETA must an angle in POSITIVE degrees!'); end
% ---------------------------------------

% Determine spatial scale of diagram:
switch units
case 0 % no units
case 1 % m/s
	u = u*3.6;
	v = v*3.6;
case 2 % cm/s
	u = u*0.036;
	v = v*0.036;
otherwise
	error('Unsupported UNITS');	
end

% nr = size(u,1);

tail = cumsum([[0 0];[u v]]);  % start from the origin
head = [tail(2:end,:);[NaN NaN]];

figure;
set(gcf,'color','w'); % set bg color to white
hold on;

% Plot symbols at tail:
   plot(tail(:,1),tail(:,2),'b','LineWidth',2);
hold on   
   plot(tail(1:48:end,1),tail(1:48:end,2),'r.','MarkerSize',15);
   plot(tail(1,1),tail(1,2),'dk','MarkerSize',10,'MarkerFaceColor','k')
title(['Diagrama Vetorial Progressivo em ' local ' - Célula ' num2str(celula)],'fontsize',12);

	xlabel('Deslocamento no eixo L - O (m)');
	ylabel('Deslocamento no eixo N - S (m)');

% Adjust appearance of plot:
set(gcf,'color','w');
grid on;
box on;
% % daspect([1 1 1]);
xlim([-1600 100])
ylim([-50 350])

hold off;
print('-dpng',[caminho '\DVP_' local '_celula_' num2str(celula) '.png'],'-r300');

close all
end