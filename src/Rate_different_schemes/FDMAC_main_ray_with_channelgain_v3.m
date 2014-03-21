%Full-duplex MAC simulation by Shih Ying Chen 2013/12/24
% notes: 
% self_interference_channel_gain_STA in this simulation is unused since we
% assume that STA is half-duplex device but full-duplex device
clear all;
clc;

load('snrtable.mat');
%% Experiment profile setting
Profiles(1, 1).available=true;
Profiles(1, 1).profile_num=7;
Profiles(1, 1).center_frequency=2.4*10^9;
Profiles(1, 1).number_STAs=100; % the total number of STAs
Profiles(1, 1).power_transmit_AP=10;% the transmit power of AP (dBm)
Profiles(1, 1).power_transmit_STA=10;% the transmit power of STA (dBm)
Profiles(1, 1).d_avo_threshold=4;% the SINR threshold of Interference Avoidance (IA) (dB)
Profiles(1, 1).total_time=100;% total numbers of iterations in one Monte_Carlo trial
Profiles(1, 1).pro_up=0.8; % uplink traffic probability
Profiles(1, 1).pro_down=0.8;% downlink traffic probability
Profiles(1, 1).Monte_Carlo_T=1;% total numbers of Monte_Carlo trials
Profiles(1, 1).Target_PER = 0.1;
Profiles(1, 1).packet_size = 1000; %1000 bytes
Profiles(1, 1).self_interference_channel_gain_STA=-70;
Profiles(1, 1).SNR_input=100;% input SNR (dB)
Profiles(1, 1).SNR_Min_db = 5;
Profiles(1, 1).SNR_Max_db = 30;
Profiles(1, 1).log_path='./test/';
Profiles(1, 1).graph_title='Self Cancellation Capability';
Profiles(1, 1).graph_X_axis_title='Self Cancellation Capability (db)';
Profiles(1, 1).graph_X_axis_values=70:5:100;
Profiles(1, 1).graph_Y_axis_title='Average Throughput (Mbps)';

Profiles(1 ,2)=Profiles(1, 1);
Profiles(1 ,2).self_interference_channel_gain_STA=-75;

Profiles(1 ,3)=Profiles(1, 1);
Profiles(1 ,3).self_interference_channel_gain_STA=-80;

Profiles(1 ,4)=Profiles(1, 1);
Profiles(1 ,4).self_interference_channel_gain_STA=-85;

Profiles(1 ,5)=Profiles(1, 1);
Profiles(1 ,5).self_interference_channel_gain_STA=-90;

Profiles(1 ,6)=Profiles(1, 1);
Profiles(1 ,6).self_interference_channel_gain_STA=-95;

Profiles(1 ,7)=Profiles(1, 1);
Profiles(1 ,7).self_interference_channel_gain_STA=-100;

experiment_num = size(Profiles,1);


