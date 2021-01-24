clear;close all;
load 'CE_RLS';
load 'CE_LMS';
load 'CE_MMSE';
load 'CE_ML';
load 'AE_RLS';
load 'AE_LMS';
%definitions
SNR_dB=0:2:20;%define snr values
h=[0.74 -0.514 0.37 0.216 0.062];%given channel statistics
ss=get(0,'ScreenSize');
figure;%group by algorithm----
subplot(131);%RLS
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(1,:),'r-*');hold on;
semilogy(SNR_dB,AE_BER_RLS(1,:),'r-d');hold on;
semilogy(SNR_dB,CE_BER_RLS(2,:),'g-*');hold on;
semilogy(SNR_dB,AE_BER_RLS(2,:),'g-d');hold on;
semilogy(SNR_dB,CE_BER_RLS(3,:),'b-*');hold on;
semilogy(SNR_dB,AE_BER_RLS(3,:),'b-d');hold on;
legend('True','P_{CE}=5','P_{AE}=5','P_{CE}=10','P_{AE}=10','P_{CE}=20','P_{AE}=20','Location','SouthWest');
ylim([10^-4 10^0]);xlabel('SNR(dB)');ylabel('BER');title('RLS');
grid on;set(gca,'FontSize',14);axis square;
subplot(132);%LMS
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_LMS(1,:),'r-*');hold on;
semilogy(SNR_dB,AE_BER_LMS(1,:),'r-d');hold on;
semilogy(SNR_dB,CE_BER_LMS(2,:),'g-*');hold on;
semilogy(SNR_dB,AE_BER_LMS(2,:),'g-d');hold on;
semilogy(SNR_dB,CE_BER_LMS(3,:),'b-*');hold on;
semilogy(SNR_dB,AE_BER_LMS(3,:),'b-d');hold on;
legend('True','P_{CE}=5','P_{AE}=5','P_{CE}=10','P_{AE}=10','P_{CE}=20','P_{AE}=20','Location','SouthWest');
ylim([10^-4 10^0]);xlabel('SNR(dB)');ylabel('BER');title('LMS');
grid on;set(gca,'FontSize',14);axis square;
subplot(133);%ML
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_ML(1,:),'r-*');hold on;
semilogy(SNR_dB,CE_BER_ML(2,:),'g-*');hold on;
semilogy(SNR_dB,CE_BER_ML(3,:),'b-*');hold on;
legend('True','P=5','P=10','P=20','Location','SouthWest');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('ML');
grid on;set(gca,'FontSize',14);axis square;
set(gcf,'Position',[0 0 ss(3)-500 450]);
sgtitle('CE+AE | BER | Grouped by Algorithm');
figure;%group by pilot count---
subplot(131);%p=5
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(1,:),'b-*');hold on;
semilogy(SNR_dB,AE_BER_RLS(1,:),'b-d');hold on;
semilogy(SNR_dB,CE_BER_LMS(1,:),'m-*');hold on;
semilogy(SNR_dB,AE_BER_LMS(1,:),'m-d');hold on;
semilogy(SNR_dB,CE_BER_ML(1,:),'r-*');hold on;
legend('True','CE-RLS','AE-RLS','CE-LMS','AE-LMS','ML','Location','SouthWest');
ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('P=5');
grid on;set(gca,'FontSize',14);axis square;
subplot(132);%p=10
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(2,:),'b-*');hold on;
semilogy(SNR_dB,AE_BER_RLS(2,:),'b-d');hold on;
semilogy(SNR_dB,CE_BER_LMS(2,:),'m-*');hold on;
semilogy(SNR_dB,AE_BER_LMS(2,:),'m-d');hold on;
semilogy(SNR_dB,CE_BER_ML(2,:),'r-*');hold on;
legend('True','CE-RLS','AE-RLS','CE-LMS','AE-LMS','ML','Location','SouthWest');
ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('P=10');
grid on;set(gca,'FontSize',14);axis square;
subplot(133);%p=20
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(3,:),'b-*');hold on;
semilogy(SNR_dB,AE_BER_RLS(3,:),'b-d');hold on;
semilogy(SNR_dB,CE_BER_LMS(3,:),'m-*');hold on;
semilogy(SNR_dB,AE_BER_LMS(3,:),'m-d');hold on;
semilogy(SNR_dB,CE_BER_ML(3,:),'r-*');hold on;
legend('True','CE-RLS','AE-RLS','CE-LMS','AE-LMS','ML','Location','SouthWest');
ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('P=20');
grid on;set(gca,'FontSize',14);axis square;
set(gcf,'Position',[0 ss(4) ss(3)-500 450]);
sgtitle('CE+AE | BER | Grouped by Pilot Count');
%BER PLOTS---
figure;%group by pilot count---
subplot(131);%p=5
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(1,:),'b-*');hold on;
semilogy(SNR_dB,CE_BER_LMS(1,:),'m-*');hold on;
semilogy(SNR_dB,CE_BER_ML(1,:),'r-*');hold on;
legend('True','RLS','LMS','ML');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('P=5');
grid on;set(gca,'FontSize',14);axis square;
subplot(132);%p=10
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(2,:),'b-*');hold on;
semilogy(SNR_dB,CE_BER_LMS(2,:),'m-*');hold on;
semilogy(SNR_dB,CE_BER_ML(2,:),'r-*');hold on;
legend('True','RLS','LMS','ML');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('P=10');
grid on;set(gca,'FontSize',14);axis square;
subplot(133);%p=20
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(3,:),'b-*');hold on;
semilogy(SNR_dB,CE_BER_LMS(3,:),'m-*');hold on;
semilogy(SNR_dB,CE_BER_ML(3,:),'r-*');hold on;
legend('True','RLS','LMS','ML');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('P=20');
grid on;set(gca,'FontSize',14);axis square;
set(gcf,'Position',[0 ss(4) ss(3)-500 450]);
sgtitle('Channel Estimation | BER | Grouped by Pilot Count');
figure;%group by algorithm---
subplot(131);%RLS
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_RLS(1,:),'r-*');hold on;
semilogy(SNR_dB,CE_BER_RLS(2,:),'g-*');hold on;
semilogy(SNR_dB,CE_BER_RLS(3,:),'b-*');hold on;
legend('True','P=5','P=10','P=20');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('RLS');
grid on;set(gca,'FontSize',14);axis square;
subplot(132);%LMS
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_LMS(1,:),'r-*');hold on;
semilogy(SNR_dB,CE_BER_LMS(2,:),'g-*');hold on;
semilogy(SNR_dB,CE_BER_LMS(3,:),'b-*');hold on;
legend('True','P=5','P=10','P=20');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('LMS');
grid on;set(gca,'FontSize',14);axis square;
subplot(133);%ML
semilogy(SNR_dB,BER_MMSE,'k-s','LineWidth',1.2);hold on;
semilogy(SNR_dB,CE_BER_ML(1,:),'r-*');hold on;
semilogy(SNR_dB,CE_BER_ML(2,:),'g-*');hold on;
semilogy(SNR_dB,CE_BER_ML(3,:),'b-*');hold on;
legend('True','P=5','P=10','P=20');ylim([10^-4 10^0]);
xlabel('SNR(dB)');ylabel('BER');title('ML');
grid on;set(gca,'FontSize',14);axis square;
set(gcf,'Position',[0 0 ss(3)-500 450]);
sgtitle('Channel Estimation | BER | Grouped by Algorithm');
%MSE PLOTS---
figure;%group by pilot count---
subplot(131);%p=5
semilogy(SNR_dB,MSE_RLS(1,:),'b-*');hold on;
semilogy(SNR_dB,MSE_LMS(1,:),'m-*');hold on;
semilogy(SNR_dB,MSE_ML(1,:),'r-*');hold on;
legend('RLS','LMS','ML');ylim([10^-6 10^0]);
xlabel('SNR(dB)');ylabel('Avg. MSE');title('P=5');
grid on;set(gca,'FontSize',14);axis square;
subplot(132);%p=10
semilogy(SNR_dB,MSE_RLS(2,:),'b-*');hold on;
semilogy(SNR_dB,MSE_LMS(2,:),'m-*');hold on;
semilogy(SNR_dB,MSE_ML(2,:),'r-*');hold on;
legend('RLS','LMS','ML');ylim([10^-6 10^0]);
xlabel('SNR(dB)');ylabel('Avg. MSE');title('P=10');
grid on;set(gca,'FontSize',14);axis square;
subplot(133);
semilogy(SNR_dB,MSE_RLS(3,:),'b-*');hold on;
semilogy(SNR_dB,MSE_LMS(3,:),'m-*');hold on;
semilogy(SNR_dB,MSE_ML(3,:),'r-*');hold on;
legend('RLS','LMS','ML');ylim([10^-6 10^0]);
xlabel('SNR(dB)');ylabel('Avg. MSE');title('P=20');
grid on;set(gca,'FontSize',14);axis square;
set(gcf,'Position',[0 ss(4) ss(3)-500 450]);
sgtitle('Channel Estimation | MSE | Grouped by Pilot Count');
figure;%group by algorithm---
subplot(131);
semilogy(SNR_dB,MSE_RLS(1,:),'r-*');hold on;
semilogy(SNR_dB,MSE_RLS(2,:),'g-*');hold on;
semilogy(SNR_dB,MSE_RLS(3,:),'b-*');hold on;
legend('P=5','P=10','P=20');ylim([10^-6 10^0]);
xlabel('SNR(dB)');ylabel('Avg. MSE');title('RLS');
grid on;set(gca,'FontSize',14);axis square;
subplot(132);
semilogy(SNR_dB,MSE_LMS(1,:),'r-*');hold on;
semilogy(SNR_dB,MSE_LMS(2,:),'g-*');hold on;
semilogy(SNR_dB,MSE_LMS(3,:),'b-*');hold on;
legend('P=5','P=10','P=20');ylim([10^-6 10^0]);
xlabel('SNR(dB)');ylabel('Avg. MSE');title('LMS');
grid on;set(gca,'FontSize',14);axis square;
subplot(133);
semilogy(SNR_dB,MSE_ML(1,:),'r-*');hold on;
semilogy(SNR_dB,MSE_ML(2,:),'g-*');hold on;
semilogy(SNR_dB,MSE_ML(3,:),'b-*');hold on;
legend('P=5','P=10','P=20');ylim([10^-6 10^0]);
xlabel('SNR(dB)');ylabel('Avg. MSE');title('ML');
grid on;set(gca,'FontSize',14);axis square;
set(gcf,'Position',[0 0 ss(3)-500 450]);
sgtitle('Channel Estimation | MSE | Grouped by Algorithm');
%ESTIMATION PLOTS---
figure;%group by pilot count---
subplot(131);%p=5
stem(h,'k-s','LineWidth',1.2);hold on;
stem(h_RLS(:,1),'b-*');hold on;
stem(h_LMS(:,1),'m-*');hold on;
stem(h_ML(:,1),'r-*');hold on;
legend('True','RLS','LMS','ML');ylim([-1 1]);xlim([0 6]);
xticks([1 2 3 4 5]);xticklabels({'0','1','2','3','4'});
xlabel('l');ylabel('h_{l}');title('P=5');
grid on;set(gca,'FontSize',14);
subplot(132);%p=10
stem(h,'k-s','LineWidth',1.2);hold on;
stem(h_RLS(:,2),'b-*');hold on;
stem(h_LMS(:,2),'m-*');hold on;
stem(h_ML(:,2),'r-*');hold on;
legend('True','RLS','LMS','ML');ylim([-1 1]);xlim([0 6]);
xticks([1 2 3 4 5]);xticklabels({'0','1','2','3','4'});
xlabel('l');ylabel('h_{l}');title('P=10');
grid on;set(gca,'FontSize',14);
subplot(133);%p=20
stem(h,'k-s','LineWidth',1.2);hold on;
stem(h_RLS(:,3),'b-*');hold on;
stem(h_LMS(:,3),'m-*');hold on;
stem(h_ML(:,3),'r-*');hold on;
legend('True','RLS','LMS','ML');ylim([-1 1]);xlim([0 6]);
xticks([1 2 3 4 5]);xticklabels({'0','1','2','3','4'});
xlabel('l');ylabel('h_{l}');title('P=20');
grid on;set(gca,'FontSize',14);
set(gcf,'Position',[0 ss(4) ss(3)-500 450]);
sgtitle('Channel Estimation | h | Grouped by Pilot Count');
figure;%group by algorithm---
subplot(131);%rls
stem(h,'k-s');hold on;
stem(h_RLS(:,1),'r-*');hold on;
stem(h_RLS(:,2),'g-*');hold on;
stem(h_RLS(:,3),'b-*');hold on;
legend('True','P=5','P=10','P=20');ylim([-1 1]);xlim([0 6]);
xticks([1 2 3 4 5]);xticklabels({'0','1','2','3','4'});
xlabel('l');ylabel('h_{l}');title('RLS');
grid on;set(gca,'FontSize',14);
subplot(132);
stem(h,'k-s');hold on;
stem(h_LMS(:,1),'r-*');hold on;
stem(h_LMS(:,2),'g-*');hold on;
stem(h_LMS(:,3),'b-*');hold on;
legend('True','P=5','P=10','P=20');ylim([-1 1]);xlim([0 6]);
xticks([1 2 3 4 5]);xticklabels({'0','1','2','3','4'});
xlabel('l');ylabel('h_{l}');title('LMS');
grid on;set(gca,'FontSize',14);
subplot(133);%rls
stem(h,'k-s');hold on;
stem(h_ML(:,1),'r-*');hold on;
stem(h_ML(:,2),'g-*');hold on;
stem(h_ML(:,3),'b-*');hold on;
legend('True','P=5','P=10','P=20');ylim([-1 1]);xlim([0 6]);
xticks([1 2 3 4 5]);xticklabels({'0','1','2','3','4'});
xlabel('l');ylabel('h_{l}');title('ML');
grid on;set(gca,'FontSize',14);
set(gcf,'Position',[0 0 ss(3)-500 450]);
sgtitle('Channel Estimation | h | Grouped by Algorithm');
