clear all;close all;clc
hs_par=load('hs_par_st01.txt');
pwrFreq    = importdata('01_02.was');
pwrFreqDir = importdata('01_02.wds');
%% Organize data
pwrFreq(pwrFreq == -9.000000) = NaN; 
pwrFreqDir(pwrFreqDir == -9.000000) = NaN;
waveData.Frequency = pwrFreq(1,:)';
waveData.pwrSpectrum           = pwrFreq(2:end,:); clear pwrFreq;
waveData.fullSpectrumDirection = pwrFreqDir(1,:)';
waveData.fullSpectrum          = pwrFreqDir(2:end,:); clear pwrFreqDir;
nFreqs   = 48; % ~ length(waveData.Frequency): this is because the AST samples at twice the frequency as the standard measures of pressure and velocity
waveData.Frequency=waveData.Frequency(1:nFreqs,:);
nDirs    = length(waveData.fullSpectrumDirection);
nSamples = length(waveData.fullSpectrum) / nFreqs;
waveData.fullSpectrum = permute(reshape(waveData.fullSpectrum', nDirs, nFreqs, nSamples), [ 2 1 3]);
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
%% Calculate Hm0 from full spectrum; 
for j=1:473;
    E2=squeeze(E(:,:,j));
    m0=trapz(waveData.fullSpectrumDirection,trapz(waveData.Frequency,E2));
    hm0(j,1)=4*sqrt(m0);
end
% plot hm0 calculated from full spectrum and by storm
figure;plot(hm0); hold on; plot(hs_par,'r')
legend('Hm0 from full spectrum unnormalized','Hm0 from storm')