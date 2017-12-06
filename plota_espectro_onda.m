function plota_espectro_onda(nome_figura,nome_arquivo,caminho,tempo,eli_antes,eli_dep)

[Filename,Pathname]= uigetfile([caminho '/*.was']);pwrFreq=importdata([Pathname '\' Filename]);
[Filename2,Pathname2] = uigetfile([caminho,'/*.wds']);pwrFreqDir=importdata([Pathname2 '\' Filename2]);
[Filename3,Pathname3] = uigetfile([caminho,'/*.wdr']);pwrDir=importdata([Pathname3 '\' Filename3]);
%% Organize data
pwrFreq(pwrFreq == -9.000000) = NaN; 
pwrFreqDir(pwrFreqDir == -9.000000) = NaN;
waveData.Frequency = pwrFreq(1,:)';
waveData.pwrSpectrum           = pwrFreq(eli_antes+2:end-eli_dep,:); 
waveData.fullSpectrumDirection = 4:4:360;
nFreqs   = size(pwrDir,2);
waveData.fullSpectrum          = pwrFreqDir((eli_antes*nFreqs)+1:end-eli_dep*nFreqs,:); 
waveData.Frequency=waveData.Frequency(1:nFreqs,:);
nDirs    = length(waveData.fullSpectrumDirection);
nSamples = length(waveData.fullSpectrum) / nFreqs;
aux=waveData.fullSpectrum';
% aux=aux(:,1:2304);
waveData.fullSpectrum = permute(reshape(aux, nDirs, nFreqs, nSamples), [ 2 1 3]);
%% Unnormalize data
% E(f,theta) = S(f) * d(f,theta)     ,   with S= Energy spectra (*.was)    and d=full directional spectra (*.wds)
E=zeros(nFreqs,nDirs,nSamples);
for t=1:nSamples
    for f=1:nFreqs;
        for theta=1:nDirs;
            E(f,theta,t) = waveData.pwrSpectrum(t,f) * waveData.fullSpectrum(f,theta,t);
        end
    end
end
%% Calcula o espectro direcional;
figure(1)
subplot(2,1,1)
waveData.fullSpectrum(end-8:end,:,:)=[];

for j=1:15;
    E2=squeeze(waveData.fullSpectrum(j,:,:));
end

pcolor(tempo(1:end),waveData.fullSpectrumDirection,E2)
shading interp

ylim([4 360]);
xlim([tempo(1) tempo(end)]);
yticks=0:60:360;
set(gca,'YTick',yticks)
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Direção (°)')
title(['Espectro direcional de ondas em ' nome_figura],'FontSize',12);
col=colorbar;
title(col,'Energia (m^2/Hz)','Fontsize',9);

subplot(2,1,2)
pcolor(tempo(1:end),waveData.Frequency(1:end),waveData.pwrSpectrum(:,1:end)')
shading interp
xlim([tempo(1) tempo(end)]);
ylim([0.02 0.35])
ccol=colorbar;
title(ccol,'Energia (m^2/Hz*°)','Fontsize',9);
datetick('x','dd/mm','keepticks','keeplimits')
ylabel('Frequência (Hz)')
title(['Espectro de ondas em ' nome_figura],'Fontsize',12);
print('-dpng',[caminho '\Espectro_ondas_' nome_arquivo],'-r300');

close all

end