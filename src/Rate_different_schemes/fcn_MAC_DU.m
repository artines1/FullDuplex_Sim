function [transmission_second ]=fcn_MAC_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,power_transmit_AP,power_transmit_STA, time)
%MAC: Decide second transmission station by out MAC design
StationB_RecieveTone=zeros(1,num_up_STA);
Interference_ratio=zeros(1,num_up_STA);
K=10; % System constant factor for broadcast tone
global History_SINR_Data;
historical_ratio = 0.2;

%% Step1: Ap transmit a packet to station A
SignalAPtoA = db2pow(power_transmit_AP) * db2pow(channel_gain_withAP(2,transmission_first));

%% Step2: Station A broadcast a tone
%Prepare broadcast tone vaule
BroadCastTone = K / SignalAPtoA;
%Broadcast...
for i=1:num_up_STA
    StationB_RecieveTone(1,i) = db2pow(power_transmit_STA) * db2pow(channel_gain(transmission_first,traffic_reg_second(i,1))) * BroadCastTone;
end

%% Step3: Station B calculate Interference ratio
% For every station B, it calculate its interference ratio according to
% historical data and received tone
for i=1:num_up_STA   
    Interference_ratio(1,i) = ((StationB_RecieveTone(1,i) / db2pow(power_transmit_STA)) / K) * db2pow(power_transmit_STA);
    Interference_ratio(1,i) = 1 / Interference_ratio(1,i);
    
    current_interference = Interference_ratio(1,i);
    temp_second_idx = traffic_reg_second(i,1);
    
    if time == 1
        History_SINR_Data(temp_second_idx, transmission_first) = current_interference;
    else        
        Interference_ratio(1,i) = (current_interference * (1 - historical_ratio)) + (History_SINR_Data(temp_second_idx, transmission_first) * historical_ratio);
        % update historical data
        History_SINR_Data(temp_second_idx, transmission_first) = ((History_SINR_Data(temp_second_idx, transmission_first) * (time - 1)) + current_interference) / time;
    end
end
%% Step4: Pick the station with the biggest interference ratio as desire station
MAX_Ratio = Interference_ratio(1,1);
MAX_Index = traffic_reg_second(1,1);

for i=1:num_up_STA
    if Interference_ratio(1,i) >= MAX_Ratio
        MAX_Ratio=Interference_ratio(1,i);
        MAX_Index=traffic_reg_second(i,1);
    end
end

transmission_second=MAX_Index;
end

