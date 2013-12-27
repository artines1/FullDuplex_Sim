function [transmission_second]=fcn_Interference_Minimization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain)
% interference minimization down-up: choose STA who cause minimum interference to
% receiver STA (downlink STA)
min_interference=channel_gain(transmission_first,traffic_reg_second(1,1)); 
for i=1:num_up_STA
    if channel_gain(transmission_first,traffic_reg_second(i,1)) <= min_interference
        min_interference=channel_gain(transmission_first,traffic_reg_second(i,1));
        min_interference_index=traffic_reg_second(i,1);
    end
end
transmission_second=min_interference_index;

end