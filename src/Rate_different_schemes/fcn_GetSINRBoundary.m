function [ SINR_Boundary ] = fcn_GetSINRBoundary( Target_BER )
% Calculate Boundary SINR value for different modulation by given target
% BER

Temp_Boundary = zeros(1, 4);
SNR = [-95:30];
snr_num = size(SNR, 2);
EbN0 = zeros(1, snr_num);

%% First get 64-QAM
EbN0 = pow2db(db2pow(SNR) / log2(64));

for i=1:snr_num
    temp_ber = berfading(EbN0(i), 'qam', 64, 1);
    
    if(temp_ber <= Target_BER)
        Temp_Boundary(1) = SNR(i);
        break;
    end
end

%% Second get 16-QAM
EbN0 = pow2db(db2pow(SNR) / log2(16));

for i=1:snr_num
    temp_ber = berfading(EbN0(i), 'qam', 16, 1);
    
    if(temp_ber <= Target_BER)
        Temp_Boundary(2) = SNR(i);
        break;
    end
end

%% Second get QPSK
EbN0 = pow2db(db2pow(SNR) / log2(4));

for i=1:snr_num
    temp_ber = berfading(EbN0(i), 'psk', 4, 1);
    
    if(temp_ber <= Target_BER)
        Temp_Boundary(3) = SNR(i);
        break;
    end
end

%% Second get BPSK
EbN0 = pow2db(db2pow(SNR) / log2(2));

for i=1:snr_num
    temp_ber = berfading(EbN0(i), 'psk', 2, 1);
    
    if(temp_ber <= Target_BER)
        Temp_Boundary(4) = SNR(i);
        break;
    end
end

SINR_Boundary = Temp_Boundary;


end

