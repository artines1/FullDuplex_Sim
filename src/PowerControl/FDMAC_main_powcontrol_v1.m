%Full-duplex MAC simulation by Shih Ying Chen
%This version modify v2 s.t.
% 1. the channel are reciprocal 2. the area is circle
clear all;
clc;
%% parameters setting
center_frequency=2.4*10^9;
number_STAs=100;% The total number of STAs
number_nodes=number_STAs+1;
radius=250;% meter
power_transmit_AP=10;% 10dBm=-20dBwatt
power_transmit_STA=0.5:0.5:10;% 10dBm=-20dBwatt
d_avo_threshold=4;%dB
total_time=100;
pro_up=0.8;
pro_down=0.8;
Monte_Carlo_T=1000;
%initial up/down probability
pro_STAs=zeros(2,number_STAs);
for i=1:number_STAs
    pro_STAs(1,i)=pro_up;
    pro_STAs(2,i)=pro_down;
end
%--
%% var: self_interference_channel_gain_STA
self_interference_channel_gain_STA=-70:-5:-100;
SNR_input=100;%dB
noise_power=power_transmit_AP-SNR_input;% -90dBm=-120dBwatt

K=size(self_interference_channel_gain_STA,2);
ave_rate_IA_DU=zeros(K,3); % column1:sumrate column2:uplink rate column3: downlink rate
ave_rate_IA_DU_RN=zeros(K,3);
ave_power_IA_DU=zeros(K,1); 
ave_power_IA_DU_RN=zeros(K,1);
% ave_rate_IM_DU=zeros(K,3);
% ave_rate_SM_DU=zeros(K,3);
% ave_rate_SMM_DU=zeros(K,3);
% ave_rate_SRM_DU=zeros(K,3);
% ave_rate_HD_DU=zeros(K,3);
% 
% ave_rate_IA_UD=zeros(K,3); % column1:sumrate column2:uplink rate column3: downlink rate
% ave_rate_IM_UD=zeros(K,3);
% ave_rate_SM_UD=zeros(K,3);
% ave_rate_SMM_UD=zeros(K,3);
% ave_rate_SRM_UD=zeros(K,3);
% ave_rate_HD_UD=zeros(K,3);

% ave_SINR_IA_DU_AP=zeros(K,1);
% ave_SINR_IM_DU_AP=zeros(K,1);
% ave_SINR_SM_DU_AP=zeros(K,1);
% ave_SINR_SMM_DU_AP=zeros(K,1);
% ave_SINR_SRM_DU_AP=zeros(K,1);
% ave_SINR_HD_DU_AP=zeros(K,1);
% 
% ave_SINR_IA_UD_AP=zeros(K,1);
% ave_SINR_IM_UD_AP=zeros(K,1);
% ave_SINR_SM_UD_AP=zeros(K,1);
% ave_SINR_SMM_UD_AP=zeros(K,1);
% ave_SINR_SRM_UD_AP=zeros(K,1);
% ave_SINR_HD_UD_AP=zeros(K,1);

% ave_SINR_IA_DU_STA=zeros(K,1);
% ave_SINR_IM_DU_STA=zeros(K,1);
% ave_SINR_SM_DU_STA=zeros(K,1);
% ave_SINR_SMM_DU_STA=zeros(K,1);
% ave_SINR_SRM_DU_STA=zeros(K,1);
% ave_SINR_HD_DU_STA=zeros(K,1);
% 
% ave_SINR_IA_UD_STA=zeros(K,1);
% ave_SINR_IM_UD_STA=zeros(K,1);
% ave_SINR_SM_UD_STA=zeros(K,1);
% ave_SINR_SMM_UD_STA=zeros(K,1);
% ave_SINR_SRM_UD_STA=zeros(K,1);
% ave_SINR_HD_UD_STA=zeros(K,1);

% ave_traffic_IA_DU_U=zeros(K,1);
% ave_traffic_IM_DU_U=zeros(K,1);
% ave_traffic_SM_DU_U=zeros(K,1);
% ave_traffic_SMM_DU_U=zeros(K,1);
% ave_traffic_SRM_DU_U=zeros(K,1);
% ave_traffic_HD_DU_U=zeros(K,1);
% 
% ave_traffic_IA_UD_U=zeros(K,1);
% ave_traffic_IM_UD_U=zeros(K,1);
% ave_traffic_SM_UD_U=zeros(K,1);
% ave_traffic_SMM_UD_U=zeros(K,1);
% ave_traffic_SRM_UD_U=zeros(K,1);
% ave_traffic_HD_UD_U=zeros(K,1);
% 
% ave_traffic_IA_DU_D=zeros(K,1);
% ave_traffic_IM_DU_D=zeros(K,1);
% ave_traffic_SM_DU_D=zeros(K,1);
% ave_traffic_SMM_DU_D=zeros(K,1);
% ave_traffic_SRM_DU_D=zeros(K,1);
% ave_traffic_HD_DU_D=zeros(K,1);
% 
% ave_traffic_IA_UD_D=zeros(K,1);
% ave_traffic_IM_UD_D=zeros(K,1);
% ave_traffic_SM_UD_D=zeros(K,1);
% ave_traffic_SMM_UD_D=zeros(K,1);
% ave_traffic_SRM_UD_D=zeros(K,1);
% ave_traffic_HD_UD_D=zeros(K,1);


