function [transmission_second, upLink_power ]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,power_transmit_AP,power_transmit_STA, History_SINR_Data, History_enable, SINR_Diff_Limit, Noise_Power_db)
%MAC: Decide second transmission station by out MAC design
StationB_RecieveTone=zeros(1,num_up_STA);
StationB_Power=zeros(1,num_up_STA);
SINR_After_PowerContorl=zeros(1,num_up_STA);
CW_Size=zeros(1, num_up_STA);
CW_Value=zeros(1, num_up_STA);
K=10; % System constant factor for broadcast tone
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
        temp_history_SINR = History_SINR_Data(temp_second_idx, transmission_first);
        
        if temp_history_SINR == 0
            temp_history_SINR = SNR_FirstStation;
        end
        
        estimate_SNR = (SNR_FirstStation * (1 - historical_ratio)) + (historical_ratio * temp_history_SINR);
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
    
end
%% Step4: Contention 
% A. Initiate Contention Window
for i=1:num_up_STA
    SINR_After_PowerContorl = pow2db(abs(StationB_Power(1, i))) + channel_gain_withAP(2,traffic_reg_second(i,1)) - Noise_Power_db;
    if(SINR_After_PowerContorl >= 10)
        CW_Size(1,i)=31;
    else
        CW_Size(1,i)=1023;
    end
end

% B. Contention
pick_station=0;

while 1
    for i=1:num_up_STA
        if CW_Size(1,i) ~= 0
            CW_Value(1,i)=unidrnd(CW_Size(1,i),1);
        else
            CW_Value(1,i)=99999;
        end
    end
    
    temp_min = min(CW_Value);
    candidates = find(CW_Value==temp_min); 
    
    if size(candidates,2) == 1
        pick_station = candidates(1);
        break;
    else
        % double the contention window   
        if max(CW_Size) < 1023
            CW_Size=CW_Size * 2 + 1;
        end
        
        % set loser of contention size to zero indicate they are abandoned           
        for i=1:num_up_STA
            if ~ismember(i, candidates)
                CW_Size(1,i)=0;
            end                     
        end
    end
    
end



transmission_second=traffic_reg_second(pick_station, 1);
upLink_power=pow2db(abs(StationB_Power(1, pick_station)));
end

