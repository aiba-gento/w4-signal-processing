close all; clc

% 8 Hz正弦波と連続時間軸を作成する
te = 1.0;
dt = 0.0001;
t = 0:dt:te;
f0 = 8;
xca = sin(2*pi*f0*t);
fs_list = [10, 100];
fa = 1/dt;
fl = 10;

figure(1);
clf;
for k = 1:length(fs_list)
    fs = fs_list(k);
    Ts = 1/fs;
    tn = 0:Ts:(te-Ts);
    xcd = sin(2*pi*f0*tn);

    % サンプル値を連続時間軸上でゼロ次ホールドする
    TN = round(Ts/dt);
    Nn = length(xcd);
    xch = zeros(1,length(xca));
    for n = 1:Nn
        xch((n-1)*TN+1:n*TN) = xcd(n);
    end
    xch(Nn*TN+1:end) = xcd(end);

    % FFT後にローパスフィルタを通し、逆FFTでDA変換波形を再構成する
    % xchはすでに振幅を保持した信号なので、逆FFT後の補正は行わない
    N = length(xch);
    Xch = fft(xch);
    Nl = round((N-1)*fl/fa);
    H = zeros(1,N);
    H(1:Nl) = 1;
    H(N-Nl+2:N) = 1;
    Xchrec = Xch.*H;
    xrec = real(ifft(Xchrec));

    % 元信号、サンプル値信号、DA変換後の波形を比較表示する
    subplot(2,1,k);
    plot(t,xca,'r--',t,xrec,'k-','LineWidth',1.0);
    hold on;
    stem(tn,xcd,'b','filled','LineStyle','none');
    hold off;
    grid on;
    axis([0,te,-1.2,1.2]);
    xlabel('Time [s]');
    ylabel('Amplitude');
    title(sprintf('8 Hz sine wave sampled at %d Hz',fs));
    legend('Original analog signal','D/A converted signal', ...
        'Sampled signal','Location','best');
end
