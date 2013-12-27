clear all
clc
load('distance_v3_data');
Variables=char('PMF_IA_DU_AP','PMF_IA_DU_STA','PMF_IA_UD_AP','PMF_IA_UD_STA',...
    'PMF_IM_DU_AP','PMF_IM_DU_STA','PMF_IM_UD_AP','PMF_IM_UD_STA',...
    'PMF_SM_DU_AP','PMF_SM_DU_STA','PMF_SM_UD_AP','PMF_SM_UD_STA',...
    'PMF_SMM_UD_AP','PMF_SMM_UD_STA','PMF_SRM_UD_AP','PMF_SRM_UD_STA');
for i=1:16
    eval(['PMF=',Variables(i,:)]);
    PMF(1,:,:)=PMF(1,:,:)*5;
    xy1=PMF(:,:,1);
    xy1(:,xy1(1,:)==0)=[];
    
    f1=figure;
    bar(xy1(1,:),xy1(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f1,[Variables(i,:) 'v3'],'fig');
    
end
Variables2=char('PMF_IA_DU_AP','PMF_SMM_DU_STA',...
    'PMF_SRM_DU_AP','PMF_SRM_DU_STA');
for i=1:4
    eval(['PMF=',Variables2(i,:)]);
    PMF(1,:,:)=PMF(1,:,:)*5;
    xy1=PMF(:,:,1);
    xy1(:,xy1(1,:)==0)=[];
    xy2=PMF(:,:,2);
    xy2(:,xy2(1,:)==0)=[];
    xy3=PMF(:,:,3);
    xy3(:,xy3(1,:)==0)=[];
    xy4=PMF(:,:,4);
    xy4(:,xy4(1,:)==0)=[];
    xy5=PMF(:,:,5);
    xy5(:,xy5(1,:)==0)=[];
    xy6=PMF(:,:,6);
    xy6(:,xy6(1,:)==0)=[];
    xy7=PMF(:,:,7);
    xy7(:,xy7(1,:)==0)=[];
    
    f1=figure;
    bar(xy1(1,:),xy1(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f1,[Variables2(i,:) 'v3_70'],'fig');
    
    f2=figure;
    bar(xy2(1,:),xy2(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f2,[Variables2(i,:) 'v3_75'],'fig');
    
    f3=figure;
    bar(xy3(1,:),xy3(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f3,[Variables2(i,:) 'v3_80'],'fig');
    
    f4=figure;
    bar(xy4(1,:),xy4(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f4,[Variables2(i,:) 'v3_85'],'fig');
    
    f5=figure;
    bar(xy5(1,:),xy5(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f5,[Variables2(i,:) 'v3_90'],'fig');
    
    f6=figure;
    bar(xy6(1,:),xy6(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f6,[Variables2(i,:) 'v3_95'],'fig');
    
    f7=figure;
    bar(xy7(1,:),xy7(2,:));
    set(gca,'FontSize',12)
    xlabel('x (m)');
    ylabel(' {\sffamily P(X }= {\sffamily x}) ','Interpreter','latex');
    grid on
    saveas(f7,[Variables2(i,:) 'v3_100'],'fig');
    
    
end