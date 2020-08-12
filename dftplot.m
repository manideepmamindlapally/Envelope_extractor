function []= dftplot(x,Fs,N)
    f=linspace(-Fs/2,Fs/2,N);
    y=fft(x,N)/N;
    y_spect=fftshift(y);
    m=abs(y_spect);
    plot(f,m);
    xlabel("Frequency");
    ylabel("Normalised magnitude");
end