%% Monte Carlo method

for k=1:K
    self_interference_channel_gain_AP=self_interference_channel_gain_STA(1,k);
    for T=1:Monte_Carlo_T
        %% andom deploy STAs in a circle
        u=unifrnd(0,radius,[1,number_STAs])+unifrnd(0,radius,[1,number_STAs]);
        r=zeros(1,number_STAs);
        for i=1:size(u,2)
            if u(1,i)>radius
                r(1,i)=2*radius-u(1,i);
            else
                r(1,i)=u(1,i);
            end
        end
        theta=unifrnd(0,2*pi,[1,number_STAs]);
        coordinate_x=r.*cos(theta);
        coordinate_y=r.*sin(theta);
        coordinate=[coordinate_x;coordinate_y];
        %% calculate distances
        distance=zeros(number_STAs,number_STAs);
        for i=1:number_STAs-1
            for j=i+1:number_STAs
                distance(i,j)=sqrt((coordinate(1,i)-coordinate(1,j))^2+(coordinate(2,i)-coordinate(2,j))^2);
                distance(j,i)=distance(i,j);
            end
        end
        distance_withAP=zeros(1,number_STAs);
        for i=1:number_STAs
            distance_withAP(1,i)=sqrt((coordinate(1,i))^2+(coordinate(2,i))^2);
        end
        %% calculate pathloss gain
        pathloss_gain=-(20*log10(distance)+20*log10(center_frequency)-147.55);%dB
        for i=1:number_STAs
            pathloss_gain(i,i)=self_interference_channel_gain_STA(1,k);
        end
        pathloss_gain_withAP=-(20*log10(distance_withAP)+20*log10(center_frequency)-147.55);%dB
        %% Rayleigh fading
        fading_gain=pow2db(exprnd(1,number_STAs,number_STAs,total_time));%channelgain(row,cloumn)=STA1<-STA2
        fading_gain_withAP=pow2db(exprnd(1,2,number_STAs,total_time));%row1: uplink(STA->AP) row2: downlink(AP->STA)
        %channel  reciprocal
        fading_gain_withAP(2,:,:)=fading_gain_withAP(1,:,:);
        for t=1:total_time
            fading_gain(:,:,t)=triu(fading_gain(:,:,t))+triu(fading_gain(:,:,t),1).';
            
        end
        
        %% channel gain
        channel_gain=zeros(number_STAs,number_STAs,total_time);
        channel_gain_withAP=zeros(2,number_STAs,total_time);%row1: uplink(STA->AP) row2: downlink(AP->STA)
        for t=1:total_time
            channel_gain(:,:,t)= pathloss_gain;
            channel_gain_withAP(1,:,t)=pathloss_gain_withAP;
            channel_gain_withAP(2,:,t)=pathloss_gain_withAP;
        end
        channel_gain=channel_gain+fading_gain;
        channel_gain_withAP=channel_gain_withAP+fading_gain_withAP;
        %% generate traffic
        traffic_up=zeros(number_STAs,total_time);
        traffic_down=zeros(number_STAs,total_time);
        for i=1:number_STAs
            traffic_up(i,:)=randsrc(1,total_time,[1 0;pro_STAs(1,i) 1-pro_STAs(1,i)]);
            traffic_down(i,:)=randsrc(1,total_time,[1 0;pro_STAs(2,i) 1-pro_STAs(2,i)]);
        end
        
        record_traffic_IA_DU=zeros(2,total_time);%row1:uplink row2:downlink
        record_traffic_IA_DU_RN=zeros(2,total_time);
%         record_traffic_IM_DU=zeros(2,total_time);
%         record_traffic_SM_DU=zeros(2,total_time);
%         record_traffic_SMM_DU=zeros(2,total_time);
%         record_traffic_SRM_DU=zeros(2,total_time);
%         record_traffic_HD_DU=zeros(2,total_time);
        
        record_SINR_IA_DU=zeros(2,total_time);%row1:AP row2:user
        record_SINR_IA_DU_RN=zeros(2,total_time);
%         record_SINR_IM_DU=zeros(2,total_time);
%         record_SINR_SM_DU=zeros(2,total_time);
%         record_SINR_SMM_DU=zeros(2,total_time);
%         record_SINR_SRM_DU=zeros(2,total_time);
%         record_SINR_HD_DU=zeros(2,total_time);
        
%         record_traffic_IA_UD=zeros(2,total_time);
%         record_traffic_IM_UD=zeros(2,total_time);
%         record_traffic_SM_UD=zeros(2,total_time);
%         record_traffic_SMM_UD=zeros(2,total_time);
%         record_traffic_SRM_UD=zeros(2,total_time);
%         record_traffic_HD_UD=zeros(2,total_time);
        
        record_power_IA_DU=zeros(1,total_time);
        record_power_IA_DU_RN=zeros(1,total_time);
        
