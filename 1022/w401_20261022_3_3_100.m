te=2.0; % 信号区間端（0～te[sec]）
dt=0.001; % 連続時間軸の刻み幅（サンプリング周波数1[kHz]）
t=0:dt:te; % 等間隔時間軸ベクトルの生成
xca=cos(2*pi*8*t)+1; % アナログ信号の生成
fs=20; % サンプリング周波数fs=20[Hz],10[Hz]
Ts=1/fs; % サンプリング間隔Ts=0.05[sec]
tn=0:Ts:te; % サンプル時刻を与える等間隔ベクトルの生成
xcd=cos(2*pi*8*tn)+1; % ディジタル信号の生成
TN=Ts/dt; % 1サンプリング間隔あたりの刻み数
Nn=te/Ts; % 時間区間での信号値の個数=サンプル個数
xch=zeros(1,length(xca)); % ホールド信号サイズの初期化
for k=1:Nn
    xch((k-1)*TN+1:(k-1)*TN+1)=xcd(k); % 量子化前狭いパルスのホールド信号の生成
end
N=length(xch); % 信号長（周波数域長）
Xch=fft(xch); % 離散フーリエ変換
fa=1/dt; % アナログ信号の刻み幅に対するサンプリング周波数
fl=8.5; % LPFの遮断周波数8.5[Hz],2.5[Hz]
Nl=round((N-1)*fl/fa); % 遮断周波数の周波数サンプル値
H=zeros(1,N); % フィルタの初期化（阻止域0）
H(1:Nl)=1; H(N-Nl+2:N)=1; % flまで1（通過域）
Xchrec=Xch.*H; % LPF処理（平滑化）
xrec=fa/fs*ifft(Xchrec); % 式(3.5)の逆離散フーリエ変換なのでfa/fsを乗じて振幅値を正規化
figure(1) % 図3.10,図3.12
plot(t,xca,'r--',t,xrec,'k-'); % 原信号および再構成アナログ信号の表示
hold on % グラフを表示状態で保持
stem(tn,xcd,'fil','b','Linestyle','none'); % サンプル値信号のプロット
axis([0,te,-0.2,2.2]); xlabel('Time [sec]'); ylabel('x(t), x(nT_s)');
legend('Original analog signal','Reconstructed analog signal','Sampled signal');