clear;close all;
h=[0.74 -0.514 0.37 0.216 0.062];%given channel statistics
H=length(h);%lenght of channel response
T=10;%nubmer of taps for eq
N=1000;%block length
frame_cnt=10000;%frame count
fer_lim=50000;%frame error limit
Ks=[5 10 20];%pilot count
SNR_dB=0:2:20;%snr values in db
SNR=1./(2*(10.^(SNR_dB./10)));%snr values in bit energy
MSE_RLS=zeros(length(Ks),length(SNR_dB));%avg mse matrix
h_RLS=zeros(H,length(Ks));%estimated channel parameters
imp=zeros(1,T+length(h)-1);%desired channel response
imp(1)=1;imp=imp';%channel is causal, no future indexes
%--------------------------------------------------------------------------
%iterations----------------------------------------------------------------
for i=1:length(Ks)%pilot count loop
    K=Ks(i);
    for s=1:length(SNR_dB)%snr loop
        %------------------------------------------------------------------
        %definitions for recursion-----------------------------------------
        h_est=zeros([H 1]);%channel impulse to be estimated
        ld=1;%exponential forget factor
        ldi=1/ld;%inverse of forget factor, for ease
        u=zeros(H,1);%observation vector
        d=zeros(H,1);%known data vector
        P=SNR_dB(s)*10*eye(H);%inverse of autocorrelation
        var=SNR(s);%sigma squared for noise
        fr=1;fer=0;fmse=0;%initialize
        %------------------------------------------------------------------
        %monte carlo-------------------------------------------------------
        while fr<frame_cnt && fer<fer_lim
            %training------------------------------------------------------
            x_p=randi([0 1],[1 K]);x_p(x_p==0)=-1;%generate pilot symbols
            noise=normrnd(0,sqrt(var),[1,K+length(h)-1]);%noise samples
            y=conv(x_p,h)+noise;%impose channel conditions
            x_p=[x_p zeros(1,H-1)];%add zero padding to the end
            %begin recursion
            for n=1:K
                u=fliplr(y(:,n:n+H-1))';%observation
                pi=ldi*P*u;%compute kalman gain vector
                K_g=pi/(1+u'*pi);
                e=y(n+H-1)-fliplr(x_p(:,n:n+H-1))*h_est;%calculate err
                h_est=h_est+e*K_g;%update coeff vector
                P=ldi*P-ldi*K_g*u'*P;%update inverse of autocorr.
            end%end training
            mse=power(norm(h'-h_est),2);%calculate mse
            fmse=fmse+mse;
            %update eq coeffs according to new estimate
            g=build(h_est',T);%g matrix
            w=(g*g'+var.*eye(T))\g*imp;%calculate eq coeffs
            %tx------------------------------------------------------------
            x=randi([0 1],[1 N]);x(x==0)=-1;%generate information symbols
            noise=normrnd(0,sqrt(var),[1,N+length(h)-1]);%noise samples
            y=conv(h,x)+noise;%impose channel conditions
            %rx------------------------------------------------------------
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
        MSE_RLS(i,s)=fmse/(K*fr);%average over frame count
        BER_RLS(i,s)=fer/(N*fr);%average over total bits
        disp([SNR_dB(s) fr fer]);%print the current parameters
    end%end snr loop
    h_est=h_est';
    h_RLS(:,i)=h_est;%save final estimations 
end%end pilot count loop
%save results
save('CE_RLS','BER_RLS','MSE_RLS','h_RLS');

figure;
subplot(122);
semilogy(SNR_dB,MSE_RLS(1,:),'r*-');hold on;
semilogy(SNR_dB,MSE_RLS(2,:),'b*-');hold on;
semilogy(SNR_dB,MSE_RLS(3,:),'g*-');hold on;
grid on;legend('P=5','P=10','P=20');title('SNR vs. Avg.MSE');
axis square;set(gca,'FontSize',14);
xlabel('SNR(dB)');ylabel('BER');
subplot(121);
semilogy(SNR_dB,BER_RLS(1,:),'r*-');hold on;
semilogy(SNR_dB,BER_RLS(2,:),'b*-');hold on;
semilogy(SNR_dB,BER_RLS(3,:),'g*-');hold on;
grid on;legend('P=5','P=10','P=20');title('SNR vs. BER');
xlabel('SNR(dB)');ylabel('MSE');ylim([10^-4 1]);
axis square;set(gca,'FontSize',14);
set(gcf,'Position',[225 225 1200 450]);
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
function o=zeroshift(A,N,D)
%|A: input vector|N: offset|D: direction|
o=zeros(size(A));
if D=='R' o(N+1:end)=A(1:end-N);
elseif D=='L' o(1:length(A)-N)=A(N+1:end);end
end
