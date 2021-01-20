clear;close all;
h=[0.74 -0.514 0.37 0.216 0.062];%given channel statistics
N=1000;%block length
T=11;%tap count
frame_cnt=10000;%frame count
fer_lim=250000;%frame error limit
SNR_dB=0:2:20;%snr values in db
SNR=1./(2*(10.^(SNR_dB./10)));%snr values in bit energy
BER_MMSE=zeros(1,length(SNR_dB));%ber vs snr vector
g=build(h,T);%g matrix
e=zeros(1,T+length(h)-1);%desired channel response
e(1)=1;e=e';%channel is causal, no future indexes
for s=1:length(SNR_dB)%snr loop
    %definitions-----------------------------------------------------------
    var=SNR(s);%define variance for noise
    w=(g*g'+var.*eye(T))\g*e;%calculate eq coeffs
    fr=1;fer=0;%initialize
    %----------------------------------------------------------------------
    %begin monte carlo sim-------------------------------------------------
    while fr<frame_cnt && fer<fer_lim
        x=randi([0 1],[1 N]);x(x==0)=-1;%generate information symbols
        noise=normrnd(0,sqrt(var),[1,N+length(h)-1]);%noise samples
        y=conv(h,x)+noise;%impose channel conditions
        y=[zeros(1,T-1) y];%add zero padding to beginning
        for i=1:N
            %perform equalization
            o(:,i+T-1)=fliplr(y(:,i:i+T-1))*w;
        end  
        o=o(T:end);o(o<0)=-1;o(o>=0)=1;%minimum distance
        diff=nnz(x-o);%calculate error
        fer=fer+diff;%update frame error
        fr=fr+1;%increase frame count
    end
    BER_MMSE(1,s)=fer/(fr*N);%calculate ber
    [SNR_dB(s) fr fer]%print the current parameters
end%end snr loop
%--------------------------------------------------------------------------
%plot results--------------------------------------------------------------
figure;
semilogy(SNR_dB,BER_MMSE,'b*-','LineWidth',1);
xlabel('SNR(dB)');ylabel('BER');title('MMSE Equalizer');;
grid on;axis square;set(gca,'FontSize',14);
%--------------------------------------------------------------------------
%helper functions----------------------------------------------------------
function g=build(f,T)
%f: channel impulse response|T:number of taps|
g=zeros(T,T+length(f)-1);
cl=[f zeros(1,T-1)];
for i=1:T
    g(i,:)=zeroshift(cl,i-1,'R');
end
end
%--------------------------------------------------------------------------
function o = zeroshift(A, N, D)
%|A: input vector|N: offset|D: direction|
o=zeros(size(A));
if D=='R' o(N+1:end)=A(1:end-N);
elseif D=='L' o(1:length(A)-N)=A(N+1:end);end
end