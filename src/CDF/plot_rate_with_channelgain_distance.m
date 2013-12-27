clear all
clc
load('distance_v1_data');
Variables=char('CDF_IA_DU_AP','CDF_IA_DU_STA','CDF_IA_UD_AP','CDF_IA_UD_STA',...
    'CDF_IM_DU_AP','CDF_IM_DU_STA','CDF_IM_UD_AP','CDF_IM_UD_STA',...
    'CDF_SM_DU_AP','CDF_SM_DU_STA','CDF_SM_UD_AP','CDF_SM_UD_STA',...
    'CDF_SMM_DU_AP','CDF_SMM_DU_STA','CDF_SMM_UD_AP','CDF_SMM_UD_STA',...
    'CDF_SRM_DU_AP','CDF_SRM_DU_STA','CDF_SRM_UD_AP','CDF_SRM_UD_STA');
for i=1:20
    eval(['CDF=',Variables(i,:)]);
    CDF(1,:,:)=CDF(1,:,:)*5.6569;
    xy1=CDF(:,:,1);
    xy1(:,xy1(1,:)==0)=[];
    xy2=CDF(:,:,2);
    xy2(:,xy2(1,:)==0)=[];
    xy3=CDF(:,:,3);
    xy3(:,xy3(1,:)==0)=[];
    xy4=CDF(:,:,4);
    xy4(:,xy4(1,:)==0)=[];
    xy5=CDF(:,:,5);
    xy5(:,xy5(1,:)==0)=[];
    xy6=CDF(:,:,6);
    xy6(:,xy6(1,:)==0)=[];
    xy7=CDF(:,:,7);
    xy7(:,xy7(1,:)==0)=[];
    
    
    f1=figure;
    plot(xy1(1,:),xy1(2,:),'o-k',xy2(1,:),xy2(2,:),'+-k',xy3(1,:),xy3(2,:),'d-k',xy4(1,:),xy4(2,:),'square-k',xy5(1,:),xy5(2,:),'x-k',xy6(1,:),xy6(2,:),'*-k',xy7(1,:),xy7(2,:),'hexagram-k', 'MarkerSize', 10, 'linewidth', 1.5);
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }$\leq$ {\sffamily x}) ','Interpreter','latex');
    legend('Self-inteference Capability=70dB','Self-inteference Capability=75dB','Self-inteference Capability=80dB',...
        'Self-inteference Capability=85dB','Self-inteference Capability=90dB','Self-inteference Capability=95dB','Self-inteference Capability=100dB','Location','SouthEast')
    grid on
    saveas(f1,Variables(i,:),'fig');
    
end

