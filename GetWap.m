%	This file simply reads in the processed wave data from the 
%	QuickWave software.  This reads data from both AWAC and Nortek 
%   PUV instruments (Vector, Aquadopp, Aquadopp Profier)
%
%	WAPdata = getwap(pname,fname);  
%   or the following to use GUI for file selection
%	WAPdata = getwap;  
%      
%
%	pname: Pathname ie 'c:\data\'
%	fname: Filename ie 'someawacdata.wap'
%
%
%	Structure output is as folows:
%
%WAPdata.Month = data(:,1)';
%WAPdata.Day  = data(:,2)';
%WAPdata.Year = data(:,3)';
%WAPdata.Hour  = data(:,4)';
%WAPdata.Minute = data(:,5)';
%WAPdata.Second = data(:,6)';
%WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
%WAPdata.Hs= data(:,7)';
%WAPdata.Tm02= data(:,8)';
%WAPdata.Tp= data(:,9)';
%WAPdata.PeakDir= data(:,10)';
%WAPdata.Sprd1= data(:,11)';
%WAPdata.MainDirr= data(:,12)';
%WAPdata.UI= data(:,13)';


% No arguments input necesary.  You are simply prompted to find the file
% using a browser.


function [WAPdata] = getwap(pname,fname)


if (nargin>0)
   file2Get = [pname,fname];
else
   %eval('cd c:\data')
   %eval('load lastdirectory')
   %eval(['cd ',pname])
   [fname,pname] = uigetfile('*.wap','Go and Get that WAP file');
   %eval('cd c:\data')
   %save lastdirectory pname
   file2Get = [pname,fname];
end

%save lastdirectory pname
WAPdata.file2Get =file2Get;

%	Read in the AWAC processed data
%	-------------------------------
%data = dlmread(file2Get,' ');
data = dlmread(file2Get);
[rw,cl] = size(data);
if (cl==1 )
   data = dlmread(file2Get,'\t');
	[rw,cl] = size(data);
end
   


%Postwave PUV and MLM output
if (cl == 17)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.Hs = data(:,7)';
WAPdata.Tm02 = data(:,8)';
WAPdata.Tp = data(:,9)';
WAPdata.PeakDir = data(:,10)';
WAPdata.Sprd1 = data(:,11)';
WAPdata.MeanDir = data(:,12)';
WAPdata.UI = data(:,13)';
WAPdata.MeanPres = data(:,14)';
WAPdata.CurSpeed = data(:,15)';
WAPdata.CurDir = data(:,16)';
WAPdata.Err = data(:,17)';
WAPdata.method = 'puv';
end


%Postwave PUV and MLM output
if (cl == 15)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.Hs = data(:,7)';
WAPdata.Tm02 = data(:,8)';
WAPdata.Tp = data(:,9)';
WAPdata.PeakDir = data(:,10)';
WAPdata.Sprd1 = data(:,11)';
WAPdata.MeanDir = data(:,12)';
WAPdata.UI = data(:,13)';
WAPdata.MeanPres = data(:,14)';
WAPdata.Err = data(:,15)';
WAPdata.method = 'puv';
end








% from AWAC
if(cl == 23)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.Hs = data(:,7)';
WAPdata.H3 = data(:,8)';
WAPdata.H10 = data(:,9)';
WAPdata.Hmax = data(:,10)';
WAPdata.Tm02 = data(:,11)';
WAPdata.Tp = data(:,12)';
WAPdata.Tmean = data(:,13)';
WAPdata.PeakDir = data(:,14)';
WAPdata.Sprd1 = data(:,15)';
WAPdata.MeanDir = data(:,16)';
WAPdata.UI = data(:,17)';
WAPdata.MeanPres = data(:,18)';
WAPdata.NoDet = data(:,19)';
WAPdata.BadDet = data(:,20)';
WAPdata.CurSpeed = data(:,21)';
WAPdata.CurDir = data(:,22)';
WAPdata.Err = data(:,23)';
WAPdata.method = 'AST';
end





% from AWAC
if(cl == 24)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.SpecUsed = data(:,7)';
WAPdata.Hs = data(:,8)';
WAPdata.H3 = data(:,9)';
WAPdata.H10 = data(:,10)';
WAPdata.Hmax = data(:,11)';
WAPdata.Tm02 = data(:,12)';
WAPdata.Tp = data(:,13)';
WAPdata.Tmean = data(:,14)';
WAPdata.PeakDir = data(:,15)';
WAPdata.Sprd1 = data(:,16)';
WAPdata.MeanDir = data(:,17)';
WAPdata.UI = data(:,18)';
WAPdata.MeanPres = data(:,19)';
WAPdata.NoDet = data(:,20)';
WAPdata.BadDet = data(:,21)';
WAPdata.CurSpeed = data(:,22)';
WAPdata.CurDir = data(:,23)';
WAPdata.Err = data(:,24)';
WAPdata.method = 'AST';
end

