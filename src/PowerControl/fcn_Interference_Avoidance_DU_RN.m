function [transmission_second power_second]=fcn_Interference_Avoidance_DU_RN(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold,self_interference_channel_gain_AP)
candidate_list=zeros(1,num_up_STA);
power_second=0;
count=0;
for i=1:num_up_STA
    
    if power_transmit_AP+channel_gain_withAP(2,transmission_first)-pow2db(db2pow(noise_power)+...
            db2pow(power_transmit_STA(1,1)+channel_gain(transmission_first,traffic_reg_second(i,1))))>=d_avo_threshold
        count=count+1;
        candidate_list(1,count)=traffic_reg_second(i,1);
    end
end
if  count~=0
    transmission_second=candidate_list(1,unidrnd(count,1));
    
    rate_reg=zeros(1,size(power_transmit_STA,2));
    for i=1:size(power_transmit_STA,2)
        if power_transmit_AP+channel_gain_withAP(2,transmission_first)-pow2db(db2pow(noise_power)+...
            db2pow(power_transmit_STA(1,i)+channel_gain(transmission_first,transmission_second)))>=d_avo_threshold
        rate_reg(1,i)=log2(1+db2pow(power_transmit_STA(1,i)+channel_gain_withAP(1,transmission_second)-pow2db(db2pow(noise_power)+db2pow(power_transmit_AP+self_interference_channel_gain_AP))));
        end 
    end
    [~,opt_pow_index]=max(rate_reg); 
    power_second=power_transmit_STA(1,opt_pow_index);
else
    transmission_second=0;
end



end