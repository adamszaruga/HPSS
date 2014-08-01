function [harm, perc] = HPSS(spect, hKern, pKern, power)
% HPSS - MEDIAN FILTERING
% Adam Szaruga, 7/31/2014
%
% Separates a spectrogram into its harmonic and percussive elements
%
% #ARGUMENTS#
% spect - the input spectrogram
% hKern - Kernel size for the harmonic median filter
% pKern - Kernel size for the percussive median filter
% power - Power used for the Weiner Filter (usually 1 or 2)
%
% Returns two spectrograms: 
% harm - The spectrogram with supressed percussive elements
% perc - The spectrogram with supressed harmonic elements
%
% #USAGE#
% [s, Fs] = audioread( path );
% spect = Spect(s);
% [harm, perc] = HPSS(spect, 100, 100, 2);
% h = iSpect(harm);
% p = iSpect(perc);
% hPlayer = audioplayer(h, Fs);
% pPlayer = audioplayer(p, Fs);
% play(hPlayer);
% play(pPlayer);
%

% Extract magnitude and phase from the spectrogram
mag = abs(spect);
phase = angle(spect);

% median filtering
harm = medfilt1(mag, hKern, size(mag,2), 2);
perc = medfilt1(mag, pKern, size(mag,1), 1);

% apply weiner filter power
harm = harm.^power;
perc = perc.^power;

% check for scenario where harm and perc are zero, equalize
zero_harm = (harm == 0);
zero_perc = (perc == 0);
harm(zero_harm & zero_perc) = 0.5;
perc(zero_harm & zero_perc) = 0.5;

% create masks
harm = harm./(harm + perc);
perc = perc./(harm + perc);

% apply masks to original spectrogram and reapply phase to magnitude
harm = (mag.*harm).*exp(1i*phase);
perc = (mag.*perc).*exp(1i*phase);

end

