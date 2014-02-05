clear all
clc
load('with_channelgainv3_rate');
load('MAC_Power_Fair');
x=70:5:100;

f1=figure;
plot(x,ave_rate_DU_MAC_Power(:,1),'o-k',x,ave_rate_DU_MAC_Power(:,4),'+-k',x,ave_rate_DU_MAC_Power(:,7),'d-k',x,ave_rate_DU_MAC_Power(:,10),'square-k',x,ave_rate_DU_MAC_Power(:,13),'x-k',x,ave_rate_DU_MAC_Power(:,16),'hexagram-k',x,ave_rate_DU_with_channelgain(:,13),'^--r',x,ave_rate_DU_with_channelgain(:,16),'V--r', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,15]);
legend('1db Perfect','2 db Perfect','3db Perfect','1db History','2db History','3db History','Sum Rate Maximization','Half-Duplex','Location','NorthWest');
grid on
saveas(f1,'rate_DU_with_PowerControl_sumv3','fig');
saveas(f1,'rate_DU_with_PowerControl_sumv3','jpg');

f2=figure;
plot(x,ave_rate_DU_MAC_Power(:,2),'o-k',x,ave_rate_DU_MAC_Power(:,5),'+-k',x,ave_rate_DU_MAC_Power(:,8),'d-k',x,ave_rate_DU_MAC_Power(:,11),'square-k',x,ave_rate_DU_MAC_Power(:,14),'x-k',x,ave_rate_DU_MAC_Power(:,17),'hexagram-k',x,ave_rate_DU_with_channelgain(:,14),'^--r',x,ave_rate_DU_with_channelgain(:,17),'V--r', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,15]);
legend('1db Perfect','2 db Perfect','3db Perfect','1db History','2db History','3db History','Sum Rate Maximization','Half-Duplex','Location','NorthWest');
grid on
saveas(f2,'rate_DU_with_PowerControl_upv3','fig');
saveas(f2,'rate_DU_with_PowerControl_upv3','jpg');