%         record_SINR_IA_UD=zeros(2,total_time);
%         record_SINR_IM_UD=zeros(2,total_time);
%         record_SINR_SM_UD=zeros(2,total_time);
%         record_SINR_SMM_UD=zeros(2,total_time);
%         record_SINR_SRM_UD=zeros(2,total_time);
%         record_SINR_HD_UD=zeros(2,total_time);
        
        traffic_reg_first=zeros(number_STAs,1);%record traffic requirement of STAs for first transmission at each time slot
        traffic_reg_second=zeros(number_STAs,1);%record traffic requirement of STAs for second transmission at each time slot
        
        for t=1:total_time
            channel_gain_temp=channel_gain(:,:,t);
            channel_gain_withAP_temp=channel_gain_withAP(:,:,t);
            %% DOWN-UP
            traffic_reg_first(:,:)=0;
            traffic_reg_second(:,:)=0;
            transmission_first=0;
            %transmission_second=0;
            
            num_dn_STA=0;
            for i=1:number_STAs
                if traffic_down(i,t)==1
                    num_dn_STA=num_dn_STA+1;
                    traffic_reg_first(num_dn_STA,1)=i;
                end
            end
            %--
            if num_dn_STA~=0 % There's at least one downlink traffic
                %choose downlink STAs
                transmission_first=traffic_reg_first(unidrnd(num_dn_STA,1));
                
                %--
                %choose uplink STAs
                
                
                %initial traffic_reg_second
                num_up_STA=0;
                for i=1:number_STAs
                    if traffic_up(i,t)==1 && i~=transmission_first;% Single-link is not permitted
                        num_up_STA=num_up_STA+1;
                        traffic_reg_second(num_up_STA,1)=i;
                    end
                end
                if  num_up_STA~=0
                    [record_traffic_IA_DU(1,t) record_power_IA_DU(1,t)]=fcn_Interference_Avoidance_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold,self_interference_channel_gain_AP);
                    [record_traffic_IA_DU_RN(1,t) record_power_IA_DU_RN(1,t)]=fcn_Interference_Avoidance_DU_RN(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold,self_interference_channel_gain_AP);
%                     [record_traffic_IM_DU(1,t)]=fcn_Interference_Minimization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp);
%                     [record_traffic_SM_DU(1,t)]=fcn_SINR_Maximization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA);
%                     [record_traffic_SMM_DU(1,t)]=fcn_SINR_Maxmin_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP);
%                     [record_traffic_SRM_DU(1,t)]=fcn_SumRate_Maximization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP);
                else
                    record_traffic_IA_DU(1,t)=0;
                    record_traffic_IA_DU_RN(1,t)=0;
