function signal = iSpect( spect )
% INVERSE SPECTROGRAM
% Adam Szaruga, 7/31/2014
%
% Converts a spectrogram to the time domain (for use with Spect.m)
%
% Returns a vector containing the reconstructed signal
%
% #USAGE#
% [s, Fs] = audioread( path );
% spect = Spect(s);
% ...
% s = iSpect(spect);
% player = audioplayer(s, Fs);
% play(player);
%

y = ifft(spect);

signal = zeros(1, (size(y,1)*size(y,2))/2 + 512 ); %initialize signal

for n = 1:size(y,2)  
    % add frames to initialized signal at the proper frame position. 
    % frames are 1024 samples in length and 512 samples apart, creating 50%
    % overlap.
    signal( (n-1)*512 + 1: (n-1)*512 + 1024 ) = signal( (n-1)*512 + 1: (n-1)*512 + 1024 ) + y(:, n).';
    
end

end
