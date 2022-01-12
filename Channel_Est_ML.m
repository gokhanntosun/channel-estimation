clear;close all;
h=[0.74 -0.514 0.37 0.216 0.062];%given channel statistics
H=length(h);
N=1000;%block length
T=10;%tap count
frame_cnt=1000;%frame count
fer_lim=10000;%frame error limit
Ks=[5 10 20];%pilot count
SNR_dB=0:2:20;%snr values in db
SNR=1./(2*(10.^(SNR_dB./10)));%snr values in bit energy
CE_BER_ML=zeros(length(Ks),length(SNR_dB));%ber matrix
MSE_ML=zeros(length(Ks),length(SNR_dB));%avg mse matrix
h_ML=zeros(H,length(Ks));%estimated channel parameters
imp=zeros(1,T+length(h)-1);%desired channel response
imp(1)=1;imp=imp';%channel is causal, no future indexes
for i=1:length(Ks)
    tic
    K=Ks(i);%pilot count
    for s=1:length(SNR_dB)
        var=SNR(s);%snr
        h_est=zeros([H 1]);%channel impulse to be estimated
        fr=1;fer=0;fmse=0;%initialize
        while fr<frame_cnt && fer<fer_lim
            x_p=randi([0 1],[1 K]);x_p(x_p==0)=-1;%generate pilot symbols
            noise=normrnd(0,sqrt(var),[1,K+length(h)-1]);%noise samples
            y=conv(x_p,h)+noise;%impose channel conditions
            %---ml estimate
            R=build(x_p,H);%flowing bits
            h_est=(R'*R)\R'*y';%ml estimation
            mse=power(norm(h'-h_est),2);%calculate mse
            fmse=fmse+mse;%accumulate mse
            %-estimation ok
            %-simulation
            g=build(h_est',T);g=g';%g matrix
            w=(g*g'+var.*eye(T))\g*imp;%calculate eq coeffs
            %tx---
            x=randi([0 1],[1 N]);x(x==0)=-1;%generate information symbols
            noise=normrnd(0,sqrt(var),[1,N+length(h)-1]);%noise samples
            y=conv(h,x)+noise;%impose channel conditions
            %rx---
            y=[zeros(1,T-1) y];%add zero padding to beginning
            o=zeros(1,N);
            for j=1:N
                %perform equalization
                o(:,j+T-1)=fliplr(y(:,j:j+T-1))*w;
            end
            o=o(T:end);o(o<0)=-1;o(o>=0)=1;%minimum distance
            diff=nnz(x-o);%calculate error
            fer=fer+diff;%update frame error
            fr=fr+1;%increase frame count
        end
        MSE_ML(i,s)=fmse/(K*fr);%average over frame count
        CE_BER_ML(i,s)=fer/(N*fr);%average over total bits
        disp([SNR_dB(s) fr fer]);%print the current parameters
    end
    h_est=h_est';
    h_ML(:,i)=h_est;%save final estimations 
    toc
end
%save results
save('CE_ML','CE_BER_ML','MSE_ML','h_ML');
%helper functions---
function g=build(f,T)
%f: channel impulse response|T:number of taps|
g=zeros(T,T+length(f)-1);
cl=[f zeros(1,T-1)];
for i=1:T
    g(i,:)=zeroshift(cl,i-1,'R');
end
g=g';
end
function o=zeroshift(A,N,D)
%|A: input vector|N: offset|D: direction|
o=zeros(size(A));
if D=='R' o(N+1:end)=A(1:end-N);
elseif D=='L' o(1:length(A)-N)=A(N+1:end);end
end