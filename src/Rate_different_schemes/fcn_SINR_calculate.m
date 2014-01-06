    
function [record_SINR]=fcn_SINR_calculate(record_traffic,power_transmit_AP,power_transmit_STA,channel_gain_withAP,channel_gain,noise_power,self_interference_channel_gain_AP)
    record_SINR=zeros(2,1);% row1: uplink row2:downlink row3: estimate uplink row4: estimate downlink
    if record_traffic(1,1)~=0 && record_traffic(2,1)~=0 % up and down link simultaneously
        record_SINR(1,1)=power_transmit_STA+channel_gain_withAP(1,record_traffic(1,1))-pow2db(db2pow(noise_power)+db2pow(power_transmit_AP+self_interference_channel_gain_AP));
        record_SINR(2,1)=power_transmit_AP+channel_gain_withAP(2,record_traffic(2,1))-pow2db(db2pow(noise_power)+db2pow(power_transmit_STA+channel_gain(record_traffic(2,1),record_traffic(1,1))));
        record_SINR(3,1)=power_transmit_STA+channel_gain_withAP(1,record_traffic(1,1))-pow2db(db2pow(noise_power)+db2pow(power_transmit_AP+self_interference_channel_gain_AP));
        record_SINR(4,1)=power_transmit_AP+channel_gain_withAP(2,record_traffic(2,1))-noise_power;
    elseif record_traffic(1,1)==0 && record_traffic(2,1)~=0 % only downlink
        record_SINR(2,1)=power_transmit_AP+channel_gain_withAP(2,record_traffic(2,1))-noise_power;
        record_SINR(4,1)=power_transmit_AP+channel_gain_withAP(2,record_traffic(2,1))-noise_power;
    elseif record_traffic(1,1)~=0 && record_traffic(2,1)==0 % only uplink
        record_SINR(1,1)=power_transmit_STA+channel_gain_withAP(1,record_traffic(1,1))-noise_power;
        record_SINR(3,1)=power_transmit_STA+channel_gain_withAP(1,record_traffic(1,1))-noise_power;
    else
        record_SINR(1,1)=0;
    end
end