%                                                                         %
%                          Bitirme Odevi                                  %
%                          MMSE Methodu                                   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc, clear, close all

K_t = 20;              %users
BS_r = 30;               %BS antennas, N >= K
SNR_dB = 1:30;          %in [dB]
Eb_No = 10.^(SNR_dB/10);
N = K_t;                %data length = K
tekrar = 100000;

T = zeros(1,length(SNR_dB));
T_temp = zeros(1,length(tekrar));
for count = 1:length(SNR_dB)
    ort_hata = 0;
    for j=1:tekrar
    
        H = randn(BS_r, K_t);   %Gaussian normal variables with zero-mean and unit-variance

        arr = randi([0 1], 1, N);   %1xN'lik [0, 1] dizisi
        x_t = 2*arr - 1;            %transmitted signal, BPSK mod. => [-1,1] dizisi 
        x_t = x_t';
        x_r = awgn(H*(x_t), SNR_dB(count), 'measured');   %x_r = H*x_t + n 
        
        tic;  
        I = eye(K_t,K_t);
        H_mmse = (H'*H + I*SNR_dB(count)/K_t)^(-1)*H';
        z = (H_mmse) * x_r;

        z(z > 0) = 1;
        z(z < 0) = -1;

        
        hata = 0;

        for k=1:N % 1 ve -1'e, 0.1 ve -0.1'e yanlış karar verildiğinde hata sayısı 1 arttı. 
            if (z(k)~=x_t(k))
                hata = hata + 1;
            end
        end    
        hata = hata/N; % Her bir tekrardaki Bit Hata Oranı (BER)     
        ort_hata = ort_hata + hata; % Bir sonraki adımda BER hesaplamak için hatalar ortalamaya eklendi.
        T_temp(1,j) = toc;
    end
    T(count) = mean(T_temp);
    T_temp =[];    
    
    bit_hata_orani(count) = ort_hata/tekrar;    % Hataların ortalaması alınarak BER hesaplandı.
end

semilogy(SNR_dB, bit_hata_orani, '-r*');
% hold on
axis([min(SNR_dB) max(SNR_dB) 10^(-5) 1]);
xlabel('SNR,dB')
ylabel('Bit Error Rate')
legend('MMSE');