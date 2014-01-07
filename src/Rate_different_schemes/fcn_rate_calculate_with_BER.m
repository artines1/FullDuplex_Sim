function [ave_rate] = fcn_rate_calculate_with_BER(record_SINR, SINR_Boundary)
%FCN_RATE_CALCULATE_WITH_BER Summary of this function goes here
%   Calculate Rate according to SINR and BER

Rate = [54, 36, 18, 9];
Rate_idx_up = 4; %default with 9 mbps
Rate_idx_down = 4;
ave_rate=zeros(1,3);
ave_rate_tmp=zeros(size(record_SINR,2),3); % column1:sumrate column2:uplink rate column3: downlink rate

for t=1:size(record_SINR,2)
    %% estimate rate for up-link
    for i=1:size(SINR_Boundary,2)        
      	if record_SINR(3,t) > SINR_Boundary(i)
            Rate_idx_up = i;
            break;
        end
    end
    %% estimate rate for down-link
    for i=1:size(SINR_Boundary,2)        
      	if record_SINR(4,t) > SINR_Boundary(i)
            Rate_idx_down = i;
            break;
        end
    end
    
    if record_SINR(1,t)~=0&&record_SINR(2,t)~=0 % up and down link simultaneously
        temp_BER_up = fcn_GetBERFromSINR(record_SINR(1,t), Rate_idx_up);
        temp_BER_down = fcn_GetBERFromSINR(record_SINR(2,t), Rate_idx_down);
        ave_rate_tmp(t,2)=randsrc(1,1,[0 1; temp_BER_up 1-temp_BER_up]) * Rate(Rate_idx_up);
        ave_rate_tmp(t,3)=randsrc(1,1,[0 1; temp_BER_down 1-temp_BER_down]) * Rate(Rate_idx_down);
        ave_rate_tmp(t,1)= ave_rate_tmp(t,2) + ave_rate_tmp(t,3);
    elseif record_SINR(1,t)==0&&record_SINR(2,t)~=0 % only downlink
        temp_BER_down = fcn_GetBERFromSINR(record_SINR(2,t), Rate_idx_down);
        ave_rate_tmp(t,3)=randsrc(1,1,[0 1; temp_BER_down 1-temp_BER_down]) * Rate(Rate_idx_down);
        ave_rate_tmp(t,1)=ave_rate_tmp(t,3);
    elseif record_SINR(1,t)~=0&&record_SINR(2,t)==0% only uplink
        temp_BER_up = fcn_GetBERFromSINR(record_SINR(1,t), Rate_idx_up);
        ave_rate_tmp(t,2)=randsrc(1,1,[0 1; temp_BER_up 1-temp_BER_up]) * Rate(Rate_idx_up);
        ave_rate_tmp(t,1)=ave_rate_tmp(t,2);
    end
    
end
ave_rate(1,1)=mean(ave_rate_tmp(:,1));
ave_rate(1,2)=mean(ave_rate_tmp(:,2));
ave_rate(1,3)=mean(ave_rate_tmp(:,3));
end

