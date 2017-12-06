%
%	This function reads in the spectrum burst file and then outputs
%	the frequency vector and the spectra normalized spectra.
%  More work could be done here so that the time axis has dates
%  like is done in plotwap.m .   
%
%
%	Input Arguments
%
%		plotflag    ... plot spectrogram of the data True or False (1/0)
%		W           ... Data extracted from *.wap file using getwap.m
%                       contains time stamp for plotting. *.was file must
%                       be in the same directory as *.wap.
%		TopFreq     ... Upper Frequency limit
%       PlotData    ... Switch to output plots
%       MarkErrors  ... Flags data with green circle that failed any QC 
%                       checks
%
%	Output Arguments
%	
%		freq 		... frequency vector in Hz
%		Spec 		... Spectra m/Hz^2
%		SpecNorm    ... Normalized Spectra
%       Speclog     ... log10 of specturm
%
%
% function [freq, Spec, SpecNorm, Speclog] = getWAS(W, TopFreq,PlotData,MarkErrors);
%

function [freq, Spec, SpecNorm, Speclog] = getWAS(W, TopFreq,PlotData, MarkErrors);


clear Spec SpecNorm


if (nargin == 0)
   file2Get = [pname,fname];
   [fname,pname] = uigetfile('*.was','Go and Get that WAS file ');
   save lastdirectory pname
   plotflag = 1;
   file2Get = [pname,fname];
   MarkErrors = 1;
elseif(nargin >= 1) %use time stamp
   %cd c:\
   %[fname,pname] = uigetfile('*.was','Go and Get that WAS file ');
   %save lastdirectory pname
   %file2Get = [pname,fname];
   file2Get = [W.file2Get(1:end-3),'was'];
   plotflag = 2;
else   
   disp('Wrong number of arguements input')   
end

SpecData = load(file2Get);

freq = SpecData(1,:);
%freq = 0.02:0.01:1.99;

Spec = SpecData(2:end,:);

startoffset = 0;
stopoffset = startoffset;

[M,N] = size(Spec);

for i = 1:M
   ii = find(Spec(i,:) == 0);   
   Spec(i,ii) = 1/10000;
   if 0
      %if(W.Err(i) ~= 0)
      Spec(i,:) = ones(1,N)*1/10000;
   end   
   
   minspec =  min(Spec(i,:));
   Spec(i,ii) = minspec;
   
   Speclog(i,:) = log10(Spec(i,:));   
   SpecNorm(i,:) = Spec(i,:)/max(Spec(i,:));
end

W.DateTimeOld = W.DateTime;

if PlotData
   ibad = find(W.MeanPres < 0.5);
   W.Hs(ibad) = nan;
   W.H3(ibad) = nan;
   W.H10(ibad) = nan;
   W.Hmax(ibad) = nan;
   W.Tm02(ibad) = nan;
   W.Tp(ibad) = nan;
   W.Tmean(ibad) = nan;
   W.PeakDir(ibad) = nan;
   W.Sprd1(ibad) = nan;
   W.MeanDir(ibad) = nan;
   W.MeanPres(ibad) = nan;
   W.NoDet(ibad) = nan;
   W.BadDet(ibad) = nan;
   W.PeakDir(ibad) = nan;   
   %W.DateTime(ibad) = nan;
end


ind = find(W.Hs == -1 | W.Hs == -99999);
W.Hs(ind) = NaN;
Hs = W.Hs(1:M);


if PlotData
% LOG SPECTROGRAM PLOT OF THE TIME SERIES SPECTRA
% -----------------------------------------------
figure(30), 

Hand1 = subplot('position',[.1 .8 .85 .1]);
plot(W.DateTime(1:M),Hs,'r')
ylabel('H_s (m)')
datetick('x','mm/dd');
if max(Hs) >1.5
    maxHs = ceil(max(Hs));
else
    maxHs = ceil(max(Hs)*4)/4;
end
axis([min(W.DateTime(1:M)) max(W.DateTime(1:M)) 0 maxHs])
%set(gca,'XTick',[])
set(gca,'YTick',[ceil(max(Hs(2:end-2)))/4:ceil(max(Hs))/4:ceil(max(Hs))])
title('AWAC: H_s - Log Spectrogram')
grid on

