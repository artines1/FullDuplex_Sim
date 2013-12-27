function [transmission_second power_second]=fcn_Interference_Avoidance_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold,self_interference_channel_gain_AP)
candidate_list=zeros(2,size(power_transmit_STA,2)*num_up_STA);% row1: STA index row2: power index
power_second=0;
count=0;
for i=1:num_up_STA
    for j=1:size(power_transmit_STA,2)
        if power_transmit_AP+channel_gain_withAP(2,transmission_first)-pow2db(db2pow(noise_power)+...
                db2pow(power_transmit_STA(1,j)+channel_gain(transmission_first,traffic_reg_second(i,1))))>=d_avo_threshold
            count=count+1;
            candidate_list(1,count)=traffic_reg_second(i,1);
            candidate_list(2,count)=j;
        end
        
    end
end
if  count~=0
    
    rate_reg=zeros(1,count);
    for i=1:count
        rate_reg(1,i)=log2(1+db2pow(power_transmit_STA(1,candidate_list(2,i))+channel_gain_withAP(1,candidate_list(1,i))-pow2db(db2pow(noise_power)+db2pow(power_transmit_AP+self_interference_channel_gain_AP))));
    end
    
    [~,max_rate_index]=max(rate_reg);
    opt_pow_index=candidate_list(2,max_rate_index);  
    transmission_second=candidate_list(1,max_rate_index);
    power_second=power_transmit_STA(1,opt_pow_index);
else
    transmission_second=0;
end



end