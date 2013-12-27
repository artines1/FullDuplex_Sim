function [transmission_second ]=fcn_SINR_Maxmin_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP)
% SINR max-min down-up: choose a STA such that the minimum SINR of uplink and downlink is maximized 
SINR_STA=zeros(1,num_up_STA);
SINR_AP=zeros(1,num_up_STA);
SINR_min=zeros(1,num_up_STA);
for i=1:num_up_STA
    SINR_STA(1,i)=power_transmit_AP+channel_gain_withAP(2,transmission_first)-pow2db(db2pow(noise_power)+db2pow(power_transmit_STA+channel_gain(transmission_first,traffic_reg_second(i,1))));
    SINR_AP(1,i)=power_transmit_STA+channel_gain_withAP(1,traffic_reg_second(i,1))-pow2db(db2pow(noise_power)+db2pow(power_transmit_AP+self_interference_channel_gain_AP));
end

for i=1:num_up_STA
    if SINR_AP(1,i) <= SINR_STA(1,i)
        SINR_min(1,i)=SINR_AP(1,i);
    else
         SINR_min(1,i)=SINR_STA(1,i);
    end
end

maxmin_SINR=SINR_min(1,1);
for i=1:num_up_STA
    if SINR_min(1,i) >= maxmin_SINR
        maxmin_SINR=SINR_min(1,i);
        maxmin_SINR_index=traffic_reg_second(i,1);
    end
end

transmission_second=maxmin_SINR_index;

end