function spect = Spect( y )
% SPECTROGRAM
% Adam Szaruga, 7/31/2014
%
% Computes spectrogram using 1024 sample width fft segments, 50% overlap,
% and Hamming windowing
%
% Returns a 1024 by k matrix, where k is the number of frames
%
% #USAGE#
% [s, Fs] = audioread( path );
% spect = Spect(s);
%

y(end + (1024 - mod(length(y), 1024)))=0; %pad signal with zeros to make 1024-width windows
z = y(513:end-512); % initialize even numbered frames that overlap 50%

y = reshape(y, 1024, length(y)/1024); % odd FFT windows in each column, 1024 window length
z = reshape(z, 1024, length(z)/1024); % even FFT windows in each column, 1024 window length, 50% overlap

yz = zeros(size(y,1), size(y,2) + size(z,2)); % Interlace odd numbered and even numbered frames
yz(:,1:2:end) = y;
yz(:,2:2:end) = z;

h = hamming(1024);
for n = 1:size(yz,2)
   yz(:,n) = yz(:,n).*h; % apply hamming window to each column
end

spect = fft(yz);

end




