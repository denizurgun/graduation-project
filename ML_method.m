%                                                                         %
%                          Bitirme Odevi                                  %
%                      Maximum Likelihood Methodu                         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc, clear, close all

K_t = 20;              %users
BS_r = 30;               %BS antennas, N >= K
SNR_dB = 1:14;          %in [dB]
Eb_No = 10.^(SNR_dB/10);
N = K_t;                %data length = K
tekrar = 10000;

T = zeros(1,length(SNR_dB));
T1 = zeros(1,length(SNR_dB));
T_temp = zeros(1,length(tekrar));
T_temp1 = zeros(1,length(tekrar));

for i = 1: 2^K_t
        
        x_value =  dec2bin(i-1,K_t);
        for l = 1:K_t
            x_sapka(i,l) = str2double(x_value(l));
        end
     x_sapka(i,:) = 2*x_sapka(i,:) -1;
        
end
% x_sapka = load('ML_x_sapka.mat')
% x_sapka =x_sapka.x_sapka;
for count = 1:length(SNR_dB)
    ort_hata = 0;
    for j=1:tekrar

        H_reel= randn(BS_r, K_t);   %Gaussian normal variables with zero-mean and unit-variance
        H = H_reel ;

        arr = randi([0 1], 1, N);   %1xN'lik [0, 1] dizisi
        x_t = 2*arr - 1;            %transmitted signal, BPSK mod. => [-1,1] dizisi
        x_t = x_t';
        x_r = awgn(H*(x_t), SNR_dB(count), 'measured');   %x_r = H*x_t + n 

        tic;  
        tStart = tic;
        for i = 1: 2^K_t
         
            if i == 1
                min1 = norm(x_r - H*(x_sapka(i,:)'));
                index =i;
            else 
                min_new = norm(x_r- H*(x_sapka(i,:)'));
                if min_new<min1
                    Jmin = norm(min_new);
                    min1 = min_new;
                    index = i;     
                end
            end
        end
        y = x_sapka(index,:)';
        T_temp(1,j) = toc;
        
        hata = 0;
        for k=1:N % 1 ve -1'e, 0.1 ve -0.1'e yanlış karar verildiğinde hata sayısı 1 arttı. 
            if (y(k)~=x_t(k))
                hata = hata + 1;
            end

        end    
        hata = hata/N; % Her bir tekrardaki Bit Hata Oranı (BER)
       
        ort_hata = ort_hata + hata; % Bir sonraki adımda BER hesaplamak için hatalar ortalamaya eklendi.
        
        T_temp1(1,j) = toc(tStart);
    end
    T(count) = mean(T_temp);
    T1(count) = mean(T_temp1);
    T_temp =[];
    T_temp1 =[];
    bit_hata_orani(count) = ort_hata/tekrar;    % Hataların ortalaması alınarak BER hesaplandı.

    
end

semilogy(SNR_dB, bit_hata_orani, '-b*');
axis([min(SNR_dB) max(SNR_dB) 10^(-5) 1]);
grid on
xlabel('SNR,dB')
ylabel('Bit Error Rate')
set(gca, 'FontName', 'Century')
set(gca,'FontSize',14)
set(gca,'FontWeight','bold')
hold on
