function [transmission_second]=fcn_SINR_Maximization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA)
% SINR maximization: choose a STA such that receiver STA's SINR is maximized
SINR_reg=zeros(1,num_dn_STA);
for i=1:num_dn_STA
    SINR_reg(1,i)=power_transmit_AP+channel_gain_withAP(2,traffic_reg_second(i))-pow2db(db2pow(noise_power)+db2pow(power_transmit_STA+channel_gain(traffic_reg_second(i,1),transmission_first)));
end
max_SINR=SINR_reg(1,1);
for i=1:num_dn_STA
    if SINR_reg(1,i) >= max_SINR
        max_SINR=SINR_reg(1,i);
        max_SINR_index=traffic_reg_second(i,1);
    end
end
transmission_second=max_SINR_index;
end