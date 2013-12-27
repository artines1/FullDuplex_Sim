function [transmission_second ]=fcn_SINR_Maxmin_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA)
% SINR max-min up-down: choose a STA such that the minimum SINR of uplink and downlink is maximized 
% In this case, since the chioce of downlink STA is independent of uplink SINR, we just choose a STA such that the receiver (downlink) STA's SINR is maximized 
SINR_STA=zeros(1,num_dn_STA);
for i=1:num_dn_STA
    SINR_STA(1,i)=power_transmit_AP+channel_gain_withAP(2,traffic_reg_second(i,1))-pow2db(db2pow(noise_power)+db2pow(power_transmit_STA+channel_gain(traffic_reg_second(i,1),transmission_first)));

end

maxmin_SINR=SINR_STA(1,1);
for i=1:num_dn_STA
    if SINR_STA(1,i) >= maxmin_SINR
        maxmin_SINR=SINR_STA(1,i);
        maxmin_SINR_index=traffic_reg_second(i,1);
    end
end

transmission_second=maxmin_SINR_index;

end