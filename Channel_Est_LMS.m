clear;close all;
h=[0.74 -0.514 0.37 0.216 0.062];%given channel statistics
N=1000;%block length
H=length(h);%lenght of channel response
T=10;%number of taps for eq
frame_cnt=1000;%frame count
fer_lim=10000;%frame error limit
Ks=[5 10 20];%pilot count
SNR_dB=0:2:20;%snr values in db
SNR=1./(2*(10.^(SNR_dB./10)));%snr values in bit energy
CE_BER_LMS=zeros(length(Ks),length(SNR_dB));%ber matrix
MSE_LMS=zeros(length(Ks),length(SNR_dB));%avg mse matrix
h_LMS=zeros(H,length(Ks));%estimated channel parameters
imp=zeros(1,T+length(h)-1);%desired channel response
imp(1)=1;imp=imp';%channel is causal, no future indexes
mu=0.125;%step size constant
%iterations---
for i=1:length(Ks)%pilot count loop
    K=Ks(i);tic
    for s=1:length(SNR_dB)%snr loop
        %definitions for recursion---
        h_est=zeros([H 1]);%channel impulse to be estimated
        ld=1;%exponential forget factor
        ldi=1/ld;%inverse of forget factor, for ease
        u=zeros(H,1);%observation vector
        d=zeros(H,1);%known data vector
        P=SNR_dB(s)*10*eye(H);%inverse of autocorrelation
        var=SNR(s);%sigma squared for noise
        fr=1;fer=0;fmse=0;%initialize
        %training---
        while fr<frame_cnt && fer<fer_lim
            x_p=randi([0 1],[1 K]);x_p(x_p==0)=-1;%generate pilot symbols
            noise=normrnd(0,sqrt(var),[1,K+length(h)-1]);%noise samples
            y=conv(x_p,h)+noise;%impose channel conditions
            x_p=[x_p zeros(1,H-1)];%add zero padding to the end
            %begin recursion
            for n=1:K
                u=fliplr(y(n:n+H-1))';%observation
                e=y(n+H-1)-fliplr(x_p(:,n:n+H-1))*h_est;%calculate err
                ss=mu/(u'*u);%compute step size for the current time instant
                h_est=h_est+ss*e*u;%update eq coeffs
            end%end training
            mse=power(norm(h'-h_est),2);%calculate mse
            fmse=fmse+mse;
            %update eq coeffs according to new estimate
            g=build(h_est',T);%g matrix
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
        MSE_LMS(i,s)=fmse/(K*fr);%average over frame count
        CE_BER_LMS(i,s)=fer/(N*fr);%average over total bits
        disp([SNR_dB(s) fr fer]);%print the current parameters
    end%end snr loop
    h_est=h_est';
    h_LMS(:,i)=h_est;%save final estimations 
end%end pilot count loop
%save results
save('CE_LMS','CE_BER_LMS','MSE_LMS','h_LMS');
%helper functions---
function g=build(f,T)
%f: channel impulse response|T:number of taps|
g=zeros(T,T+length(f)-1);
cl=[f zeros(1,T-1)];
for i=1:T
    g(i,:)=zeroshift(cl,i-1,'R');
end
end
function o=zeroshift(A,N,D)
%|A: input vector|N: offset|D: direction|
o=zeros(size(A));
if D=='R' o(N+1:end)=A(1:end-N);
elseif D=='L' o(1:length(A)-N)=A(N+1:end);end
end