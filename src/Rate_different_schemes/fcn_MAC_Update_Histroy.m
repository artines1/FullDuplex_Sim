function [ output_history_data, output_count ] = fcn_MAC_Update_Histroy( History_SINR_Data, History_count, transmission_first, num_STA, channel_gain, channel_gain_withAP, power_transmit_AP, power_transmit_STA, Noise_Power_db )
%MAC: Update history data
K=10; % System constant factor for broadcast tone
ReceiveTone=zeros(1 , num_STA);

% Create the tone that transmit from first station
SignalAPtoA = db2pow(power_transmit_AP) * db2pow(channel_gain_withAP(2,transmission_first));
BroadCastTone = K / SignalAPtoA;

% Assume every station can receive tone except the station transmit this
% tone
for i=1:num_STA
    if i ~= transmission_first
        ReceiveTone(1,i) = db2pow(power_transmit_STA) * db2pow(channel_gain(transmission_first, i)) * BroadCastTone;
    end
end

% For each station, it updates its history data relate to first station
for i=1:num_STA
    if i ~= transmission_first
        %Estimate First station's SNR
        SNR_FirstStation = (((ReceiveTone(1,i) / K) / db2pow(power_transmit_STA)) / db2pow(channel_gain(transmission_first,i))); 
        SNR_FirstStation = SNR_FirstStation * db2pow(Noise_Power_db);
        SNR_FirstStation = 1 / SNR_FirstStation;
        
        if History_count(i, transmission_first) == 0           
            %first record
            History_SINR_Data(i, transmission_first) = SNR_FirstStation;
            History_count(i, transmission_first)= History_count(i, transmission_first) + 1;
        else
            % Use cumulative  moving average
            History_SINR_Data(i, transmission_first)= History_SINR_Data(i, transmission_first)+((SNR_FirstStation - History_SINR_Data(i, transmission_first))/(History_count(i, transmission_first)+1));
            History_count(i, transmission_first)= History_count(i, transmission_first) + 1;
        end
    end
end

output_history_data=History_SINR_Data;
output_count=History_count;


end

