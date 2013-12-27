function [ave_rate]=fcn_rate_calculate(record_SINR)
% record_SINR(1,:): SINR of AP;record_SINR(2,:): SINR of STA
ave_rate=zeros(1,3);
ave_rate_tmp=zeros(size(record_SINR,2),3); % column1:sumrate column2:uplink rate column3: downlink rate

for t=1:size(record_SINR,2)
    if record_SINR(1,t)~=0&&record_SINR(2,t)~=0
        ave_rate_tmp(t,1)=log2(1+db2pow(record_SINR(1,t)))+log2(1+db2pow(record_SINR(2,t)));
        ave_rate_tmp(t,2)=log2(1+db2pow(record_SINR(1,t)));
        ave_rate_tmp(t,3)=log2(1+db2pow(record_SINR(2,t)));
    elseif record_SINR(1,t)==0&&record_SINR(2,t)~=0
       ave_rate_tmp(t,1)=log2(1+db2pow(record_SINR(2,t)));
       ave_rate_tmp(t,3)=log2(1+db2pow(record_SINR(2,t)));
    elseif record_SINR(1,t)~=0&&record_SINR(2,t)==0
        ave_rate_tmp(t,1)=log2(1+db2pow(record_SINR(1,t)));
        ave_rate_tmp(t,2)=log2(1+db2pow(record_SINR(1,t)));
    end
end
ave_rate(1,1)=mean(ave_rate_tmp(:,1));
ave_rate(1,2)=mean(ave_rate_tmp(:,2));
ave_rate(1,3)=mean(ave_rate_tmp(:,3));
end