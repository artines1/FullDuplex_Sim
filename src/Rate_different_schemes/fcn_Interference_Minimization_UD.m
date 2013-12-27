function [transmission_second]=fcn_Interference_Minimization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain)
% interference minimization up-down: choose STA who is less interfered by
% transmitter STA (uplink STA)
min_interference=channel_gain(traffic_reg_second(1,1),transmission_first); % P.S. channel gain is a negative value in dB
for i=1:num_dn_STA
    if channel_gain(traffic_reg_second(i,1),transmission_first) <= min_interference
        min_interference=channel_gain(traffic_reg_second(i,1),transmission_first);
        min_interference_index=traffic_reg_second(i,1);
    end
end
transmission_second=min_interference_index;

end