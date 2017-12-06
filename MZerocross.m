function [Periods,Heights]=MZerocross(D)
% 
%   Function for to calculate wave heights and wave periods
%   using zerocrossing method.
%  
%   This method require to take out the mean to elevation data
%   for will analyze the sign change. The height is define
%   like the diference between the maximum and the minimum 
%   between the portion of record between two successive zero
%   upcrossings or downcrossing.
%   Any height that not comply with this restriction, it
%   is considerate no existed.
%
%  Input: 
%           D = Matrix with two colums.
%               First colum is Time.
%               Second column is the elevation.
%  Output:
%            H = Wave heights
%            T = zero-crossing period 
% Example:
%         t=[0:pi/16:6.5*pi]';   % Note that is a column
%         y=sin(t);
%         D=[t,y],
%         [T,H]=MZerocross(D)
%       
% Answer:
%        T =
%            6.2832 6.2832 6.2832
%
%        H =
%
%           2     2     2
%
%
%   Created by R. Hernandez-Walls 
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Ensenada, Baja California
%             Mexico.
%             rwalls@uabc.edu.mx
%
%   To cite this file, this would be an appropriate format:
%
%   Hernandez-Walls, R. (2012).
%   MZerocross:Zerocrossing Method. A MATLAB file.
%   http://www.mathworks.com/matlabcentral/fileexchange/
%
%   References:
%
%
%
%
D(:,2)=D(:,2)-mean(D(:,2)); 
iD=find(diff(sign(D(:,2)))==2);
iD2=find(diff(sign(D(:,2)))==-2);
if length(iD)<length(iD2), iD=iD2; end
k=1:length(iD)-1;
Heights(k)=max(D(iD(k):iD(k+1),2))-min(D(iD(k):iD(k+1),2));
Periods(k)=max(D(iD(k):iD(k+1),1))-min(D(iD(k):iD(k+1),1));
%return