% from AWAC
if(cl == 26)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.SpecUsed = data(:,7)';
WAPdata.Hs = data(:,8)';
WAPdata.H3 = data(:,9)';
WAPdata.H10 = data(:,10)';
WAPdata.Hmax = data(:,11)';
WAPdata.Tm02 = data(:,12)';
WAPdata.Tp = data(:,13)';
WAPdata.Tmean = data(:,14)';
WAPdata.PeakDir = data(:,15)';
WAPdata.Sprd1 = data(:,16)';
WAPdata.MeanDir = data(:,17)';
WAPdata.UI = data(:,18)';
WAPdata.MeanPres = data(:,19)';
WAPdata.MeanAST = data(:,20)';
WAPdata.MeanIce = data(:,21)';
WAPdata.NoDet = data(:,22)';
WAPdata.BadDet = data(:,23)';
WAPdata.CurSpeed = data(:,24)';
WAPdata.CurDir = data(:,25)';
WAPdata.Err = data(:,26)';
WAPdata.method = 'AST';
end


% from AWAC
if(cl == 27)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.SpecUsed = data(:,7)';
WAPdata.Hs = data(:,8)';
WAPdata.H3 = data(:,9)';
WAPdata.H10 = data(:,10)';
WAPdata.Hmax = data(:,11)';
WAPdata.Tm02 = data(:,12)';
WAPdata.Tp = data(:,13)';
WAPdata.Tmean = data(:,14)';
WAPdata.PeakDir = data(:,15)';
WAPdata.Sprd1 = data(:,16)';
WAPdata.MeanDir = data(:,17)';
WAPdata.UI = data(:,18)';
WAPdata.MeanPres = data(:,19)';
WAPdata.MeanAST = data(:,20)';
WAPdata.MeanIce = data(:,21)';
WAPdata.NoDet = data(:,22)';
WAPdata.BadDet = data(:,23)';
WAPdata.NumZeroCross = data(:,24)';
WAPdata.CurSpeed = data(:,25)';
WAPdata.CurDir = data(:,26)';
WAPdata.Err = data(:,27)';
WAPdata.method = 'AST';
end


% from AWAC
if(cl == 30)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.SpecUsed = data(:,7)';
WAPdata.Hs = data(:,8)';
WAPdata.H3 = data(:,9)';
WAPdata.H10 = data(:,10)';
WAPdata.Hmax = data(:,11)';
WAPdata.Tm02 = data(:,12)';
WAPdata.Tp = data(:,13)';
WAPdata.Tmean = data(:,14)';
WAPdata.T3 = data(:,15)';
WAPdata.T10 = data(:,16)';
WAPdata.Tmax = data(:,17)';
WAPdata.PeakDir = data(:,18)';
WAPdata.Sprd1 = data(:,19)';
WAPdata.MeanDir = data(:,20)';
WAPdata.UI = data(:,21)';
WAPdata.MeanPres = data(:,22)';
WAPdata.MeanAST = data(:,23)';
WAPdata.MeanICE = data(:,24)';
WAPdata.NoDet = data(:,25)';
WAPdata.BadDet = data(:,26)';
WAPdata.NumZeroCross = data(:,27)';
WAPdata.CurSpeed = data(:,28)';
WAPdata.CurDir = data(:,29)';
WAPdata.Err = data(:,30)';
WAPdata.method = 'AST';
end


% from AWAC
if(cl == 31)
WAPdata.Month = data(:,1)';
WAPdata.Day  = data(:,2)';
WAPdata.Year = data(:,3)';
WAPdata.Hour  = data(:,4)';
WAPdata.Minute = data(:,5)';
WAPdata.Second = data(:,6)';
WAPdata.DateTime = datenum(WAPdata.Year, WAPdata.Month, WAPdata.Day, WAPdata.Hour, WAPdata.Minute, WAPdata.Second);
WAPdata.SpecUsed = data(:,7)';
WAPdata.Hs = data(:,8)';
WAPdata.H3 = data(:,9)';
WAPdata.H10 = data(:,10)';
WAPdata.Hmax = data(:,11)';
WAPdata.Hmean = data(:,12)';
WAPdata.Tm02 = data(:,13)';
WAPdata.Tp = data(:,14)';
WAPdata.Tmean = data(:,15)';
WAPdata.T3 = data(:,16)';
WAPdata.T10 = data(:,17)';
WAPdata.Tmax = data(:,18)';
WAPdata.PeakDir = data(:,19)';
WAPdata.Sprd1 = data(:,20)';
WAPdata.MeanDir = data(:,21)';
WAPdata.UI = data(:,22)';
WAPdata.MeanPres = data(:,23)';
WAPdata.MeanAST = data(:,24)';
WAPdata.MeanICE = data(:,25)';
WAPdata.NoDet = data(:,26)';
WAPdata.BadDet = data(:,27)';
WAPdata.NumZeroCross = data(:,28)';
WAPdata.CurSpeed = data(:,29)';
WAPdata.CurDir = data(:,30)';
WAPdata.Err = data(:,31)';
WAPdata.method = 'AST';
end
