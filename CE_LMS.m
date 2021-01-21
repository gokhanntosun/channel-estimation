clear;close all;
h=[0.74 -0.514 0.37 0.216 0.062];%given channel statistics
N=10000;%block length
H=length(h);%lenght of channel response
frame_cnt=1000;%frame count
Ks=[5 10 20];%pilot count
SNR_dB=0:2:20;%snr values in db
SNR=1./(2*(10.^(SNR_dB./10)));%snr values in bit energy
MSE_LMS=zeros(length(Ks),length(SNR_dB));%avg mse matrix
h_LMS=zeros(H,length(Ks));%estimated channel parameters
mu=0.25;%step size constant
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
        fr=1;fer=0;%initialize
        %------------------------------------------------------------------
        %training----------------------------------------------------------
        while fr<frame_cnt
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
            fer=fer+mse;%update frame error, accumulate mse
            fr=fr+1;%increase frame count
        end
        MSE_LMS(i,s)=fer/(K*fr);%average over frame count
        disp([SNR_dB(s) fr fer]);%print the current parameters
    end%end snr loop
    h_est=h_est';
    h_LMS(:,i)=h_est;%save final estimations 
end%end pilot count loop
%save results
save('CE_LMS','MSE_LMS','h_LMS');
