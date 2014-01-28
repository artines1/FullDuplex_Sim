function [transmission_second, upLink_power ]=fcn_MAC_Power_Fair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,power_transmit_AP,power_transmit_STA, time, History_enable, SINR_Diff_Limit, Noise_Power_db)
%MAC: Decide second transmission station by out MAC design
StationB_RecieveTone=zeros(1,num_up_STA);
StationB_Power=zeros(1,num_up_STA);
K=10; % System constant factor for broadcast tone
global History_SINR_Data;
historical_ratio = 0.2;
Power_Constraint_db=5;
Power_Constraint=db2pow(Power_Constraint_db);

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
% For every station B, it calculate its interference ratio and desire power according to
% historical data and received tone
for i=1:num_up_STA       
    temp_second_idx = traffic_reg_second(i,1);
    
    %Estimate First station's SNR
    SNR_FirstStation = (((StationB_RecieveTone(1,i) / K) / db2pow(power_transmit_STA)) / db2pow(channel_gain(transmission_first,traffic_reg_second(i,1)))); 
    SNR_FirstStation = SNR_FirstStation * db2pow(Noise_Power_db);
    SNR_FirstStation = 1 / SNR_FirstStation;
    
    if History_enable ~= 1
        StationB_Power(1,i) = ((db2pow(SINR_Diff_Limit) - 1) * db2pow(Noise_Power_db)) / db2pow(channel_gain(transmission_first,traffic_reg_second(i,1)));              
    else
        estimate_SNR = (SNR_FirstStation * (1 - historical_ratio)) + (historical_ratio * History_SINR_Data(temp_second_idx, transmission_first));
        estimate_SNR = pow2db(estimate_SNR);
        desire_SINR = estimate_SNR - SINR_Diff_Limit;
        power_desire_SINR = db2pow(desire_SINR);
        
        
        StationB_Power(1,i) = (db2pow(power_transmit_STA) * K * db2pow(channel_gain(transmission_first,traffic_reg_second(i,1)))) / StationB_RecieveTone(1,i);
        StationB_Power(1,i) = (StationB_Power(1,i) / power_desire_SINR) - db2pow(Noise_Power_db);
        StationB_Power(1,i) = StationB_Power(1,i) / db2pow(channel_gain(transmission_first,traffic_reg_second(i,1)));                
        
        %StationB_Power(1,i) =  (db2pow(SINR_Diff_Limit) / estimate_SNR) - (1 / SNR_FirstStation); 
        %StationB_Power(1,i) =  StationB_Power(1,i) * K * db2pow(power_transmit_STA) / StationB_RecieveTone(1,i);
    end
    
    if StationB_Power(1,i) > db2pow(power_transmit_STA)
        StationB_Power(1,i) = db2pow(power_transmit_STA);
    end
    
    
    
    if time == 1
        History_SINR_Data(temp_second_idx, transmission_first) = SNR_FirstStation;
    else        
        % update historical data
        History_SINR_Data(temp_second_idx, transmission_first) = ((History_SINR_Data(temp_second_idx, transmission_first) * (time - 1)) + SNR_FirstStation) / time;
    end
end
%% Step4: Fairly pick a station 
available_station_num = 0;
available_station_list = [];

while available_station_num <= 0
    available_station_list = find(abs(StationB_Power(1,:)) >= Power_Constraint);
    available_station_num = size(available_station_list, 2);
    
    Power_Constraint_db=Power_Constraint_db-1;
    Power_Constraint=db2pow(Power_Constraint_db);
end


trans_station = unidrnd(available_station_num,1);

transmission_second=traffic_reg_second(available_station_list(trans_station), 1);
upLink_power=pow2db(abs(StationB_Power(1, available_station_list(trans_station))));
end