for exper_idx=1:experiment_num
    profile_num = Profiles(exper_idx, 1).profile_num;
    
    ave_rate_IA_DU=zeros(profile_num ,3); % column1:sum-rate column2:uplink-rate column3:downlink-rate
    ave_rate_IM_DU=zeros(profile_num ,3);
    ave_rate_SM_DU=zeros(profile_num ,3);
    ave_rate_SMM_DU=zeros(profile_num ,3);
    ave_rate_SRM_DU=zeros(profile_num ,3);
    ave_rate_HD_DU=zeros(profile_num ,3);
    ave_rate_MAC_DU=zeros(profile_num ,3);

    ave_rate_MAC_Power_Fair_1db_NoHistory_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_Fair_2db_NoHistory_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_Fair_3db_NoHistory_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_Fair_1db_History_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_Fair_2db_History_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_Fair_3db_History_DU=zeros(profile_num ,3);

    ave_rate_MAC_Power_UnFair_1db_NoHistory_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_UnFair_2db_NoHistory_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_UnFair_3db_NoHistory_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_UnFair_1db_History_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_UnFair_2db_History_DU=zeros(profile_num ,3);
    ave_rate_MAC_Power_UnFair_3db_History_DU=zeros(profile_num ,3);


    ave_rate_IA_UD=zeros(profile_num ,3); % column1:sum-rate column2:uplink-rate- column3:downlink-rate
    ave_rate_IM_UD=zeros(profile_num ,3);
    ave_rate_SM_UD=zeros(profile_num ,3);
    ave_rate_SMM_UD=zeros(profile_num ,3);
    ave_rate_SRM_UD=zeros(profile_num ,3);
    ave_rate_HD_UD=zeros(profile_num ,3);
    ave_rate_MAC_UD=zeros(profile_num ,3);
    
    result_file_path=strcat(Profiles(exper_idx, 1).log_path, 'SimulationResult');
    
    for prof_idx=1:profile_num
    
        %% Initial experiment parameters
        center_frequency=Profiles(exper_idx, prof_idx).center_frequency;
        number_STAs=Profiles(exper_idx, prof_idx).number_STAs; 
        power_transmit_AP=Profiles(exper_idx, prof_idx).power_transmit_AP;
        power_transmit_STA=Profiles(exper_idx, prof_idx).power_transmit_STA;
        d_avo_threshold=Profiles(exper_idx, prof_idx).d_avo_threshold;
        total_time=Profiles(exper_idx, prof_idx).total_time;
        pro_up=Profiles(exper_idx, prof_idx).pro_up; 
        pro_down=Profiles(exper_idx, prof_idx).pro_down;
        Monte_Carlo_T=Profiles(exper_idx, prof_idx).Monte_Carlo_T;
        Target_PER = Profiles(exper_idx, prof_idx).Target_PER;
        packet_size = Profiles(exper_idx, prof_idx).packet_size; 
        self_interference_channel_gain_STA=Profiles(exper_idx, prof_idx).self_interference_channel_gain_STA;
        SNR_input=Profiles(exper_idx, prof_idx).SNR_input;
        SNR_Min_db = Profiles(exper_idx, prof_idx).SNR_Min_db;
        SNR_Max_db = Profiles(exper_idx, prof_idx).SNR_Max_db;

        %% initial up/down probability for each STA
        pro_STAs=zeros(2,number_STAs);
        for i=1:number_STAs
            pro_STAs(1,i)=pro_up;
            pro_STAs(2,i)=pro_down;
        end

        noise_power=power_transmit_AP-SNR_input;% noise power level (-90dB)

        %% Distance constraint 
        Distance_Max = 10 ^ ((-(SNR_Min_db + noise_power - power_transmit_AP) + 147.55 - 20*log10(center_frequency)) / 20);
        Distance_Min = 10 ^ ((-(SNR_Max_db + noise_power - power_transmit_AP) + 147.55 - 20*log10(center_frequency)) / 20);

        radius=Distance_Max - Distance_Min;% the radius of circle area (meter)
    

        %% Monte Carlo method
        self_interference_channel_gain_AP=self_interference_channel_gain_STA;% the self-interference gain in AP (dB)  
    
    
        for T=1:Monte_Carlo_T % Monte Carlo trial iteration
            %% Initiate parameters
            History_SINR_Data = zeros(number_STAs,number_STAs);
            History_count=zeros(number_STAs,number_STAs);
            Power_UpLink_1db_NoHistory = zeros(1, total_time);
            Power_UpLink_2db_NoHistory = zeros(1, total_time);
            Power_UpLink_3db_NoHistory = zeros(1, total_time);

            Power_UpLink_1db_History = zeros(1, total_time);
            Power_UpLink_2db_History = zeros(1, total_time);
            Power_UpLink_3db_History = zeros(1, total_time);

            Power_UpLink_1db_NoHistory_UnFair = zeros(1, total_time);
            Power_UpLink_2db_NoHistory_UnFair = zeros(1, total_time);
            Power_UpLink_3db_NoHistory_UnFair = zeros(1, total_time);

            Power_UpLink_1db_History_UnFair = zeros(1, total_time);
            Power_UpLink_2db_History_UnFair = zeros(1, total_time);
            Power_UpLink_3db_History_UnFair = zeros(1, total_time);
            %% random deploy STAs in a circle
            % uniform distribution in a circle
            %u=unifrnd(0,radius,[1,number_STAs])+unifrnd(0,radius,[1,number_STAs]);
            u=Distance_Min+unifrnd(0,radius,[1,number_STAs]);
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
            coordinate=[coordinate_x;coordinate_y]; % the coordinate of STAs row1:x-axis row2:y-axis
            %% calculate distances
            % calculate the distance between STAs
            distance=zeros(number_STAs,number_STAs);
            for i=1:number_STAs-1
                for j=i+1:number_STAs
                    distance(i,j)=sqrt((coordinate(1,i)-coordinate(1,j))^2+(coordinate(2,i)-coordinate(2,j))^2);
                    distance(j,i)=distance(i,j);
                end
            end
            % calculate the distance between STA and AP
            distance_withAP=zeros(1,number_STAs);
            for i=1:number_STAs
                distance_withAP(1,i)=sqrt((coordinate(1,i))^2+(coordinate(2,i))^2);
            end
            %% calculate pathloss gain 
            % free space path loss (dB)
            pathloss_gain=-(20*log10(distance)+20*log10(center_frequency)-147.55);
            for i=1:number_STAs
                pathloss_gain(i,i)=self_interference_channel_gain_STA;
            end
            pathloss_gain_withAP=-(20*log10(distance_withAP)+20*log10(center_frequency)-147.55);
            %% Rayleigh fading
            fading_gain=pow2db(exprnd(1,number_STAs,number_STAs,total_time));% Rayleigh fading gain of each time-slot in a trial fading_gain(STA1,STA2)=STA1<-STA2 Rx:STA1 Tx:STA2 
            fading_gain_withAP=pow2db(exprnd(1,2,number_STAs,total_time));%row1: uplink(STA->AP) row2: downlink(AP->STA)
            fading_gain_withAP(2,:,:)=fading_gain_withAP(1,:,:);% assume channel reciprocal
            for t=1:total_time
                fading_gain(:,:,t)=triu(fading_gain(:,:,t))+triu(fading_gain(:,:,t),1).';% assume channel reciprocal
            end

            %% channel gain
            channel_gain=zeros(number_STAs,number_STAs,total_time);
            channel_gain_withAP=zeros(2,number_STAs,total_time);
            for t=1:total_time % pathloss gain is the same at every time-slot
                channel_gain(:,:,t)= pathloss_gain;
                channel_gain_withAP(1,:,t)=pathloss_gain_withAP;
                channel_gain_withAP(2,:,t)=pathloss_gain_withAP;
            end        
            channel_gain=channel_gain+fading_gain;% (dB)
            channel_gain_withAP=channel_gain_withAP+fading_gain_withAP;% (dB)
            %% generate traffic
            traffic_up=zeros(number_STAs,total_time);
            traffic_down=zeros(number_STAs,total_time);
            for i=1:number_STAs
                traffic_up(i,:)=randsrc(1,total_time,[1 0;pro_STAs(1,i) 1-pro_STAs(1,i)]);
                traffic_down(i,:)=randsrc(1,total_time,[1 0;pro_STAs(2,i) 1-pro_STAs(2,i)]);
            end
            % IA: interference avoidance
            % IM: interference minimization
            % SM: SINR maximization
            % SMM: SINR MAX MIN
            % SRM: sum rate maximization
            % HD: half duplex
            % MAC: MAC simulation
            % DU: down-up
            % UP: up-down
            record_traffic_IA_DU=zeros(2,total_time);%record which STA got the up/down channel in each time-slot row1:uplink row2:downlink
            record_traffic_IM_DU=zeros(2,total_time);
            record_traffic_SM_DU=zeros(2,total_time);
            record_traffic_SMM_DU=zeros(2,total_time);
            record_traffic_SRM_DU=zeros(2,total_time);
            record_traffic_HD_DU=zeros(2,total_time);
            record_traffic_MAC_DU=zeros(2, total_time);

            record_traffic_MAC_Power_Fair_1db_NoHistory_DU=zeros(2, total_time);
            record_traffic_MAC_Power_Fair_2db_NoHistory_DU=zeros(2, total_time);
            record_traffic_MAC_Power_Fair_3db_NoHistory_DU=zeros(2, total_time);
            record_traffic_MAC_Power_Fair_1db_History_DU=zeros(2, total_time);
            record_traffic_MAC_Power_Fair_2db_History_DU=zeros(2, total_time);
            record_traffic_MAC_Power_Fair_3db_History_DU=zeros(2, total_time);

            record_traffic_MAC_Power_UnFair_1db_NoHistory_DU=zeros(2, total_time);
            record_traffic_MAC_Power_UnFair_2db_NoHistory_DU=zeros(2, total_time);
            record_traffic_MAC_Power_UnFair_3db_NoHistory_DU=zeros(2, total_time);
            record_traffic_MAC_Power_UnFair_1db_History_DU=zeros(2, total_time);
            record_traffic_MAC_Power_UnFair_2db_History_DU=zeros(2, total_time);
            record_traffic_MAC_Power_UnFair_3db_History_DU=zeros(2, total_time);

            record_SINR_IA_DU=zeros(4,total_time);%record the corresponding SINR of up/down in each time-slot row1:AP(up) row2:STA(down) row3: estimate AP(up) row4: estimate STA(down)
            record_SINR_IM_DU=zeros(4,total_time);
            record_SINR_SM_DU=zeros(4,total_time);
            record_SINR_SMM_DU=zeros(4,total_time);
            record_SINR_SRM_DU=zeros(4,total_time);
            record_SINR_HD_DU=zeros(4,total_time);
            record_SINR_MAC_DU=zeros(4,total_time);

            record_SINR_MAC_Power_Fair_1db_NoHistory_DU=zeros(4,total_time);
            record_SINR_MAC_Power_Fair_2db_NoHistory_DU=zeros(4,total_time);
            record_SINR_MAC_Power_Fair_3db_NoHistory_DU=zeros(4,total_time);
            record_SINR_MAC_Power_Fair_1db_History_DU=zeros(4,total_time);
            record_SINR_MAC_Power_Fair_2db_History_DU=zeros(4,total_time);
            record_SINR_MAC_Power_Fair_3db_History_DU=zeros(4,total_time);

            record_SINR_MAC_Power_UnFair_1db_NoHistory_DU=zeros(4,total_time);
            record_SINR_MAC_Power_UnFair_2db_NoHistory_DU=zeros(4,total_time);
            record_SINR_MAC_Power_UnFair_3db_NoHistory_DU=zeros(4,total_time);
            record_SINR_MAC_Power_UnFair_1db_History_DU=zeros(4,total_time);
            record_SINR_MAC_Power_UnFair_2db_History_DU=zeros(4,total_time);
            record_SINR_MAC_Power_UnFair_3db_History_DU=zeros(4,total_time);

            record_traffic_IA_UD=zeros(2,total_time);
            record_traffic_IM_UD=zeros(2,total_time);
            record_traffic_SM_UD=zeros(2,total_time);
            record_traffic_SMM_UD=zeros(2,total_time);
            record_traffic_SRM_UD=zeros(2,total_time);
            record_traffic_HD_UD=zeros(2,total_time);
            record_traffic_MAC_UD=zeros(2,total_time);

            record_SINR_IA_UD=zeros(4,total_time);
            record_SINR_IM_UD=zeros(4,total_time);
            record_SINR_SM_UD=zeros(4,total_time);
            record_SINR_SMM_UD=zeros(4,total_time);
            record_SINR_SRM_UD=zeros(4,total_time);
            record_SINR_HD_UD=zeros(4,total_time);
            recode_SINR_MAC_UD=zeros(4,total_time);

            traffic_reg_first=zeros(number_STAs,1);%record traffic requirement of STAs for first transmission at each time-slot
            traffic_reg_second=zeros(number_STAs,1);%record traffic requirement of STAs for second transmission at each time-slot

            for t=1:total_time % time-slot iteration
                channel_gain_temp=channel_gain(:,:,t);
                channel_gain_withAP_temp=channel_gain_withAP(:,:,t);
                %% DOWN-UP
                traffic_reg_first(:,:)=0;
                traffic_reg_second(:,:)=0;
                transmission_first=0;

                % calculate the number of downlink traffic requirments and
                % which STA has downlink traffic requirment
                num_dn_STA=0;
                for i=1:number_STAs
                    if traffic_down(i,t)==1
                        num_dn_STA=num_dn_STA+1;
                        traffic_reg_first(num_dn_STA,1)=i;
                    end
                end

                if num_dn_STA~=0 % There's at least one downlink traffic
                    % choose downlink STAs randomly
                    transmission_first=traffic_reg_first(unidrnd(num_dn_STA,1));

                    % choose uplink STAs--------------------------------------%
                    num_up_STA=0;
                    for i=1:number_STAs
                        if traffic_up(i,t)==1 && i~=transmission_first;% Single-link is not permitted
                            num_up_STA=num_up_STA+1;
                            traffic_reg_second(num_up_STA,1)=i;
                        end
                    end
                    if  num_up_STA~=0
                        % choose uplink STA with different schemes
                        [record_traffic_IA_DU(1,t)]=fcn_Interference_Avoidance_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold);
                        [record_traffic_IM_DU(1,t)]=fcn_Interference_Minimization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp);
                        [record_traffic_SM_DU(1,t)]=fcn_SINR_Maximization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA);
                        [record_traffic_SMM_DU(1,t)]=fcn_SINR_Maxmin_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP);
                        [record_traffic_SRM_DU(1,t)]=fcn_SumRate_Maximization_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP);
                        [record_traffic_MAC_DU(1,t)]=fcn_MAC_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,t);

                        [record_traffic_MAC_Power_Fair_1db_NoHistory_DU(1,t), Power_UpLink_1db_NoHistory(1,t)]=fcn_MAC_Power_CW_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,0,1,noise_power);
                        [record_traffic_MAC_Power_Fair_2db_NoHistory_DU(1,t), Power_UpLink_2db_NoHistory(1,t)]=fcn_MAC_Power_CW_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,0,2,noise_power);
                        [record_traffic_MAC_Power_Fair_3db_NoHistory_DU(1,t), Power_UpLink_3db_NoHistory(1,t)]=fcn_MAC_Power_CW_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,0,3,noise_power);
                        [record_traffic_MAC_Power_Fair_1db_History_DU(1,t), Power_UpLink_1db_History(1,t)]=fcn_MAC_Power_CW_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,1,1,noise_power);
                        [record_traffic_MAC_Power_Fair_2db_History_DU(1,t), Power_UpLink_2db_History(1,t)]=fcn_MAC_Power_CW_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,1,2,noise_power);
                        [record_traffic_MAC_Power_Fair_3db_History_DU(1,t), Power_UpLink_3db_History(1,t)]=fcn_MAC_Power_CW_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,1,3,noise_power);

                        [record_traffic_MAC_Power_UnFair_1db_NoHistory_DU(1,t), Power_UpLink_1db_NoHistory_UnFair(1,t)]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,0,1,noise_power);
                        [record_traffic_MAC_Power_UnFair_2db_NoHistory_DU(1,t), Power_UpLink_2db_NoHistory_UnFair(1,t)]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,0,2,noise_power);
                        [record_traffic_MAC_Power_UnFair_3db_NoHistory_DU(1,t), Power_UpLink_3db_NoHistory_UnFair(1,t)]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,0,3,noise_power);
                        [record_traffic_MAC_Power_UnFair_1db_History_DU(1,t), Power_UpLink_1db_History_UnFair(1,t)]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,1,1,noise_power);
                        [record_traffic_MAC_Power_UnFair_2db_History_DU(1,t), Power_UpLink_2db_History_UnFair(1,t)]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,2,2,noise_power);
                        [record_traffic_MAC_Power_UnFair_3db_History_DU(1,t), Power_UpLink_3db_History_UnFair(1,t)]=fcn_MAC_Power_UnFair_DU(transmission_first,traffic_reg_second,num_up_STA,channel_gain_temp,channel_gain_withAP_temp,power_transmit_AP,power_transmit_STA,History_SINR_Data,3,3,noise_power);


                        %Update history data for MAC
                        [History_SINR_Data, History_count]=fcn_MAC_Update_Histroy(History_SINR_Data, History_count, transmission_first, number_STAs, channel_gain_temp, channel_gain_withAP_temp, power_transmit_AP, power_transmit_STA, noise_power);
                    else
                        record_traffic_IA_DU(1,t)=0;
                        record_traffic_IM_DU(1,t)=0;
                        record_traffic_SM_DU(1,t)=0;
                        record_traffic_SMM_DU(1,t)=0;
                        record_traffic_SRM_DU(1,t)=0;
                        record_traffic_MAC_DU(1,t)=0;

                        record_traffic_MAC_Power_Fair_1db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_2db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_3db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_1db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_2db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_3db_History_DU(1,t)=0;

                        record_traffic_MAC_Power_UnFair_1db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_2db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_3db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_1db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_2db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_3db_History_DU(1,t)=0;


                        Power_UpLink_1db_NoHistory(1,t)=power_transmit_STA;
                        Power_UpLink_2db_NoHistory(1,t)=power_transmit_STA;
                        Power_UpLink_3db_NoHistory(1,t)=power_transmit_STA;
                        Power_UpLink_1db_History(1,t)=power_transmit_STA;
                        Power_UpLink_2db_History(1,t)=power_transmit_STA;
                        Power_UpLink_3db_History(1,t)=power_transmit_STA;

                        Power_UpLink_1db_NoHistory_UnFair(1,t)=power_transmit_STA;
                        Power_UpLink_2db_NoHistory_UnFair(1,t)=power_transmit_STA;
                        Power_UpLink_3db_NoHistory_UnFair(1,t)=power_transmit_STA;
                        Power_UpLink_1db_History_UnFair(1,t)=power_transmit_STA;
                        Power_UpLink_2db_History_UnFair(1,t)=power_transmit_STA;
                        Power_UpLink_3db_History_UnFair(1,t)=power_transmit_STA;
                    end
                    % --------------------------------------------------------%
                else % There's no downlink traffic
                    num_up_STA=0;
                    for i=1:number_STAs
                        if traffic_up(i,t)==1
                            num_up_STA=num_up_STA+1;
                            traffic_reg_second(num_up_STA,1)=i;
                        end
                    end

                    Power_UpLink_1db_NoHistory(1,t)=power_transmit_STA;
                    Power_UpLink_2db_NoHistory(1,t)=power_transmit_STA;
                    Power_UpLink_3db_NoHistory(1,t)=power_transmit_STA;
                    Power_UpLink_1db_History(1,t)=power_transmit_STA;
                    Power_UpLink_2db_History(1,t)=power_transmit_STA;
                    Power_UpLink_3db_History(1,t)=power_transmit_STA;

                    Power_UpLink_1db_NoHistory_UnFair(1,t)=power_transmit_STA;
                    Power_UpLink_2db_NoHistory_UnFair(1,t)=power_transmit_STA;
                    Power_UpLink_3db_NoHistory_UnFair(1,t)=power_transmit_STA;
                    Power_UpLink_1db_History_UnFair(1,t)=power_transmit_STA;
                    Power_UpLink_2db_History_UnFair(1,t)=power_transmit_STA;
                    Power_UpLink_3db_History_UnFair(1,t)=power_transmit_STA;

                    %choose uplink STAs randomly
                    if num_up_STA~=0
                        record_traffic_IA_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_IM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_SM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_SMM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_SRM_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_HD_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));

                        record_traffic_MAC_Power_Fair_1db_NoHistory_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_Fair_2db_NoHistory_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_Fair_3db_NoHistory_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_Fair_1db_History_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_Fair_2db_History_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_Fair_3db_History_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));

                        record_traffic_MAC_Power_UnFair_1db_NoHistory_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_UnFair_2db_NoHistory_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_UnFair_3db_NoHistory_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_UnFair_1db_History_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_UnFair_2db_History_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                        record_traffic_MAC_Power_UnFair_3db_History_DU(1,t)=traffic_reg_second(unidrnd(num_up_STA,1));
                    else
                        record_traffic_IA_DU(1,t)=0;
                        record_traffic_IM_DU(1,t)=0;
                        record_traffic_SM_DU(1,t)=0;
                        record_traffic_SMM_DU(1,t)=0;
                        record_traffic_SRM_DU(1,t)=0;
                        record_traffic_HD_DU(1,t)=0;

                        record_traffic_MAC_Power_Fair_1db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_2db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_3db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_1db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_2db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_Fair_3db_History_DU(1,t)=0;

                        record_traffic_MAC_Power_UnFair_1db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_2db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_3db_NoHistory_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_1db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_2db_History_DU(1,t)=0;
                        record_traffic_MAC_Power_UnFair_3db_History_DU(1,t)=0;
                    end

                end
                % record downlink STA
                record_traffic_IA_DU(2,t)=transmission_first;
                record_traffic_IM_DU(2,t)=transmission_first;
                record_traffic_SM_DU(2,t)=transmission_first;
                record_traffic_SMM_DU(2,t)=transmission_first;
                record_traffic_SRM_DU(2,t)=transmission_first;
                record_traffic_HD_DU(2,t)=transmission_first;
                record_traffic_MAC_DU(2,t)=transmission_first;

                record_traffic_MAC_Power_Fair_1db_NoHistory_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_Fair_2db_NoHistory_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_Fair_3db_NoHistory_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_Fair_1db_History_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_Fair_2db_History_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_Fair_3db_History_DU(2,t)=transmission_first;

                record_traffic_MAC_Power_UnFair_1db_NoHistory_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_UnFair_2db_NoHistory_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_UnFair_3db_NoHistory_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_UnFair_1db_History_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_UnFair_2db_History_DU(2,t)=transmission_first;
                record_traffic_MAC_Power_UnFair_3db_History_DU(2,t)=transmission_first;

                % calculate SINR based on record traffic 
                [record_SINR_IA_DU(:,t)]=fcn_SINR_calculate(record_traffic_IA_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_IM_DU(:,t)]=fcn_SINR_calculate(record_traffic_IM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_SM_DU(:,t)]=fcn_SINR_calculate(record_traffic_SM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_SMM_DU(:,t)]=fcn_SINR_calculate(record_traffic_SMM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_SRM_DU(:,t)]=fcn_SINR_calculate(record_traffic_SRM_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_HD_DU(:,t)]=fcn_SINR_calculate(record_traffic_HD_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_MAC_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_DU(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            

                [record_SINR_MAC_Power_Fair_1db_NoHistory_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_Fair_1db_NoHistory_DU(:,t),power_transmit_AP,Power_UpLink_1db_NoHistory(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_Fair_2db_NoHistory_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_Fair_2db_NoHistory_DU(:,t),power_transmit_AP,Power_UpLink_2db_NoHistory(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_Fair_3db_NoHistory_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_Fair_3db_NoHistory_DU(:,t),power_transmit_AP,Power_UpLink_3db_NoHistory(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_Fair_1db_History_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_Fair_1db_History_DU(:,t),power_transmit_AP,Power_UpLink_1db_History(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_Fair_2db_History_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_Fair_2db_History_DU(:,t),power_transmit_AP,Power_UpLink_2db_History(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_Fair_3db_History_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_Fair_3db_History_DU(:,t),power_transmit_AP,Power_UpLink_3db_History(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            

                [record_SINR_MAC_Power_UnFair_1db_NoHistory_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_UnFair_1db_NoHistory_DU(:,t),power_transmit_AP,Power_UpLink_1db_NoHistory_UnFair(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_UnFair_2db_NoHistory_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_UnFair_2db_NoHistory_DU(:,t),power_transmit_AP,Power_UpLink_2db_NoHistory_UnFair(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_UnFair_3db_NoHistory_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_UnFair_3db_NoHistory_DU(:,t),power_transmit_AP,Power_UpLink_3db_NoHistory_UnFair(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_UnFair_1db_History_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_UnFair_1db_History_DU(:,t),power_transmit_AP,Power_UpLink_1db_History_UnFair(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_UnFair_2db_History_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_UnFair_2db_History_DU(:,t),power_transmit_AP,Power_UpLink_2db_History_UnFair(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            
                [record_SINR_MAC_Power_UnFair_3db_History_DU(:,t)]=fcn_SINR_calculate(record_traffic_MAC_Power_UnFair_3db_History_DU(:,t),power_transmit_AP,Power_UpLink_3db_History_UnFair(1,t),channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);            

                % record power
                %{
                record_power_UpLink_1db_Perfect=cat(2, record_power_UpLink_1db_Perfect, Power_UpLink_1db_NoHistory);
                record_power_UpLink_2db_Perfect=cat(2, record_power_UpLink_2db_Perfect, Power_UpLink_2db_NoHistory);
                record_power_UpLink_3db_Perfect=cat(2, record_power_UpLink_3db_Perfect, Power_UpLink_3db_NoHistory);
                record_power_UpLink_1db_History=cat(2, record_power_UpLink_1db_History, Power_UpLink_1db_History);
                record_power_UpLink_2db_History=cat(2, record_power_UpLink_2db_History, Power_UpLink_2db_History);
                record_power_UpLink_3db_History=cat(2, record_power_UpLink_3db_History, Power_UpLink_3db_History);
                %}
                %% UP-DOWN
                traffic_reg_first(:,:)=0;
                traffic_reg_second(:,:)=0;
                transmission_first=0;

                % calculate the number of uplink traffic requirments and
                % which STA has uplink traffic requirment
                num_up_STA=0;
                for i=1:number_STAs
                    if traffic_up(i,t)==1
                        num_up_STA=num_up_STA+1;
                        traffic_reg_first(num_up_STA,1)=i;
                    end
                end

                if num_up_STA~=0 % There's at least one uplink traffic
                    %choose uplink STAs randomly
                    transmission_first=traffic_reg_first(unidrnd(num_up_STA,1));

                    %choose downlink STAs--------------------------------------%
                    num_dn_STA=0;
                    for i=1:number_STAs
                        if traffic_down(i,t)==1 && i~=transmission_first;% Single-link is not permitted
                            num_dn_STA=num_dn_STA+1;
                            traffic_reg_second(num_dn_STA,1)=i;
                        end
                    end
                    %--
                    if num_dn_STA~=0
                        % choose downlink STA with different schemes
                        [record_traffic_IA_UD(2,t)]=fcn_Interference_Avoidance_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,d_avo_threshold);
                        [record_traffic_IM_UD(2,t)]=fcn_Interference_Minimization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp);
                        [record_traffic_SM_UD(2,t)]=fcn_SINR_Maximization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA);
                        [record_traffic_SMM_UD(2,t) ]=fcn_SINR_Maxmin_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA);
                        [record_traffic_SRM_UD(2,t)]=fcn_SumRate_Maximization_UD(transmission_first,traffic_reg_second,num_dn_STA,channel_gain_temp,channel_gain_withAP_temp,noise_power,power_transmit_AP,power_transmit_STA,self_interference_channel_gain_AP);

                    else
                        record_traffic_IA_UD(2,t)=0;
                        record_traffic_IM_UD(2,t)=0;
                        record_traffic_SM_UD(2,t)=0;
                        record_traffic_SMM_UD(2,t)=0;
                        record_traffic_SRM_UD(2,t)=0;                                       
                    end
                    % --------------------------------------------------------%
                else % There's no uplink traffic

                    num_dn_STA=0;
                    for i=1:number_STAs
                        if traffic_down(i,t)==1
                            num_dn_STA=num_dn_STA+1;
                            traffic_reg_second(num_dn_STA,1)=i;
                        end
                    end

                    %choose downlink STAs randomly
                    if num_dn_STA~=0
                        record_traffic_IA_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
                        record_traffic_IM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
                        record_traffic_SM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
                        record_traffic_SMM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
                        record_traffic_SRM_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
                        record_traffic_HD_UD(2,t)=traffic_reg_second(unidrnd(num_dn_STA,1));
                    else
                        record_traffic_IA_UD(2,t)=0;
                        record_traffic_IM_UD(2,t)=0;
                        record_traffic_SM_UD(2,t)=0;
                        record_traffic_SMM_UD(2,t)=0;
                        record_traffic_SRM_UD(2,t)=0;
                        record_traffic_HD_UD(2,t)=0;
                    end

                end

                % record uplink STA
                record_traffic_IA_UD(1,t)=transmission_first;
                record_traffic_IM_UD(1,t)=transmission_first;
                record_traffic_SM_UD(1,t)=transmission_first;
                record_traffic_SMM_UD(1,t)=transmission_first;
                record_traffic_SRM_UD(1,t)=transmission_first;
                record_traffic_HD_UD(1,t)=transmission_first;

                % calculate SINR based on record traffic 
                [record_SINR_IA_UD(:,t)]=fcn_SINR_calculate(record_traffic_IA_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_IM_UD(:,t)]=fcn_SINR_calculate(record_traffic_IM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_SM_UD(:,t)]=fcn_SINR_calculate(record_traffic_SM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_SMM_UD(:,t)]=fcn_SINR_calculate(record_traffic_SMM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_SRM_UD(:,t)]=fcn_SINR_calculate(record_traffic_SRM_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);
                [record_SINR_HD_UD(:,t)]=fcn_SINR_calculate(record_traffic_HD_UD(:,t),power_transmit_AP,power_transmit_STA,channel_gain_withAP_temp,channel_gain_temp,noise_power,self_interference_channel_gain_AP);

            end             
        
            % calculate rate based on SINR and sum up with BER
            ave_rate_IA_DU(prof_idx,:)=ave_rate_IA_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_IA_DU, snrtable, packet_size, Target_PER);
            ave_rate_IM_DU(prof_idx,:)=ave_rate_IM_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_IM_DU, snrtable, packet_size, Target_PER);
            ave_rate_SM_DU(prof_idx,:)=ave_rate_SM_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_SM_DU, snrtable, packet_size, Target_PER);
            ave_rate_SMM_DU(prof_idx,:)=ave_rate_SMM_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_SMM_DU, snrtable, packet_size, Target_PER);
            ave_rate_SRM_DU(prof_idx,:)=ave_rate_SRM_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_SRM_DU, snrtable, packet_size, Target_PER);
            ave_rate_HD_DU(prof_idx,:)=ave_rate_HD_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_HD_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_DU(prof_idx,:)=ave_rate_MAC_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_DU, snrtable, packet_size, Target_PER);

            ave_rate_MAC_Power_Fair_1db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_1db_NoHistory_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_Fair_1db_NoHistory_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_Fair_2db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_2db_NoHistory_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_Fair_2db_NoHistory_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_Fair_3db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_3db_NoHistory_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_Fair_3db_NoHistory_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_Fair_1db_History_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_1db_History_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_Fair_1db_History_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_Fair_2db_History_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_2db_History_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_Fair_2db_History_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_Fair_3db_History_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_3db_History_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_Fair_3db_History_DU, snrtable, packet_size, Target_PER);

            ave_rate_MAC_Power_UnFair_1db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_1db_NoHistory_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_UnFair_1db_NoHistory_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_UnFair_2db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_2db_NoHistory_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_UnFair_2db_NoHistory_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_UnFair_3db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_3db_NoHistory_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_UnFair_3db_NoHistory_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_UnFair_1db_History_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_1db_History_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_UnFair_1db_History_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_UnFair_2db_History_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_2db_History_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_UnFair_2db_History_DU, snrtable, packet_size, Target_PER);
            ave_rate_MAC_Power_UnFair_3db_History_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_3db_History_DU(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_MAC_Power_UnFair_3db_History_DU, snrtable, packet_size, Target_PER);

            ave_rate_IA_UD(prof_idx,:)=ave_rate_IA_UD(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_IA_UD, snrtable, packet_size, Target_PER);
            ave_rate_IM_UD(prof_idx,:)=ave_rate_IM_UD(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_IM_UD, snrtable, packet_size, Target_PER);
            ave_rate_SM_UD(prof_idx,:)=ave_rate_SM_UD(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_SM_UD, snrtable, packet_size, Target_PER);
            ave_rate_SMM_UD(prof_idx,:)=ave_rate_SMM_UD(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_SMM_UD, snrtable, packet_size, Target_PER);
            ave_rate_SRM_UD(prof_idx,:)=ave_rate_SRM_UD(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_SRM_UD, snrtable, packet_size, Target_PER);
            ave_rate_HD_UD(prof_idx,:)=ave_rate_HD_UD(prof_idx,:)+fcn_rate_calculate_with_PER(record_SINR_HD_UD, snrtable, packet_size, Target_PER);               
        
        
            % calculate rate based on SINR and sum up
            %ave_rate_IA_DU(k,:)=ave_rate_IA_DU(k,:)+fcn_rate_calculate(record_SINR_IA_DU);
            %ave_rate_IM_DU(k,:)=ave_rate_IM_DU(k,:)+fcn_rate_calculate(record_SINR_IM_DU);
            %ave_rate_SM_DU(k,:)=ave_rate_SM_DU(k,:)+fcn_rate_calculate(record_SINR_SM_DU);
            %ave_rate_SMM_DU(k,:)=ave_rate_SMM_DU(k,:)+fcn_rate_calculate(record_SINR_SMM_DU);
            %ave_rate_SRM_DU(k,:)=ave_rate_SRM_DU(k,:)+fcn_rate_calculate(record_SINR_SRM_DU);
            %ave_rate_HD_DU(k,:)=ave_rate_HD_DU(k,:)+fcn_rate_calculate(record_SINR_HD_DU);
            %ave_rate_MAC_DU(k,:)=ave_rate_MAC_DU(k,:)+fcn_rate_calculate(record_SINR_MAC_DU);

            %ave_rate_IA_UD(k,:)=ave_rate_IA_UD(k,:)+fcn_rate_calculate(record_SINR_IA_UD);
            %ave_rate_IM_UD(k,:)=ave_rate_IM_UD(k,:)+fcn_rate_calculate(record_SINR_IM_UD);
            %ave_rate_SM_UD(k,:)=ave_rate_SM_UD(k,:)+fcn_rate_calculate(record_SINR_SM_UD);
            %ave_rate_SMM_UD(k,:)=ave_rate_SMM_UD(k,:)+fcn_rate_calculate(record_SINR_SMM_UD);
            %ave_rate_SRM_UD(k,:)=ave_rate_SRM_UD(k,:)+fcn_rate_calculate(record_SINR_SRM_UD);
            %ave_rate_HD_UD(k,:)=ave_rate_HD_UD(k,:)+fcn_rate_calculate(record_SINR_HD_UD);
        
        end
    
    
        ave_rate_IA_DU(prof_idx,:)=ave_rate_IA_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_IM_DU(prof_idx,:)=ave_rate_IM_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_SM_DU(prof_idx,:)=ave_rate_SM_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_SMM_DU(prof_idx,:)=ave_rate_SMM_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_SRM_DU(prof_idx,:)=ave_rate_SRM_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_HD_DU(prof_idx,:)=ave_rate_HD_DU(prof_idx,:)/Monte_Carlo_T;

        ave_rate_MAC_Power_Fair_1db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_1db_NoHistory_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_Fair_2db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_2db_NoHistory_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_Fair_3db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_3db_NoHistory_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_Fair_1db_History_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_1db_History_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_Fair_2db_History_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_2db_History_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_Fair_3db_History_DU(prof_idx,:)=ave_rate_MAC_Power_Fair_3db_History_DU(prof_idx,:)/Monte_Carlo_T;

        ave_rate_MAC_Power_UnFair_1db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_1db_NoHistory_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_UnFair_2db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_2db_NoHistory_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_UnFair_3db_NoHistory_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_3db_NoHistory_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_UnFair_1db_History_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_1db_History_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_UnFair_2db_History_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_2db_History_DU(prof_idx,:)/Monte_Carlo_T;
        ave_rate_MAC_Power_UnFair_3db_History_DU(prof_idx,:)=ave_rate_MAC_Power_UnFair_3db_History_DU(prof_idx,:)/Monte_Carlo_T;

        ave_rate_IA_UD(prof_idx,:)=ave_rate_IA_UD(prof_idx,:)/Monte_Carlo_T;
        ave_rate_IM_UD(prof_idx,:)=ave_rate_IM_UD(prof_idx,:)/Monte_Carlo_T;
        ave_rate_SM_UD(prof_idx,:)=ave_rate_SM_UD(prof_idx,:)/Monte_Carlo_T;
        ave_rate_SMM_UD(prof_idx,:)=ave_rate_SMM_UD(prof_idx,:)/Monte_Carlo_T;
        ave_rate_SRM_UD(prof_idx,:)=ave_rate_SRM_UD(prof_idx,:)/Monte_Carlo_T;
        ave_rate_HD_UD(prof_idx,:)=ave_rate_HD_UD(prof_idx,:)/Monte_Carlo_T;




        

    end
    
    
    
    ave_rate_DU_with_channelgain=[ave_rate_IA_DU ave_rate_IM_DU ave_rate_SM_DU ave_rate_SMM_DU ave_rate_SRM_DU ave_rate_HD_DU ave_rate_MAC_DU]; 
    ave_rate_UD_with_channelgain=[ave_rate_IA_UD ave_rate_IM_UD ave_rate_SM_UD ave_rate_SMM_UD ave_rate_SRM_UD ave_rate_HD_UD];

    ave_rate_DU_MAC_Power_Fair=[ave_rate_MAC_Power_Fair_1db_NoHistory_DU ave_rate_MAC_Power_Fair_2db_NoHistory_DU ave_rate_MAC_Power_Fair_3db_NoHistory_DU ave_rate_MAC_Power_Fair_1db_History_DU ave_rate_MAC_Power_Fair_2db_History_DU ave_rate_MAC_Power_Fair_3db_History_DU];
    ave_rate_DU_MAC_Power_UnFair=[ave_rate_MAC_Power_UnFair_1db_NoHistory_DU ave_rate_MAC_Power_UnFair_2db_NoHistory_DU ave_rate_MAC_Power_UnFair_3db_NoHistory_DU ave_rate_MAC_Power_UnFair_1db_History_DU ave_rate_MAC_Power_UnFair_2db_History_DU ave_rate_MAC_Power_UnFair_3db_History_DU];

    current_profile = Profiles(exper_idx, :);
    
    mkdir(Profiles(exper_idx, 1).log_path);
    save('Profiles', 'Profiles');
    save(result_file_path, 'current_profile', 'ave_rate_DU_with_channelgain', 'ave_rate_UD_with_channelgain', 'ave_rate_DU_MAC_Power_Fair', 'ave_rate_DU_MAC_Power_UnFair');
    
    %save with_channelgainv3;
    %save with_channelgainv3_rate ave_rate_DU_with_channelgain ave_rate_UD_with_channelgain ;

    %save MAC_Power_Fair ave_rate_DU_MAC_Power_Fair ave_rate_DU_MAC_Power_UnFair;

end
% save with_channelgainv3_SINR ave_SINR_DU_AP_with_channelgain ave_SINR_DU_STA_with_channelgain ave_SINR_UD_AP_with_channelgain ave_SINR_UD_STA_with_channelgain;
% save with_channelgainv3_traffic ave_traffic_DU_D_with_channelgain ave_traffic_DU_U_with_channelgain ave_traffic_UD_D_with_channelgain ave_traffic_UD_U_with_channelgain;