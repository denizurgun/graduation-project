clc
clear all
close all

SNR_dB = 1:30; 


%% ZF
clc
clear all
close all

SNR_dB = 1:30; 

%ZF 6x10 anten sayili sonuc:
bit_hata_orani1 = load('ZF_8x24_ber.mat')
bit_hata_orani1 = bit_hata_orani1.bit_hata_orani

% ZF 8x24 anten sayili sonuc:
bit_hata_orani2 = load('ZF_8x48_ber.mat')
bit_hata_orani2 = bit_hata_orani2.bit_hata_orani

%ZF 6x30 anten sayili sonuc:
bit_hata_orani3 = load('ZF_10x24_ber.mat')
bit_hata_orani3 = bit_hata_orani3.bit_hata_orani


semilogy(SNR_dB, bit_hata_orani1, '-b*');
hold on

semilogy(SNR_dB, bit_hata_orani2, '-r*');
hold on

semilogy(SNR_dB, bit_hata_orani3, '-g*');

axis([min(SNR_dB) max(SNR_dB) 10^(-5) 1]);

title('ZF SNR - BER Grafiği')
legend('N_t = 8, N_r = 24', 'N_t = 8, N_r = 48', 'N_t = 10, N_r = 24');
grid on
hold on
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
%% MMSE
clc
clear all
close all

SNR_dB = 1:30; 

%ZF 6x10 anten sayili sonuc:
bit_hata_orani1 = load('MMSE_8x24_ber.mat')
bit_hata_orani1 = bit_hata_orani1.bit_hata_orani

% ZF 8x24 anten sayili sonuc:
bit_hata_orani2 = load('MMSE_8x48_ber.mat')
bit_hata_orani2 = bit_hata_orani2.bit_hata_orani

%ZF 6x30 anten sayili sonuc:
bit_hata_orani3 = load('MMSE_10x24_ber.mat')
bit_hata_orani3 = bit_hata_orani3.bit_hata_orani


semilogy(SNR_dB, bit_hata_orani1, '-b*');
hold on

semilogy(SNR_dB, bit_hata_orani2, '-r*');
hold on

semilogy(SNR_dB, bit_hata_orani3, '-g*');

axis([min(SNR_dB) max(SNR_dB) 10^(-5) 1]);

title('MMSE SNR - BER Grafiği')
legend('N_t = 8, N_r = 24', 'N_t = 8, N_r = 48', 'N_t = 10, N_r = 24');
grid on
hold on
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')


%% ML
clc
clear all
close all

SNR_dB = 1:30; 


%ZF 6x10 anten sayili sonuc:
bit_hata_orani1 = load('ML_8x24_ber.mat')
bit_hata_orani1 = bit_hata_orani1.bit_hata_orani

%ZF 6x30 anten sayili sonuc:
bit_hata_orani2 = load('ML_8x48_ber.mat')
bit_hata_orani2 = bit_hata_orani2.bit_hata_orani


% ZF 8x24 anten sayili sonuc:
bit_hata_orani3 = load('ML_10x24_ber.mat')
bit_hata_orani3 = bit_hata_orani3.bit_hata_orani
semilogy(SNR_dB, bit_hata_orani1, '-b*');
hold on

semilogy(SNR_dB, bit_hata_orani2, '-r*');
hold on

semilogy(SNR_dB, bit_hata_orani3, '-g*');

axis([min(SNR_dB) max(SNR_dB) 10^(-5) 1]);

title('ML SNR - BER Grafiği')
legend('N_t = 8, N_r = 24', 'N_t = 8, N_r = 48', 'N_t = 10, N_r = 24');
grid on
hold on
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')

%% LOSS
e = readtable("loss_20x30.xltx");

plot(loss20x2(1,:))
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')

xlabel('İterasyon Sayısı')
ylabel('Kayıp')