function [record_distance]=fcn_distance_calculate(distance,distance_withAP,record_traffic,distance_delta,type)
record_distance=zeros(2,1);
if strcmp(type,'DU') % Down-Up
    if record_traffic(1,1)~=0
        distancewithAP=distance_withAP(1,record_traffic(1,1));
        distancewithSTA=distance(record_traffic(1,1),record_traffic(2,1));
        record_distance(1,1)=floor(distancewithAP/distance_delta)+1;
        record_distance(2,1)=floor(distancewithSTA/distance_delta)+1;
    end
else % Up-Down
    if record_traffic(2,1)~=0
        distancewithAP=distance_withAP(1,record_traffic(2,1));
        distancewithSTA=distance(record_traffic(1,1),record_traffic(2,1));
        record_distance(1,1)=floor(distancewithAP/distance_delta)+1;
        record_distance(2,1)=floor(distancewithSTA/distance_delta)+1;
    end
end



end