% =============== CONSTANTS ======================================
NUM_BANDS = 16;
HIGH = 5760;
LOW = 90;
FILT_ORDER = 4;
envelope_low_f = 240;

% =============== SIGNAL PREPROCESSING ===========================
% [input_audio, Fs] = audioread("testing.m4a");
[input_audio, Fs] = audioread("fivewo.wav");
t = (1:size(input_audio,1))/Fs;
alpha = rms(input_audio);
x = input_audio/alpha;
signal_size = size(x,1);

% =============== BAND DIVISION and ENVELOPE filtering ===========
r = (HIGH/LOW)^(1/NUM_BANDS);
output_audio = zeros(signal_size,1);
figure;
hold on;
for n=1:NUM_BANDS

    l_f = LOW*r^(n-1);
    h_f = LOW*r^(n);
    [b1,a1] = butter(FILT_ORDER/2, [l_f, h_f]*2/Fs);

    y = filter(b1,a1,x);
    Yr = hilbert(y);
    rough_envelope = abs(Yr);

    [b2,a2] = butter(FILT_ORDER, envelope_low_f/Fs);
    envelope = filter(b2,a2,rough_envelope);

    noise = randn(signal_size, 1);
    signal = envelope.*noise;

    bandlimited_signal = filter(b1,a1,signal);
    output_audio = output_audio + bandlimited_signal;
    
    %plot envelope
    plot(t,envelope);
    xlabel("time(in sec)");
end
hold off;

% ================= OUTPUT =======================================
output_audio = alpha(1,1) * output_audio/rms(output_audio);
audiowrite("result.wav",output_audio,Fs);

% Plots
figure;
hold on;
plot(t,output_audio);
plot(t,input_audio);
xlabel("time(in sec)");
hold off;
% 
N=512;
figure;
hold on;
dftplot(output_audio,Fs,N);
dftplot(input_audio,Fs,N);
hold off;