function [ BER ] = fcn_GetBERFromSINR( SINR, Rate_idx )
%FCN_GETBERFROMSINR Summary of this function goes here
%   Detailed explanation goes here

switch Rate_idx
    case 1 % 64-QAM
        BER = berfading(pow2db(db2pow(SINR)/6), 'qam', 64, 1);
    case 2 % 16-QAM
        BER = berfading(pow2db(db2pow(SINR)/4), 'qam', 16, 1);
    case 3 % QPSK
        BER = berfading(pow2db(db2pow(SINR)/2), 'psk', 4, 1);
    case 4 % BPSK
        BER = berfading(pow2db(db2pow(SINR)/1), 'psk', 2, 1);
end

end