f3=figure;
plot(x,ave_rate_DU_MAC_Power(:,3),'o-k',x,ave_rate_DU_MAC_Power(:,6),'+-k',x,ave_rate_DU_MAC_Power(:,9),'d-k',x,ave_rate_DU_MAC_Power(:,12),'square-k',x,ave_rate_DU_MAC_Power(:,15),'x-k',x,ave_rate_DU_MAC_Power(:,18),'hexagram-k',x,ave_rate_DU_with_channelgain(:,15),'^--r',x,ave_rate_DU_with_channelgain(:,18),'V--r', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,15]);
legend('1db Perfect','2 db Perfect','3db Perfect','1db History','2db History','3db History','Sum Rate Maximization','Half-Duplex','Location','NorthWest');
grid on
saveas(f3,'rate_DU_with_PowerControl_downv3','fig');
saveas(f3,'rate_DU_with_PowerControl_downv3','jpg');
%{
f4=figure;
plot(x,ave_rate_UD_with_channelgain(:,1),'o-k',x,ave_rate_UD_with_channelgain(:,4),'+-k',x,ave_rate_UD_with_channelgain(:,7),'d-k',x,ave_rate_UD_with_channelgain(:,10),'square-k',x,ave_rate_UD_with_channelgain(:,13),'x-k',x,ave_rate_UD_with_channelgain(:,16),'hexagram-k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,17]);
legend('Interference Avoidance','Interference Minimization','SINR Maximization','SINR Max-Min','Sum Rate Maximization','Half-Duplex','Location','NorthWest')
grid on
saveas(f4,'rate_UD_with_channelgain_sumv3','fig');

f5=figure;
plot(x,ave_rate_UD_with_channelgain(:,2),'o-k',x,ave_rate_UD_with_channelgain(:,5),'+-k',x,ave_rate_UD_with_channelgain(:,8),'d-k',x,ave_rate_UD_with_channelgain(:,11),'square-k',x,ave_rate_UD_with_channelgain(:,14),'x-k',x,ave_rate_UD_with_channelgain(:,17),'hexagram-k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,17]);
legend('Interference Avoidance','Interference Minimization','SINR Maximization','SINR Max-Min','Sum Rate Maximization','Half-Duplex','Location','NorthWest')
grid on
saveas(f5,'rate_UD_with_channelgain_upv3','fig');

f6=figure;
plot(x,ave_rate_UD_with_channelgain(:,3),'o-k',x,ave_rate_UD_with_channelgain(:,6),'+-k',x,ave_rate_UD_with_channelgain(:,9),'d-k',x,ave_rate_UD_with_channelgain(:,12),'square-k',x,ave_rate_UD_with_channelgain(:,15),'x-k',x,ave_rate_UD_with_channelgain(:,18),'hexagram-k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,17]);
legend('Interference Avoidance','Interference Minimization','SINR Maximization','SINR Max-Min','Sum Rate Maximization','Half-Duplex','Location','NorthWest')
grid on
saveas(f6,'rate_UD_with_channelgain_downv3','fig');

f7=figure;
plot(x,ave_rate_UD_with_channelgain(:,3),'o-k',x,ave_rate_UD_with_channelgain(:,6),'+-k',x,ave_rate_UD_with_channelgain(:,9),'d-k',x,ave_rate_UD_with_channelgain(:,12),'square-k',x,ave_rate_UD_with_channelgain(:,15),'x-k',x,ave_rate_UD_with_channelgain(:,18),'hexagram-k',...
    x,ave_rate_DU_with_channelgain(:,3),'o--k',x,ave_rate_DU_with_channelgain(:,6),'+--k',x,ave_rate_DU_with_channelgain(:,9),'d--k',x,ave_rate_DU_with_channelgain(:,12),'square--k',x,ave_rate_DU_with_channelgain(:,15),'x--k',x,ave_rate_DU_with_channelgain(:,18),'hexagram--k', 'MarkerSize', 12, 'linewidth', 2);
set(gca,'FontSize',16)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,17]);
legend('Interference Avoidance (Up-Down)','Interference Minimization (Up-Down)','SINR Maximization (Up-Down)','SINR Max-Min (Up-Down)','Sum Rate Maximization (Up-Down)','Half-Duplex (Up-Down)'...
    ,'Interference Avoidance (Down-Up)','Interference Minimization (Down-Up)','SINR Maximization (Down-Up)','SINR Max-Min (Down-Up)','Sum Rate Maximization (Down-Up)','Half-Duplex (Down-Up)','Location','NorthEastOutside')
grid on
saveas(f7,'rate_UDDU_with_channelgain_downv3','fig');

f8=figure;
plot(x,ave_rate_UD_with_channelgain(:,2),'o-k',x,ave_rate_UD_with_channelgain(:,5),'+-k',x,ave_rate_UD_with_channelgain(:,8),'d-k',x,ave_rate_UD_with_channelgain(:,11),'square-k',x,ave_rate_UD_with_channelgain(:,14),'x-k',x,ave_rate_UD_with_channelgain(:,17),'hexagram-k',...
    x,ave_rate_DU_with_channelgain(:,2),'o--k',x,ave_rate_DU_with_channelgain(:,5),'+--k',x,ave_rate_DU_with_channelgain(:,8),'d--k',x,ave_rate_DU_with_channelgain(:,11),'square--k',x,ave_rate_DU_with_channelgain(:,14),'x--k',x,ave_rate_DU_with_channelgain(:,17),'hexagram--k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,17]);
legend('Interference Avoidance (Up-Down)','Interference Minimization (Up-Down)','SINR Maximization (Up-Down)','SINR Max-Min (Up-Down)','Sum Rate Maximization (Up-Down)','Half-Duplex (Up-Down)'...
    ,'Interference Avoidance (Down-Up)','Interference Minimization (Down-Up)','SINR Maximization (Down-Up)','SINR Max-Min (Down-Up)','Sum Rate Maximization (Down-Up)','Half-Duplex (Down-Up)','Location','NorthWest')
grid on
saveas(f8,'rate_UDDU_with_channelgain_upv3','fig');

f9=figure;
plot(x,ave_rate_UD_with_channelgain(:,1),'o-k',x,ave_rate_UD_with_channelgain(:,4),'+-k',x,ave_rate_UD_with_channelgain(:,7),'d-k',x,ave_rate_UD_with_channelgain(:,10),'square-k',x,ave_rate_UD_with_channelgain(:,13),'x-k',x,ave_rate_UD_with_channelgain(:,16),'hexagram-k',...
    x,ave_rate_DU_with_channelgain(:,1),'o--k',x,ave_rate_DU_with_channelgain(:,4),'+--k',x,ave_rate_DU_with_channelgain(:,7),'d--k',x,ave_rate_DU_with_channelgain(:,10),'square--k',x,ave_rate_DU_with_channelgain(:,13),'x--k',x,ave_rate_DU_with_channelgain(:,16),'hexagram--k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
%axis([x(1,1),x(1,end),0,17]);
legend('Interference Avoidance (Up-Down)','Interference Minimization (Up-Down)','SINR Maximization (Up-Down)','SINR Max-Min (Up-Down)','Sum Rate Maximization (Up-Down)','Half-Duplex (Up-Down)'...
    ,'Interference Avoidance (Down-Up)','Interference Minimization (Down-Up)','SINR Maximization (Down-Up)','SINR Max-Min (Down-Up)','Sum Rate Maximization (Down-Up)','Half-Duplex (Down-Up)','Location','NorthWest')
grid on
saveas(f9,'rate_UDDU_with_channelgain_sumv3','fig');
%}