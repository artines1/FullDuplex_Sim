function [transmission_second]=fcn_Interference_Avoidance_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold)
% interference avoidance: random choose one STA from those STAs who let the receiver STA's SINR is larger than a threshold 
SINR_reg=zeros(1,num_up_STA);
SINR_largerthanthreshold=zeros(1,num_up_STA);
for i=1:num_up_STA % calculate SINR
    SINR_reg(1,i)=power_transmit_AP+channel_gain_withAP(2,transmission_first)-pow2db(db2pow(noise_power)+db2pow(power_transmit_STA+channel_gain(transmission_first,traffic_reg_second(i,1))));
end
count=0;
for i=1:num_up_STA % record STA who match the treshold 
    if SINR_reg(1,i)>=d_avo_threshold
        count=count+1;
        SINR_largerthanthreshold(1,count)=traffic_reg_second(i,1);
    end
end

if count~=0
    transmission_second=SINR_largerthanthreshold(unidrnd(count,1));% randomly chosen
else
    transmission_second=0;
end



end