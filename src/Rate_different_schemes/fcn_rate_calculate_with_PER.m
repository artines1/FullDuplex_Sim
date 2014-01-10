function [ave_rate] = fcn_rate_calculate_with_PER(record_SINR, snrtable, packet_size, target_PER)
%FCN_RATE_CALCULATE_WITH_BER Summary of this function goes here
%   Calculate Rate according to SINR and BER

real_PER_up = 0;
real_PER_down = 0;

ave_rate=zeros(1,3);
ave_rate_tmp=zeros(size(record_SINR,2),3); % column1:sumrate column2:uplink rate column3: downlink rate

for t=1:size(record_SINR,2)
    %% estimate rate for up-link
    temp_idx = find(snrtable(:,1) <= record_SINR(3,t), 8, 'last');
    if size(temp_idx, 1) == 0
        real_PER_up = 1;
    else
        for i=size(temp_idx, 1):-1:1
            temp_per = 1 - (snrtable(temp_idx(i,1), 3) ^ packet_size);
            
            if temp_per <= target_PER
                Rate_idx_up = i;
                real_rate_idx = find(snrtable(:,1) <= record_SINR(1,t), 1, 'last') - 8 + Rate_idx_up;
                if size(real_rate_idx, 1) == 0
                    real_PER_up = 1;
                else
                    real_PER_up = 1 - snrtable(real_rate_idx, 3);
                end
                break;
            end
        end
    end
    
    %% estimate rate for down-link
    temp_idx = find(snrtable(:,1) <= record_SINR(4,t), 8, 'last');
    if size(temp_idx, 1) == 0
        real_PER_down = 1;
    else
        for i=size(temp_idx, 1):-1:1
            temp_per = 1 - (snrtable(temp_idx(i,1), 3) ^ packet_size);
            
            if temp_per <= target_PER
                Rate_idx_down = i;
                real_rate_idx = find(snrtable(:,1) <= record_SINR(2,t), 1, 'last') - 8 + Rate_idx_up;
                if size(real_rate_idx, 1) == 0
                    real_PER_down = 1;
                else
                    real_PER_down = 1 - snrtable(real_rate_idx, 3);
                end
                break;
            end
        end
    end
    
    if record_SINR(1,t)~=0&&record_SINR(2,t)~=0 % up and down link simultaneously                        
        ave_rate_tmp(t,2)=(1-temp_BER_up) * log2(1+db2pow(record_SINR(1,t)));
        ave_rate_tmp(t,3)=(1-temp_BER_down) * log2(1+db2pow(record_SINR(2,t)));
        ave_rate_tmp(t,1)= ave_rate_tmp(t,2) + ave_rate_tmp(t,3);
    elseif record_SINR(1,t)==0&&record_SINR(2,t)~=0 % only downlink
        ave_rate_tmp(t,3)=(1-temp_BER_down) * log2(1+db2pow(record_SINR(2,t)));
        ave_rate_tmp(t,1)=ave_rate_tmp(t,3);
    elseif record_SINR(1,t)~=0&&record_SINR(2,t)==0% only uplink
        ave_rate_tmp(t,2)=(1-temp_BER_up) * log2(1+db2pow(record_SINR(1,t)));
        ave_rate_tmp(t,1)=ave_rate_tmp(t,2);
    end
    
end
ave_rate(1,1)=mean(ave_rate_tmp(:,1));
ave_rate(1,2)=mean(ave_rate_tmp(:,2));
ave_rate(1,3)=mean(ave_rate_tmp(:,3));
end

