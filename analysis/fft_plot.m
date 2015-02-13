function fft_plot(y, Fs)

    %% perform FFT
    L = length(y);
    Fs=10;

    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2);

    %% Plot single-sided amplitude spectrum.
    figure
    plot(f,2*abs(Y(1:NFFT/2))) 
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    % xlim([0 .5])

end