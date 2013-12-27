clear all
clc
load('with_powcontrolv1_rate');
load('with_channelgainv3_rate');
x=70:5:100;

f1=figure;
plot(x,ave_rate_DU_with_channelgain(:,1),'+-k',x,ave_rate_DU_with_powcontrolv1(:,1),'o-k',x,ave_rate_DU_with_powcontrolv1(:,4),'x-k',x,ave_rate_DU_with_channelgain(:,16),'d-k','MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
axis([x(1,1),x(1,end),0,11]);
legend('Interference Avoidance without Power Control','Interference Avoidance with Power Control (Optimized)','Interference Avoidance with Power Control (Random Chosen)','Half-duplex','Location','SouthEast')
grid on
saveas(f1,'rate_DU_powcontrol_sum','fig');

f2=figure;
plot(x,ave_rate_DU_with_channelgain(:,2),'+-k',x,ave_rate_DU_with_powcontrolv1(:,2),'o-k',x,ave_rate_DU_with_powcontrolv1(:,5),'x-k',x,ave_rate_DU_with_channelgain(:,17),'d-k','MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
axis([x(1,1),x(1,end),0,11]);
legend('Interference Avoidance without Power Control','Interference Avoidance with Power Control (Optimized)','Interference Avoidance with Power Control (Random Chosen)','Half-duplex','Location','NorthWest')
grid on
saveas(f2,'rate_DU_powcontrol_up','fig');

f3=figure;
plot(x,ave_rate_DU_with_channelgain(:,3),'+-k',x,ave_rate_DU_with_powcontrolv1(:,3),'o-k',x,ave_rate_DU_with_powcontrolv1(:,6),'x-k',x,ave_rate_DU_with_channelgain(:,18),'d-k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Rate (bits/sec/Hz)');
axis([x(1,1),x(1,end),0,11]);
legend('Interference Avoidance without Power Control','Interference Avoidance with Power Control (Optimized)','Interference Avoidance with Power Control (Random Chosen)','Half-duplex','Location','NorthWest')
grid on
saveas(f3,'rate_DU_powcontrol_down','fig');

f3=figure;
plot(x,ave_power_DU_with_powcontrolv1(:,1),'o-k',x,ave_power_DU_with_powcontrolv1(:,2),'x-k', 'MarkerSize', 10, 'linewidth', 1.5);
set(gca,'FontSize',12)
xlabel('Self-Interference Cancellation Capability (dB)');
ylabel('Average Power (dBm)');
axis([x(1,1),x(1,end),0,10]);
legend('Interference Avoidance (Optimized)','Interference Avoidance (Random Chosen)','Location','SouthEast')
grid on
saveas(f3,'rate_DU_powcontrol_power','fig');