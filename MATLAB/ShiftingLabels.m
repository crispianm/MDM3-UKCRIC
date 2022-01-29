function [Shifted_Labels, ShiftedC_Labels, ShiftedLW_Labels] = ShiftingLabels(lb, ub, Labels, C_Labels, LW_Labels, DataVec)

%% Shifted Labels
LabelsIndex = find(Labels);
CliftonIndex = find(C_Labels);
LWIndex = find(LW_Labels);

NewLabelsIndex = [];
for i = 1:length(LabelsIndex)
    Index = LabelsIndex(i);
    [M,I] = max(abs(DataVec(Index-lb:Index+ub)));
    NewLabelsIndex(end+1) = I+Index-lb;
end

NewCliftonIndex = [];
for i = 1:length(CliftonIndex)
    Index = CliftonIndex(i);
    [M,I] = max(abs(DataVec(Index-lb:Index+ub)));
    NewCliftonIndex(end+1) = I+Index-lb;
end
    
NewLWIndex = [];
for i = 1:length(LWIndex)
    Index = LWIndex(i);
    [M,I] = max(abs(DataVec(Index-lb:Index+ub)));
    NewLWIndex(end+1) = I+Index-lb;
end


Shifted_Labels = zeros(length(Labels),1);
for i = 1:length(NewLabelsIndex)
    if sum(NewLabelsIndex==NewLabelsIndex(i))==1
        Shifted_Labels(NewLabelsIndex(i)) = 1;
    elseif sum(NewLabelsIndex ==NewLabelsIndex(i))==2
        Shifted_Labels(NewLabelsIndex(i)) = 2;    
    else
        Shifted_Labels(NewLabelsIndex(i)) = 3;
    end
end


ShiftedC_Labels = zeros(length(Labels),1);
for i = 1:length(NewCliftonIndex)
    if sum(NewCliftonIndex==NewCliftonIndex(i))==1
        ShiftedC_Labels(NewCliftonIndex(i)) = 1;
    elseif sum(NewCliftonIndex ==NewCliftonIndex(i))==2
        ShiftedC_Labels(NewCliftonIndex(i)) = 2;    
    else
        ShiftedC_Labels(NewCliftonIndex(i)) = 3;
    end
end


ShiftedLW_Labels = zeros(length(Labels),1);
for i = 1:length(NewLWIndex)
    if sum(NewLWIndex==NewLWIndex(i))==1
        ShiftedLW_Labels(NewLWIndex(i)) = 1;
    elseif sum(NewLWIndex ==NewLWIndex(i))==2
        ShiftedLW_Labels(NewLWIndex(i)) = 2;    
    else
        ShiftedLW_Labels(NewLWIndex(i)) = 3;
    end
end

end 
