%% Data Labelling
DTA1 = table2array(accelerometerdatasection1(:,1));
DTA2 = table2array(accelerometerdatasection2(:,1));
DTA3 = table2array(accelerometerdatasection3(:,1));
DTA4 = table2array(accelerometerdatasection4(:,1));
DTA5 = table2array(accelerometerdatasection5(:,1));
DTA6 = table2array(accelerometerdatasection6(:,1));
DTA7 = table2array(accelerometerdatasection7(:,1));
DTA4(end) = [];
DTA3(end) = [];
DTA5(end) = [];
DTA6(539247:end) = [];
VTS = table2array(vehicletimestamps(:,1));
OHE = onehotencode(table2array(vehicletimestamps(:,2)),2);
Clifton = OHE(:,1);
Leigh_Woods = OHE(:,2);
        
% Remove vehicle time stamps for between acclerometer readings
removethese = [];
for i = 1:length(VTS)
    if isbetween(VTS(i),DTA1(end),DTA2(1)) == 1
        removethese(end+1) = i;
    elseif isbetween(VTS(i),DTA2(end),DTA3(1)) == 1
        removethese(end+1) = i;
    elseif isbetween(VTS(i),DTA3(end),DTA4(1)) == 1
        removethese(end+1) = i;
    elseif isbetween(VTS(i), DTA4(end),DTA5(1)) == 1
        removethese(end+1) = i;
    elseif isbetween(VTS(i), DTA5(end), DTA6(1)) == 1
        removethese(end+1) = i;
    elseif isbetween(VTS(i), DTA6(end),DTA7(1)) ==1
        removethese(end+1) = i;
    end
end
VTS(removethese) = [];
Clifton(removethese) = [];
Leigh_Woods(removethese) = [];

DTA = [DTA1; DTA2; DTA3; DTA4; DTA5; DTA6; DTA7];
CarLabels = [];
CliftonLabels = [];
LWLabels = [];
for i = 1:length(DTA)
    if isbetween(VTS(1),DTA(i)-seconds(1)-milliseconds(100),DTA(i)+seconds(1)) == 1
        CarLabels(end+1) = 1;
        if Clifton(1) == 1
            CliftonLabels(end+1) = 1;
            LWLabels(end+1) = 0;
        else
            LWLabels(end+1) = 1;
            CliftonLabels(end+1) = 0;
        end
        VTS(1) = [];
        Clifton(1) = [];
        Leigh_Woods(1) = [];
    else
        CarLabels(end+1) = 0;
        CliftonLabels(end+1) = 0;
        LWLabels(end+1) = 0;
    end
end




    
    