Hand2 = subplot('position',[.1 .05 .85 .75]);
surf(freq  ,W.DateTime(1:M),Speclog)
caxis([-2.0 -0.5])
datetick('y','mm/dd');   
% axis([min(freq)  TopFreq  min(W.DateTime(1:M)) max(W.DateTime(1:M)) min(min(Speclog)) max(max(Speclog))])
set(gca,'XTick',[ 0.05:0.05:TopFreq])
shading flat
view(90,270)
xlabel('Frequency (Hz)')
ylabel('Day of Month')
%colorbar;
end











if PlotData
   % SPECTROGRAM PLOT OF THE TIME SERIES SPECTRA
   % ------------------------------------------------------
   %
   %	Note this is normalzed from 0-1 for every spectra. Therefore
   %	variations with amplitude are noted by headerplot of Hs
   %
   figure(31); 
   
   H1 = subplot('position',[.1 .75 .85 .15]);
   plot(W.DateTime,W.Hs,'r.')
   datetick('x','mm/dd');
   ylabel('H_s  (m)')
   %datetick('x','mm/dd');   
   grid on

   if MarkErrors
       ErrIndex  = find(W.Err >2);
       hold on,
       plot(W.DateTime(ErrIndex),W.Hs(ErrIndex),'go')
       legend('Hm0','Flagged data')
   end
   

   startoffset = 0;
   stopoffset = 0;   

    if max(Hs) >1.5
        maxHs = ceil(max(Hs(1+startoffset:end-stopoffset)));
    else
        maxHs = ceil(max(Hs(1+startoffset:end-stopoffset))*4)/4;
    end   
   
   axis([W.DateTime(1) (W.DateTime(end))-stopoffset 0 maxHs])

   set(gca,'YTick',[ceil(max(W.Hs(1+startoffset:M-stopoffset)))/4:ceil(max(Hs(1+startoffset:M-stopoffset)))/4:ceil(max(W.Hs(1+startoffset:end-stopoffset)))])
   if( max(Hs(1+startoffset:M-stopoffset)) < 1.25)
      set(gca,'YTick',[0.25 .5 .75 1.0 1.25])
   end
   if( max(Hs(1+startoffset:M-stopoffset)) < 1.0)
      set(gca,'YTick',[0.25 .5 .75 1.0])
   end
   if( max(Hs(1+startoffset:M-stopoffset)) < 0.75)
      set(gca,'YTick',[0.25 .5 .75])
   	axis([W.DateTime(1) (W.DateTime(end))-stopoffset 0 0.75])
   end
   if( max(Hs(1+startoffset:M-stopoffset)) < 0.5)
      set(gca,'YTick',[0.1 .2 .3 .4 .5])
   	axis([W.DateTime(1) (W.DateTime(end))-stopoffset 0 0.5])
   end
   set(gca,'XTick',[])
   
   subplot('position',[.1 .05 .85 .7])
   surf(freq,W.DateTime(1:M),Spec)
   shading flat
   datetick('y');   
%    axis([.02 TopFreq W.DateTime(1+startoffset) W.DateTime(M-stopoffset) 0 1])

   FreqIncr = .05;
   set(gca,'XTick',[ 0.00:FreqIncr:TopFreq-FreqIncr])
   view(90,270)
   xlabel('Frequency  (Hz)')
   ylabel('Date')
 
end   





if 0
   % STANDARD SPECTROGRAM PLOT OF THE TIME SERIES SPECTRA
   % -----------------------------------------------
   %Cscale = [.1 .6];
   figure(32), surf(freq,W.DateTime(1:M),Spec)
   axis([min(freq) 0.5 min(W.DateTime(1:M)) max(W.DateTime(1:M)) 0 max(max(Spec))])
   datetick('y','mm/dd');   
   axis([min(freq) TopFreq W.DateTime(1) W.DateTime(M) 0 max(max(Spec))])
   shading flat
   view(90,270)
   xlabel('Frequency (Hz)')
   ylabel('Date')
   title('Spectrogram')
   %colorbar;
   caxis([0 5]) %<------ ADJUST THIS TO REALIZE THE SPECTRA
   %title('Wave Spectrogram: Carqueiranne, France    May 2002')
   ylabel('Day of Month')
end

