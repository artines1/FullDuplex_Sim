function [transmission_second]=fcn_SumRate_Maximization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP)
%sum rate maximization: choose a STA such that sum rate is maximized
sumrate_reg=zeros(1,num_up_STA);
for i=1:num_up_STA
    sumrate_reg(1,i)=log2(1+db2pow(power_transmit_STA+channel_gain_withAP(1,traffic_reg_second(i,1))-pow2db(db2pow(noise_power)+db2pow(power_transmit_AP+self_interference_channel_gain_AP))))...
        +log2(1+db2pow(power_transmit_AP+channel_gain_withAP(2,transmission_first)-pow2db(db2pow(noise_power)+db2pow(power_transmit_STA+channel_gain(transmission_first,traffic_reg_second(i,1))))));
end
[~,Max_index]=max(sumrate_reg);
transmission_second=traffic_reg_second(Max_index,1);
end