%                     record_traffic_IM_DU(1,t)=0;
%                     record_traffic_SM_DU(1,t)=0;
%                     record_traffic_SMM_DU(1,t)=0;
%                     record_traffic_SRM_DU(1,t)=0;
                end
            else % There's no downlink traffic
                %initial traffic_reg_second
                num_up_STA=0;
                for i=1:number_STAs
                    if traffic_up(i,t)==1
                        num_up_STA=num_up_STA+1;
                        traffic_reg_second(num_up_STA,1)=i;
                    end
                end
                %--
                %choose uplink STAs
                if num_up_STA~=0
                    record_traffic_IA_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                    record_traffic_IA_DU_RN(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
%                     record_traffic_IM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
%                     record_traffic_SM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
%                     record_traffic_SMM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
%                     record_traffic_SRM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
%                     record_traffic_HD_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                else
                    record_traffic_IA_DU(1,t)=0;
                    record_traffic_IA_DU_RN(1,t)=0;
%                     record_traffic_IM_DU(1,t)=0;
%                     record_traffic_SM_DU(1,t)=0;
%                     record_traffic_SMM_DU(1,t)=0;
%                     record_traffic_SRM_DU(1,t)=0;
%                     record_traffic_HD_DU(1,t)=0;
                end
                %--
            end
            
            record_traffic_IA_DU(2,t)=transmission_first;
            record_traffic_IA_DU_RN(2,t)=transmission_first;
%             record_traffic_IM_DU(2,t)=transmission_first;
%             record_traffic_SM_DU(2,t)=transmission_first;
%             record_traffic_SMM_DU(2,t)=transmission_first;
%             record_traffic_SRM_DU(2,t)=transmission_first;
%             record_traffic_HD_DU(2,t)=transmission_first;
            
            [record_SINR_IA_DU(:,t)]=fcn_SINR_calculate(record_traffic_IA_DU(:,t),power_transmit_AP,record_power_IA_DU(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
            [record_SINR_IA_DU_RN(:,t)]=fcn_SINR_calculate(record_traffic_IA_DU_RN(:,t),power_transmit_AP,record_power_IA_DU_RN(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_IM_DU(:,t)]=fcn_SINR_calculate(record_traffic_IM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_SM_DU(:,t)]=fcn_SINR_calculate(record_traffic_SM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_SMM_DU(:,t)]=fcn_SINR_calculate(record_traffic_SMM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_SRM_DU(:,t)]=fcn_SINR_calculate(record_traffic_SRM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_HD_DU(:,t)]=fcn_SINR_calculate(record_traffic_HD_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
            %% UP-DOWN
%             traffic_reg_first(:,:)=0;
%             traffic_reg_second(:,:)=0;
%             transmission_first=0;
%             transmission_second=0;
%             
%             num_up_STA=0;
%             for i=1:number_STAs
%                 if traffic_up(i,t)==1
%                     num_up_STA=num_up_STA+1;
%                     traffic_reg_first(num_up_STA,1)=i;
%                 end
%             end
%             %--
%             if num_up_STA~=0 % There's at least one uplink traffic
%                 %choose uplink STAs
%                 transmission_first=traffic_reg_first(unidrnd(num_up_STA,1));
%                 %--
%                 %choose downlink STAs
%                 %initial traffic_reg_second
%                 num_dn_STA=0;
%                 for i=1:number_STAs
%                     if traffic_down(i,t)==1 && i~=transmission_first;% Single-link is not permitted
%                         num_dn_STA=num_dn_STA+1;
%                         traffic_reg_second(num_dn_STA,1)=i;
%                     end
%                 end
%                 %--
%                 if num_dn_STA~=0
%                     [record_traffic_IA_UD(2,t)]=fcn_Interference_Avoidance_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold);
%                     [record_traffic_IM_UD(2,t)]=fcn_Interference_Minimization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp);
%                     [record_traffic_SM_UD(2,t)]=fcn_SINR_Maximization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA);
%                     [record_traffic_SMM_UD(2,t) ]=fcn_SINR_Maxmin_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA);
%                     [record_traffic_SRM_UD(2,t)]=fcn_SumRate_Maximization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP);
%                     
%                 else
%                     record_traffic_IA_UD(2,t)=0;
%                     record_traffic_IM_UD(2,t)=0;
%                     record_traffic_SM_UD(2,t)=0;
%                     record_traffic_SMM_UD(2,t)=0;
%                     record_traffic_SRM_UD(2,t)=0;
%                 end
%             else % There's no uplink traffic
%                 %initial traffic_reg_second
%                 num_dn_STA=0;
%                 for i=1:number_STAs
%                     if traffic_down(i,t)==1
%                         num_dn_STA=num_dn_STA+1;
%                         traffic_reg_second(num_dn_STA,1)=i;
%                     end
%                 end
%                 %--
%                 %choose downlink STAs
%                 if num_dn_STA~=0
%                     record_traffic_IA_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
%                     record_traffic_IM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
%                     record_traffic_SM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
%                     record_traffic_SMM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
%                     record_traffic_SRM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
%                     record_traffic_HD_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
%                 else
%                     record_traffic_IA_UD(2,t)=0;
%                     record_traffic_IM_UD(2,t)=0;
%                     record_traffic_SM_UD(2,t)=0;
%                     record_traffic_SMM_UD(2,t)=0;
%                     record_traffic_SRM_UD(2,t)=0;
%                     record_traffic_HD_UD(2,t)=0;
%                 end
%                 %--
%             end
%             record_traffic_IA_UD(1,t)=transmission_first;
%             record_traffic_IM_UD(1,t)=transmission_first;
%             record_traffic_SM_UD(1,t)=transmission_first;
%             record_traffic_SMM_UD(1,t)=transmission_first;
%             record_traffic_SRM_UD(1,t)=transmission_first;
%             record_traffic_HD_UD(1,t)=transmission_first;
%             
%             [record_SINR_IA_UD(:,t)]=fcn_SINR_calculate(record_traffic_IA_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_IM_UD(:,t)]=fcn_SINR_calculate(record_traffic_IM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_SM_UD(:,t)]=fcn_SINR_calculate(record_traffic_SM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_SMM_UD(:,t)]=fcn_SINR_calculate(record_traffic_SMM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_SRM_UD(:,t)]=fcn_SINR_calculate(record_traffic_SRM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             [record_SINR_HD_UD(:,t)]=fcn_SINR_calculate(record_traffic_HD_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
%             
        end
        
        ave_rate_IA_DU(k,:)=ave_rate_IA_DU(k,:)+fcn_rate_calculate(record_SINR_IA_DU);
        ave_rate_IA_DU_RN(k,:)=ave_rate_IA_DU_RN(k,:)+fcn_rate_calculate(record_SINR_IA_DU_RN);
        ave_power_IA_DU(k,1)=ave_power_IA_DU(k,1)+sum(record_power_IA_DU(1,:))/nnz(record_traffic_IA_DU(1,:));
        ave_power_IA_DU_RN(k,1)=ave_power_IA_DU_RN(k,1)+sum(record_power_IA_DU_RN(1,:))/nnz(record_traffic_IA_DU_RN(1,:));
%         ave_rate_IM_DU(k,:)=ave_rate_IM_DU(k,:)+fcn_rate_calculate(record_SINR_IM_DU);
%         ave_rate_SM_DU(k,:)=ave_rate_SM_DU(k,:)+fcn_rate_calculate(record_SINR_SM_DU);
%         ave_rate_SMM_DU(k,:)=ave_rate_SMM_DU(k,:)+fcn_rate_calculate(record_SINR_SMM_DU);
%         ave_rate_SRM_DU(k,:)=ave_rate_SRM_DU(k,:)+fcn_rate_calculate(record_SINR_SRM_DU);
%         ave_rate_HD_DU(k,:)=ave_rate_HD_DU(k,:)+fcn_rate_calculate(record_SINR_HD_DU);
%         
%         ave_rate_IA_UD(k,:)=ave_rate_IA_UD(k,:)+fcn_rate_calculate(record_SINR_IA_UD);
%         ave_rate_IM_UD(k,:)=ave_rate_IM_UD(k,:)+fcn_rate_calculate(record_SINR_IM_UD);
%         ave_rate_SM_UD(k,:)=ave_rate_SM_UD(k,:)+fcn_rate_calculate(record_SINR_SM_UD);
%         ave_rate_SMM_UD(k,:)=ave_rate_SMM_UD(k,:)+fcn_rate_calculate(record_SINR_SMM_UD);
%         ave_rate_SRM_UD(k,:)=ave_rate_SRM_UD(k,:)+fcn_rate_calculate(record_SINR_SRM_UD);
%         ave_rate_HD_UD(k,:)=ave_rate_HD_UD(k,:)+fcn_rate_calculate(record_SINR_HD_UD);
        
%         ave_SINR_IA_DU_AP(k,1)=ave_SINR_IA_DU_AP(k,1)+sum(record_SINR_IA_DU(1,:))/nnz(record_traffic_IA_DU(1,:));
%         ave_SINR_IM_DU_AP(k,1)=ave_SINR_IM_DU_AP(k,1)+sum(record_SINR_IM_DU(1,:))/nnz(record_traffic_IM_DU(1,:));
%         ave_SINR_SM_DU_AP(k,1)=ave_SINR_SM_DU_AP(k,1)+sum(record_SINR_SM_DU(1,:))/nnz(record_traffic_SM_DU(1,:));
%         ave_SINR_SMM_DU_AP(k,1)=ave_SINR_SMM_DU_AP(k,1)+sum(record_SINR_SMM_DU(1,:))/nnz(record_traffic_SMM_DU(1,:));
%         ave_SINR_SRM_DU_AP(k,1)=ave_SINR_SRM_DU_AP(k,1)+sum(record_SINR_SRM_DU(1,:))/nnz(record_traffic_SRM_DU(1,:));
%         %      ave_SINR_HD_DU_AP(k,1)=ave_SINR_HD_DU_AP(k,1)+sum(record_SINR_HD_DU(1,:))/nnz(record_traffic_HD_DU(1,:));
%         
%         ave_SINR_IA_UD_AP(k,1)=ave_SINR_IA_UD_AP(k,1)+sum(record_SINR_IA_UD(1,:))/nnz(record_traffic_IA_UD(1,:));
%         ave_SINR_IM_UD_AP(k,1)=ave_SINR_IM_UD_AP(k,1)+sum(record_SINR_IM_UD(1,:))/nnz(record_traffic_IM_UD(1,:));
%         ave_SINR_SM_UD_AP(k,1)=ave_SINR_SM_UD_AP(k,1)+sum(record_SINR_SM_UD(1,:))/nnz(record_traffic_SM_UD(1,:));
%         ave_SINR_SMM_UD_AP(k,1)=ave_SINR_SMM_UD_AP(k,1)+sum(record_SINR_SMM_UD(1,:))/nnz(record_traffic_SMM_UD(1,:));
%         ave_SINR_SRM_UD_AP(k,1)=ave_SINR_SRM_UD_AP(k,1)+sum(record_SINR_SRM_UD(1,:))/nnz(record_traffic_SRM_UD(1,:));
%         ave_SINR_HD_UD_AP(k,1)=ave_SINR_HD_UD_AP(k,1)+sum(record_SINR_HD_UD(1,:))/nnz(record_traffic_HD_UD(1,:));
%         
%         ave_SINR_IA_DU_STA(k,1)=ave_SINR_IA_DU_STA(k,1)+sum(record_SINR_IA_DU(2,:))/nnz(record_traffic_IA_DU(2,:));
%         ave_SINR_IM_DU_STA(k,1)=ave_SINR_IM_DU_STA(k,1)+sum(record_SINR_IM_DU(2,:))/nnz(record_traffic_IM_DU(2,:));
%         ave_SINR_SM_DU_STA(k,1)=ave_SINR_SM_DU_STA(k,1)+sum(record_SINR_SM_DU(2,:))/nnz(record_traffic_SM_DU(2,:));
%         ave_SINR_SMM_DU_STA(k,1)=ave_SINR_SMM_DU_STA(k,1)+sum(record_SINR_SMM_DU(2,:))/nnz(record_traffic_SMM_DU(2,:));
%         ave_SINR_SRM_DU_STA(k,1)=ave_SINR_SRM_DU_STA(k,1)+sum(record_SINR_SRM_DU(2,:))/nnz(record_traffic_SRM_DU(2,:));
%         ave_SINR_HD_DU_STA(k,1)=ave_SINR_HD_DU_STA(k,1)+sum(record_SINR_HD_DU(2,:))/nnz(record_traffic_HD_DU(2,:));
%         
%         ave_SINR_IA_UD_STA(k,1)=ave_SINR_IA_UD_STA(k,1)+sum(record_SINR_IA_UD(2,:))/nnz(record_traffic_IA_UD(2,:));
%         ave_SINR_IM_UD_STA(k,1)=ave_SINR_IM_UD_STA(k,1)+sum(record_SINR_IM_UD(2,:))/nnz(record_traffic_IM_UD(2,:));
%         ave_SINR_SM_UD_STA(k,1)=ave_SINR_SM_UD_STA(k,1)+sum(record_SINR_SM_UD(2,:))/nnz(record_traffic_SM_UD(2,:));
%         ave_SINR_SMM_UD_STA(k,1)=ave_SINR_SMM_UD_STA(k,1)+sum(record_SINR_SMM_UD(2,:))/nnz(record_traffic_SMM_UD(2,:));
%         ave_SINR_SRM_UD_STA(k,1)=ave_SINR_SRM_UD_STA(k,1)+sum(record_SINR_SRM_UD(2,:))/nnz(record_traffic_SRM_UD(2,:));
%         %       ave_SINR_HD_UD_STA(k,1)=ave_SINR_HD_UD_STA(k,1)+sum(record_SINR_HD_UD(2,:))/nnz(record_traffic_HD_UD(2,:));
%         
%         ave_traffic_IA_DU_D(k,1)=ave_traffic_IA_DU_D(k,1)+nnz(record_traffic_IA_DU(2,:))/total_time;
%         ave_traffic_IM_DU_D(k,1)=ave_traffic_IM_DU_D(k,1)+nnz(record_traffic_IM_DU(2,:))/total_time;
%         ave_traffic_SM_DU_D(k,1)=ave_traffic_SM_DU_D(k,1)+nnz(record_traffic_SM_DU(2,:))/total_time;
%         ave_traffic_SMM_DU_D(k,1)=ave_traffic_SMM_DU_D(k,1)+nnz(record_traffic_SMM_DU(2,:))/total_time;
%         ave_traffic_SRM_DU_D(k,1)=ave_traffic_SRM_DU_D(k,1)+nnz(record_traffic_SRM_DU(2,:))/total_time;
%         ave_traffic_HD_DU_D(k,1)=ave_traffic_HD_DU_D(k,1)+nnz(record_traffic_HD_DU(2,:))/total_time;
%         
%         ave_traffic_IA_DU_U(k,1)=ave_traffic_IA_DU_U(k,1)+nnz(record_traffic_IA_DU(1,:))/total_time;
%         ave_traffic_IM_DU_U(k,1)=ave_traffic_IM_DU_U(k,1)+nnz(record_traffic_IM_DU(1,:))/total_time;
%         ave_traffic_SM_DU_U(k,1)=ave_traffic_SM_DU_U(k,1)+nnz(record_traffic_SM_DU(1,:))/total_time;
%         ave_traffic_SMM_DU_U(k,1)=ave_traffic_SMM_DU_U(k,1)+nnz(record_traffic_SMM_DU(1,:))/total_time;
%         ave_traffic_SRM_DU_U(k,1)=ave_traffic_SRM_DU_U(k,1)+nnz(record_traffic_SRM_DU(1,:))/total_time;
%         ave_traffic_HD_DU_U(k,1)=ave_traffic_HD_DU_U(k,1)+nnz(record_traffic_HD_DU(1,:))/total_time;
%         
%         ave_traffic_IA_UD_D(k,1)=ave_traffic_IA_UD_D(k,1)+nnz(record_traffic_IA_UD(2,:))/total_time;
%         ave_traffic_IM_UD_D(k,1)=ave_traffic_IM_UD_D(k,1)+nnz(record_traffic_IM_UD(2,:))/total_time;
%         ave_traffic_SM_UD_D(k,1)=ave_traffic_SM_UD_D(k,1)+nnz(record_traffic_SM_UD(2,:))/total_time;
%         ave_traffic_SMM_UD_D(k,1)=ave_traffic_SMM_UD_D(k,1)+nnz(record_traffic_SMM_UD(2,:))/total_time;
%         ave_traffic_SRM_UD_D(k,1)=ave_traffic_SRM_UD_D(k,1)+nnz(record_traffic_SRM_UD(2,:))/total_time;
%         ave_traffic_HD_UD_D(k,1)=ave_traffic_HD_UD_D(k,1)+nnz(record_traffic_HD_UD(2,:))/total_time;
%         
%         ave_traffic_IA_UD_U(k,1)=ave_traffic_IA_UD_U(k,1)+nnz(record_traffic_IA_UD(1,:))/total_time;
%         ave_traffic_IM_UD_U(k,1)=ave_traffic_IM_UD_U(k,1)+nnz(record_traffic_IM_UD(1,:))/total_time;
%         ave_traffic_SM_UD_U(k,1)=ave_traffic_SM_UD_U(k,1)+nnz(record_traffic_SM_UD(1,:))/total_time;
%         ave_traffic_SMM_UD_U(k,1)=ave_traffic_SMM_UD_U(k,1)+nnz(record_traffic_SMM_UD(1,:))/total_time;
%         ave_traffic_SRM_UD_U(k,1)=ave_traffic_SRM_UD_U(k,1)+nnz(record_traffic_SRM_UD(1,:))/total_time;
%         ave_traffic_HD_UD_U(k,1)=ave_traffic_HD_UD_U(k,1)+nnz(record_traffic_HD_UD(1,:))/total_time;
    end
    
    
    ave_rate_IA_DU(k,:)=ave_rate_IA_DU(k,:)/Monte_Carlo_T;
    ave_rate_IA_DU_RN(k,:)=ave_rate_IA_DU_RN(k,:)/Monte_Carlo_T;
    ave_power_IA_DU(k,:)=ave_power_IA_DU(k,:)/Monte_Carlo_T;
    ave_power_IA_DU_RN(k,:)=ave_power_IA_DU_RN(k,:)/Monte_Carlo_T;
%     ave_rate_IM_DU(k,:)=ave_rate_IM_DU(k,:)/Monte_Carlo_T;
%     ave_rate_SM_DU(k,:)=ave_rate_SM_DU(k,:)/Monte_Carlo_T;
%     ave_rate_SMM_DU(k,:)=ave_rate_SMM_DU(k,:)/Monte_Carlo_T;
%     ave_rate_SRM_DU(k,:)=ave_rate_SRM_DU(k,:)/Monte_Carlo_T;
%     ave_rate_HD_DU(k,:)=ave_rate_HD_DU(k,:)/Monte_Carlo_T;
%     
%     ave_rate_IA_UD(k,:)=ave_rate_IA_UD(k,:)/Monte_Carlo_T;
%     ave_rate_IM_UD(k,:)=ave_rate_IM_UD(k,:)/Monte_Carlo_T;
%     ave_rate_SM_UD(k,:)=ave_rate_SM_UD(k,:)/Monte_Carlo_T;
%     ave_rate_SMM_UD(k,:)=ave_rate_SMM_UD(k,:)/Monte_Carlo_T;
%     ave_rate_SRM_UD(k,:)=ave_rate_SRM_UD(k,:)/Monte_Carlo_T;
%     ave_rate_HD_UD(k,:)=ave_rate_HD_UD(k,:)/Monte_Carlo_T;
%     
%     ave_SINR_IA_DU_AP(k,1)=ave_SINR_IA_DU_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_IM_DU_AP(k,1)=ave_SINR_IM_DU_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_SM_DU_AP(k,1)=ave_SINR_SM_DU_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_SMM_DU_AP(k,1)=ave_SINR_SMM_DU_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_SRM_DU_AP(k,1)=ave_SINR_SRM_DU_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_HD_DU_AP(k,1)=ave_SINR_HD_DU_AP(k,1)/Monte_Carlo_T;
%     
%     ave_SINR_IA_UD_AP(k,1)=ave_SINR_IA_UD_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_IM_UD_AP(k,1)=ave_SINR_IM_UD_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_SM_UD_AP(k,1)=ave_SINR_SM_UD_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_SMM_UD_AP(k,1)=ave_SINR_SMM_UD_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_SRM_UD_AP(k,1)=ave_SINR_SRM_UD_AP(k,1)/Monte_Carlo_T;
%     ave_SINR_HD_UD_AP(k,1)=ave_SINR_HD_UD_AP(k,1)/Monte_Carlo_T;
%     
%     ave_SINR_IA_DU_STA(k,1)=ave_SINR_IA_DU_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_IM_DU_STA(k,1)=ave_SINR_IM_DU_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_SM_DU_STA(k,1)=ave_SINR_SM_DU_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_SMM_DU_STA(k,1)=ave_SINR_SMM_DU_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_SRM_DU_STA(k,1)=ave_SINR_SRM_DU_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_HD_DU_STA(k,1)=ave_SINR_HD_DU_STA(k,1)/Monte_Carlo_T;
%     
%     ave_SINR_IA_UD_STA(k,1)=ave_SINR_IA_UD_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_IM_UD_STA(k,1)=ave_SINR_IM_UD_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_SM_UD_STA(k,1)=ave_SINR_SM_UD_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_SMM_UD_STA(k,1)=ave_SINR_SMM_UD_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_SRM_UD_STA(k,1)=ave_SINR_SRM_UD_STA(k,1)/Monte_Carlo_T;
%     ave_SINR_HD_UD_STA(k,1)=ave_SINR_HD_UD_STA(k,1)/Monte_Carlo_T;
%     
%     ave_traffic_IA_DU_D(k,1)=ave_traffic_IA_DU_D(k,1)/Monte_Carlo_T;
%     ave_traffic_IM_DU_D(k,1)=ave_traffic_IM_DU_D(k,1)/Monte_Carlo_T;
%     ave_traffic_SM_DU_D(k,1)=ave_traffic_SM_DU_D(k,1)/Monte_Carlo_T;
%     ave_traffic_SMM_DU_D(k,1)=ave_traffic_SMM_DU_D(k,1)/Monte_Carlo_T;
%     ave_traffic_SRM_DU_D(k,1)=ave_traffic_SRM_DU_D(k,1)/Monte_Carlo_T;
%     ave_traffic_HD_DU_D(k,1)=ave_traffic_HD_DU_D(k,1)/Monte_Carlo_T;
%     
%     ave_traffic_IA_DU_U(k,1)=ave_traffic_IA_DU_U(k,1)/Monte_Carlo_T;
%     ave_traffic_IM_DU_U(k,1)=ave_traffic_IM_DU_U(k,1)/Monte_Carlo_T;
%     ave_traffic_SM_DU_U(k,1)=ave_traffic_SM_DU_U(k,1)/Monte_Carlo_T;
%     ave_traffic_SMM_DU_U(k,1)=ave_traffic_SMM_DU_U(k,1)/Monte_Carlo_T;
%     ave_traffic_SRM_DU_U(k,1)=ave_traffic_SRM_DU_U(k,1)/Monte_Carlo_T;
%     ave_traffic_HD_DU_U(k,1)=ave_traffic_HD_DU_U(k,1)/Monte_Carlo_T;
%     
%     ave_traffic_IA_UD_D(k,1)=ave_traffic_IA_UD_D(k,1)/Monte_Carlo_T;
%     ave_traffic_IM_UD_D(k,1)=ave_traffic_IM_UD_D(k,1)/Monte_Carlo_T;
%     ave_traffic_SM_UD_D(k,1)=ave_traffic_SM_UD_D(k,1)/Monte_Carlo_T;
%     ave_traffic_SMM_UD_D(k,1)=ave_traffic_SMM_UD_D(k,1)/Monte_Carlo_T;
%     ave_traffic_SRM_UD_D(k,1)=ave_traffic_SRM_UD_D(k,1)/Monte_Carlo_T;
%     ave_traffic_HD_UD_D(k,1)=ave_traffic_HD_UD_D(k,1)/Monte_Carlo_T;
%     
%     ave_traffic_IA_UD_U(k,1)=ave_traffic_IA_UD_U(k,1)/Monte_Carlo_T;
%     ave_traffic_IM_UD_U(k,1)=ave_traffic_IM_UD_U(k,1)/Monte_Carlo_T;
%     ave_traffic_SM_UD_U(k,1)=ave_traffic_SM_UD_U(k,1)/Monte_Carlo_T;
%     ave_traffic_SMM_UD_U(k,1)=ave_traffic_SMM_UD_U(k,1)/Monte_Carlo_T;
%     ave_traffic_SRM_UD_U(k,1)=ave_traffic_SRM_UD_U(k,1)/Monte_Carlo_T;
%     ave_traffic_HD_UD_U(k,1)=ave_traffic_HD_UD_U(k,1)/Monte_Carlo_T;
    fprintf('The k=%i /%i \n',k,K);
end

ave_rate_DU_with_powcontrolv1=[ave_rate_IA_DU ave_rate_IA_DU_RN];% ave_rate_IM_DU ave_rate_SM_DU ave_rate_SMM_DU ave_rate_SRM_DU ave_rate_HD_DU];
ave_power_DU_with_powcontrolv1=[ave_power_IA_DU ave_power_IA_DU_RN];
% ave_rate_UD_with_channelgain=[ave_rate_IA_UD ave_rate_IM_UD ave_rate_SM_UD ave_rate_SMM_UD ave_rate_SRM_UD ave_rate_HD_UD];
% ave_SINR_DU_AP_with_channelgain=[ave_SINR_IA_DU_AP ave_SINR_IM_DU_AP ave_SINR_SM_DU_AP ave_SINR_SMM_DU_AP ave_SINR_SRM_DU_AP ave_SINR_HD_DU_AP];
% ave_SINR_DU_STA_with_channelgain=[ave_SINR_IA_DU_STA ave_SINR_IM_DU_STA ave_SINR_SM_DU_STA ave_SINR_SMM_DU_STA ave_SINR_SRM_DU_STA ave_SINR_HD_DU_STA];
% ave_SINR_UD_AP_with_channelgain=[ave_SINR_IA_UD_AP ave_SINR_IM_UD_AP ave_SINR_SM_UD_AP ave_SINR_SMM_UD_AP ave_SINR_SRM_UD_AP ave_SINR_HD_UD_AP];
% ave_SINR_UD_STA_with_channelgain=[ave_SINR_IA_UD_STA ave_SINR_IM_UD_STA ave_SINR_SM_UD_STA ave_SINR_SMM_UD_STA ave_SINR_SRM_UD_STA ave_SINR_HD_UD_STA];
% ave_traffic_DU_D_with_channelgain=[ave_traffic_IA_DU_D ave_traffic_IM_DU_D ave_traffic_SM_DU_D ave_traffic_SMM_DU_D ave_traffic_SRM_DU_D ave_traffic_HD_DU_D];
% ave_traffic_DU_U_with_channelgain=[ave_traffic_IA_DU_U ave_traffic_IM_DU_U ave_traffic_SM_DU_U ave_traffic_SMM_DU_U ave_traffic_SRM_DU_U ave_traffic_HD_DU_U];
% ave_traffic_UD_D_with_channelgain=[ave_traffic_IA_UD_D ave_traffic_IM_UD_D ave_traffic_SM_UD_D ave_traffic_SMM_UD_D ave_traffic_SRM_UD_D ave_traffic_HD_UD_D];
% ave_traffic_UD_U_with_channelgain=[ave_traffic_IA_UD_U ave_traffic_IM_UD_U ave_traffic_SM_UD_U ave_traffic_SMM_UD_U ave_traffic_SRM_UD_U ave_traffic_HD_UD_U];
save with_powcontrolv1;
save with_powcontrolv1_rate ave_rate_DU_with_powcontrolv1 ave_power_DU_with_powcontrolv1 ;
% save with_channelgainv2_SINR ave_SINR_DU_AP_with_channelgain ave_SINR_DU_STA_with_channelgain ave_SINR_UD_AP_with_channelgain ave_SINR_UD_STA_with_channelgain;
% save with_channelgainv2_traffic ave_traffic_DU_D_with_channelgain ave_traffic_DU_U_with_channelgain ave_traffic_UD_D_with_channelgain ave_traffic_UD_U_with_channelgain;