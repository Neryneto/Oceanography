function [A,hits]=binsort(x,y,z,xbin,ybin)
%BINSORT sorts variable z into bins defined by variables x and y
%
%[A,hits]=binsort(x,y,z,xbin,ybin)
%
% INPUT:
%			x independent variable
%			y independent variable
%			z dependent variable to be sorted
%			xbin vector containing upper limits of x bins
%			ybin vector containing upper limits of y bins
%			
% OUTPUT:
%			A the mean value of z in this bin
%			hits the percentage of values in this bin
%			
% By Fran Hotchkiss in MATLAB 3.3 in the early '90s
% Copied and modified by Ben Gutierrez 2/10/2000
np = length(x);
if (length(y)~=np | length(z)~=np),
   disp('Number of points in x,y,z must be the same!!!')
end

%Number of bins
nxbins = length(xbin)+1;
nybins = length(ybin)+1;
A = zeros(nybins-1,nxbins-1);
hits = zeros(nybins-1,nxbins-1);


xb = -Inf;
xb(2:nxbins) = xbin;
xb(nxbins+1) = Inf;
xb


yb = -Inf;
yb(2:nybins) = ybin;
yb(nybins+1) = Inf;
h = 0;
for i = 1:nxbins-1,
   for j = 1:nybins-1,
      ind = find(xb(i)<x & x<=xb(i+1) & yb(j)<y & y<=yb(j+1));
      h = h + length(ind);
      if (length(ind)~=0)
         A(j,i) = mean(z(ind));				% the mean of the points in this box
      else
         A(j,i) = 0;
      end
      hits(j,i) = (length(ind)/np)*100;  	%percentage of data that falls 
   end												% in this box
end

h,np

if h ~= np, disp('h does not equal np!'),end