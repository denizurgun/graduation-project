clc, clear all, close all

%% SABİT LR - DEĞİŞKEN LR KARŞILAŞTIRMASI
clc, clear all, close all
% Decay LR
snr = [ 8.  9. 10. 11. 12. 13.]
bers = [0.032168   0.01771593 0.00846025 0.0035607  0.00141873 0.00063888]
% times
% [[1.52057990e-05 1.52088654e-05 1.52452317e-05 1.51884587e-05
%   1.52314736e-05 1.52643890e-05]]

semilogy(snr,bers, '-rs')

%Decaysiz

snr1 = [ 8  9 10 11 12 13]
ber1 = [0.07953248, 0.0596645,  0.03998898, 0.02344375 ,0.01205283 ,0.00554843]
hold on
semilogy(snr1,ber1, '-b*')


grid on
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
axis([min(snr) max(snr) 10^(-4) 1]);
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
legend('Değişken Öğrenme Hızı','Sabit Öğrenme Hızı');
title('DetNet SNR - BER Grafiği')

%% Sabit Öğrenme Hızlı - Sabit Öğrenmeli + ResNet'li model
clc, clear all, close all
%detnet
snr1 = [ 8  9 10 11 12 13]
ber1 = [0.07953248, 0.0596645,  0.03998898, 0.02344375 ,0.01205283 ,0.00554843]

semilogy(snr1,ber1, '-b*')

%resnet
ber_resnet = [0.03313038 0.0180843  0.00850815 0.00349725 0.00130225 0.00048948]

hold on
semilogy(snr1,ber_resnet, '-rs')


grid on
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
axis([min(snr1) max(snr1) 10^(-4) 1]);
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
legend('DetNet','DetNet + ResNet');

title('DetNet SNR - BER Grafiği')


%% Değişken Öğrenmeli - Değişken Öğrenmeli + ResNet - Sabit Öğrenme - Değişken Öğrenme (Hepsinin Karşılaştırması)
clc, clear all, close all

% Decay LR
snr = [ 8.  9. 10. 11. 12. 13.]
bers = [0.032168   0.01771593 0.00846025 0.0035607  0.00141873 0.00063888]
% times
% [[1.52057990e-05 1.52088654e-05 1.52452317e-05 1.51884587e-05
%   1.52314736e-05 1.52643890e-05]]

semilogy(snr,bers, '-bs')

%Decaysiz

snr1 = [ 8  9 10 11 12 13]
ber1 = [0.07953248, 0.0596645,  0.03998898, 0.02344375 ,0.01205283 ,0.00554843]
hold on
semilogy(snr1,ber1, '-r*')



%resnet
ber_resnet = [0.03313038 0.0180843  0.00850815 0.00349725 0.00130225 0.00048948]

hold on
semilogy(snr1,ber_resnet, '-rs')

grid on
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
axis([min(snr) max(snr) 10^(-4) 1]);
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
legend('Değişken Öğrenme Hızı','Sabit Öğrenme Hızı');
title('DetNet SNR - BER Grafiği')



%% DetNet - ML
% clc, clear all, close all

snr_lr = [ 1.  2.  3.  4.  5.  6.  7.  8.  9. 10. 11. 12. 13. 14. ] %
ber_lr = [0.18215412 0.15847798 0.1343693  0.11024947 0.08630392 0.06326228 0.04240725 0.02530385 0.01313003 0.0058605  0.00229305 0.0008604 0.00038548  0.00029815]
% ber_lr = [0.188952   0.16606618 0.14333885 0.12058967 0.09806905 0.07591733 0.0546348  0.03531698 0.0199064  0.00956898 0.00400685 0.00156965 0.00070815 0.00114738]

% times
% [[3.08800837e-05 3.06936755e-05 3.05065849e-05 3.08943181e-05
%   3.16965516e-05 3.09281237e-05 3.11285272e-05 3.05858335e-05
%   3.03470351e-05 3.02804869e-05 3.06123149e-05 3.06142011e-05
%   3.10651217e-05 3.10329102e-05]]

%  ber2 = load('ML_20x30_YENI.mat')
ber2 = load('ML_20x30_timingli_ber.mat')
ber2 = ber2.bit_hata_orani