if 0
   % NORMALIZED SPECTROGRAM PLOT OF THE TIME SERIES SPECTRA
   % ------------------------------------------------------
   %
   %	Note this is normalzed from 0-1 for every spectra. Therefore
   %	variations with amplitude are noted by headerplot of Hs
   %
   figure(33), 
   subplot('position',[.1 .75 .85 .15])
   plot(Hs)
   ylabel('H_s (m)')
   %datetick('x','mm/dd');   
   grid on
   
   axis([startoffset length(Hs)-stopoffset 0 ceil(max(Hs(1+startoffset:end-stopoffset)))])
   %set(gca,'XTick',[])
   set(gca,'YTick',[ceil(max(Hs(1+startoffset:M-stopoffset)))/4:ceil(max(Hs(1+startoffset:M-stopoffset)))/4:ceil(max(Hs(1+startoffset:end-stopoffset)))])
   if( max(Hs(1+startoffset:M-stopoffset)) < 1.0)
      set(gca,'YTick',[0.25 .5 .75 1.0])
   end
   set(gca,'XTick',[])
   %grid on
   
   subplot('position',[.1 .05 .85 .7])
   surf(freq,W.DateTime(1:M),SpecNorm)
   shading flat
   datetick('y','mm/dd');   
   axis([min(freq) TopFreq W.DateTime(1+startoffset) W.DateTime(M-stopoffset) 0 1])
   %axis([min(freq) 1 min(W.DateTime(1:M)) max(W.DateTime(1:M)) 0 1])
   FreqIncr = TopFreq/10;
   %set(gca,'XTick',[ 0.00:FreqIncr:TopFreq-FreqIncr])
   view(90,270)
   xlabel('Frequency (Hz)')
   ylabel('Date')
   %title('Normalized Spectrogram')   
end   


if PlotData
   % NORMALIZED SPECTROGRAM PLOT OF THE TIME SERIES SPECTRA
   % ------------------------------------------------------
   %
   %	Note this is normalzed from 0-1 for every spectra. Therefore
   %	variations with amplitude are noted by headerplot of Hs
   %
   figure;%(33), 
   
   H1 = subplot('position',[.1 .75 .85 .15]);
   plot(W.DateTime,W.Hs,'r-.')
   datetick('x','mm/dd');
   ylabel('H_s  (m)')
   %datetick('x','mm/dd');   
   grid on

   if MarkErrors
       ErrIndex  = find(W.Err >2);
       hold on,
       plot(W.DateTime(ErrIndex),W.Hs(ErrIndex),'go')
       legend('Hm0','Flagged data')
   end
   
   
   
   startoffset = 0;
   stopoffset = 0;   

    if max(Hs) >1.5
        maxHs = ceil(max(Hs(1+startoffset:end-stopoffset)));
    else
        maxHs = ceil(max(Hs(1+startoffset:end-stopoffset))*4)/4;
    end   
   
   axis([W.DateTime(1) (W.DateTime(end))-stopoffset 0 maxHs])
   %axis([startoffset length(Hs)-stopoffset 0 0.5])
   %set(gca,'XTick',[])
   set(gca,'YTick',[ceil(max(W.Hs(1+startoffset:M-stopoffset)))/4:ceil(max(Hs(1+startoffset:M-stopoffset)))/4:ceil(max(W.Hs(1+startoffset:end-stopoffset)))])
   if( max(Hs(1+startoffset:M-stopoffset)) < 1.25)
      set(gca,'YTick',[0.25 .5 .75 1.0 1.25])
   end
   if( max(Hs(1+startoffset:M-stopoffset)) < 1.0)
      set(gca,'YTick',[0.25 .5 .75 1.0])
   end
   if( max(Hs(1+startoffset:M-stopoffset)) < 0.75)
      set(gca,'YTick',[0.25 .5 .75])
   	axis([W.DateTime(1) (W.DateTime(end))-stopoffset 0 0.75])
   end
   if( max(Hs(1+startoffset:M-stopoffset)) < 0.5)
      set(gca,'YTick',[0.1 .2 .3 .4 .5])
   	axis([W.DateTime(1) (W.DateTime(end))-stopoffset 0 0.5])
   end
   set(gca,'XTick',[])
   %grid on
   
   subplot('position',[.1 .05 .85 .7])
   surf(freq,W.DateTime(1:M),SpecNorm)
   shading flat
   datetick('y');   
%    axis([.02 TopFreq W.DateTime(1+startoffset) W.DateTime(M-stopoffset) 0 1])
   %axis([min(freq) 1 min(W.DateTime(1:M)) max(W.DateTime(1:M)) 0 1])
   FreqIncr = .05;
   set(gca,'XTick',[ 0.00:FreqIncr:TopFreq-FreqIncr])
   view(90,270)
   xlabel('Frequency  (Hz)')
   ylabel('Date')
   %title('Normalized Spectrogram')   
end   

