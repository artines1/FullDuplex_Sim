function [ transmission_second ] = fcn_MAC_CW_UD( transmission_first,traffic_reg_second,num_dn_STA,channel_gain,channel_gain_withAP,noise_power,power_transmit_AP,power_transmit_STA )
%FCN_MAC_CW_UD Summary of this function goes here
%   Detailed explanation goes here
DownStation_RecievedIndicator=zeros(1,num_dn_STA);
AP_RecievedTone=zeros(1,num_dn_STA);
K=10; % System constant factor for broadcast tone


%% First, Up-stream station sends an indicator to AP which will also been heard by other down-stream station
for i=1:num_dn_STA
    DownStation_RecievedIndicator(1,i) = db2pow(power_transmit_STA) * db2pow(channel_gain(transmission_first,traffic_reg_second(i,1)));
end

%% Second convert the recieved indicator into tone
DownStation_Tone = (DownStation_RecievedIndicator.^-1) * K;

%% Third Down stream station sends its tone to AP
for i=1:num_dn_STA
    AP_RecievedTone(1,i) = db2pow(power_transmit_STA) * db2pow(channel_gain_withAP(2,traffic_reg_second(i,1))) * DownStation_Tone(1,i);
end

%% Forth, calculate down station SINR based on the received tone
SINR_down = AP_RecievedTone / K;

%% Fifth, pick the station with the greatest SINR

[~,Max_index]=max(SINR_down);
transmission_second=traffic_reg_second(Max_index,1);
end