semilogy(snr_lr,ber_lr, '-b*')
hold on
semilogy(snr_lr,ber2, '-rs')
grid on
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
axis([min(snr_lr) max(snr_lr) 10^(-4) 1]);
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
legend('DetNet','ML');

%% DetNet - zf - mmse - ml

clc, clear all, close all

snr_lr = [ 1.  2.  3.  4.  5.  6.  7.  8.  9. 10. 11. 12. 13. 14. ] %
% ber_lr = [0.18215412 0.15847798 0.1343693  0.11024947 0.08630392 0.06326228 0.04240725 0.02530385 0.01313003 0.0058605  0.00229305 0.0008604 0.00038548  0.00029815]

ber_lr =[1.85729080e-01 1.64311170e-01 1.42508505e-01 1.20211765e-01 9.73364001e-02 7.42843350e-02 5.19958850e-02 3.23308051e-02 1.73182401e-02 7.87455501e-03 3.08027001e-03 1.08503500e-03 3.70645002e-04 1.39875001e-04]
% times
% [[1.73460597e-05 1.74504577e-05 1.89623566e-05 1.87858795e-05
%   1.72037392e-05 1.74567618e-05 1.73804951e-05 1.72981185e-05
%   1.79607626e-05 1.90438216e-05 1.72281596e-05 1.73679178e-05
%   2.08937448e-05 2.17333846e-05]]
ber2 = load('ML_20X30_10000.mat')
ber2 = ber2.bit_hata_orani

ber3 = load('ZF_20x30_YENI.mat')
ber3 = ber3.bit_hata_orani

ber4 = load('MMSE_20x30_YENI.mat')
ber4 = ber4.bit_hata_orani


semilogy(snr_lr,ber_lr, '-b*')
hold on

semilogy(snr_lr,ber2, '-rs')

hold on
semilogy(snr_lr,ber3, '-gs')

hold on
semilogy(snr_lr,ber4, '-rs')

grid on
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
axis([min(snr_lr) max(snr_lr) 10^(-4) 1]);
xlabel('SNR,dB')
ylabel('Bit Hata Oranı')
legend('DetNet','ML','ZF','MMSE');

%% LOSS

loss = [21.257736, 6.4701657, 2.4237506, 1.4488958, 0.899854, 0.6160803, 0.43617806, 0.34193066, 0.29471478, 0.2616226, 0.28589895, 0.31335017, 0.3066115, 0.33049968, 0.33112925, 0.29904118, 0.3268696, 0.31372815, 0.32027668, 0.34231454, 0.354719, 0.33742395, 0.35546023, 0.32994315, 0.33537242, 0.30936292, 0.34264567, 0.346546, 0.38501, 0.35947815, 0.3156597, 0.331326, 0.3314019, 0.32364035, 0.36518642, 0.33099887, 0.41669545, 0.37531602, 0.3823068, 0.3792616, 0.33829638, 0.34961498, 0.34014964, 0.41042903, 0.33678424, 0.3459601, 0.34594452, 0.3758209, 0.3397256, 0.3375822, 0.346864, 0.34854436, 0.32893795, 0.32290334, 0.33448085, 0.34851593, 0.3503931, 0.33102047, 0.34828165, 0.38133013, 0.3383114, 0.3424028, 0.34046775, 0.32476652, 0.3378103, 0.3121893, 0.31660977, 0.37369114, 0.33497444, 0.35643956, 0.36538807, 0.34595528, 0.3496866, 0.37985456, 0.35564822, 0.35693714, 0.35512695, 0.339022, 0.3457393, 0.33150604, 0.33743554, 0.35395384, 0.32654452, 0.3254975, 0.30219057, 0.3353031, 0.3263982, 0.30913827, 0.30499616, 0.33629155, 0.33467254, 0.32971048, 0.35439417, 0.35831898, 0.35140565, 0.33364302, 0.35268342, 0.34486508, 0.32182857, 0.3323552]

semilogy(loss, '-b')
grid on
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
% axis([min(0) max(loss) 10^(-4) 1]);
xlabel('İterasyon Sayısı')
ylabel('Kayıp')

