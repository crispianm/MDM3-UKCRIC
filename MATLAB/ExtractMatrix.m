% First load up the 'Extracting Labels' workspace

%% Matrix Dimension
Bandwidth = 7.5;
Seconds2Index = 64*Bandwidth;

Labels = CarLabels';
C_Labels = CliftonLabels';
LW_Labels = LWLabels';

%% Removing outlier values and combining data
A1 = table2array(accelerometerdatasection1(:,2));
A2 = table2array(accelerometerdatasection2(:,2));
A3 = table2array(accelerometerdatasection3(:,2));
A4 = table2array(accelerometerdatasection4(:,2));
A5 = table2array(accelerometerdatasection5(:,2));
A6 = table2array(accelerometerdatasection6(:,2));
A7 = table2array(accelerometerdatasection7(:,2));
A3(end) = [];
A4(end) = [];
A5(end) = [];
A6(end) = [];

DataVec = [A1;A2;A3;A4;A5;A6;A7];
DataVec([length(Labels)+1:end])=[];

removeB4Labels = Seconds2Index*round(40000/Seconds2Index);

DataVec(1:removeB4Labels) = [];
Labels(1:removeB4Labels) = [];
C_Labels(1:removeB4Labels) = [];
LW_Labels(1:removeB4Labels) = [];

NumOfRows = floor(length(Labels)/Seconds2Index);

%% Making the Matrix
DataVec = DataVec(1:NumOfRows*Seconds2Index);
Labels = Labels(1:NumOfRows*Seconds2Index);
C_Labels = C_Labels(1:NumOfRows*Seconds2Index);
LW_Labels = LW_Labels(1:NumOfRows*Seconds2Index);

DataMatrix = reshape(DataVec',Seconds2Index,NumOfRows);
LabelsMatrix = reshape(Labels',Seconds2Index,NumOfRows);
C_LabelsMatrix = reshape(C_Labels',Seconds2Index,NumOfRows);
LW_LabelsMatrix = reshape(LW_Labels',Seconds2Index,NumOfRows);

NumOfCars = sum(LabelsMatrix);
NumOfCars_Clifton = sum(C_LabelsMatrix);
NumOfCars_LW = sum(LW_LabelsMatrix);

DataMatrix = [NumOfCars' NumOfCars_Clifton' NumOfCars_LW' DataMatrix'];

%% Plotting
row = 1;
NoOfCars = 3;
xmin = (row-1)*Seconds2Index +1 ;
x = [xmin :xmin+Seconds2Index-1];

figure;
plot(x',DataMatrix(row,4:end))
hold on
scatter(find(C_Labels),zeros(1,length(find(C_Labels))));
scatter(find(LW_Labels),zeros(1,length(find(LW_Labels))));
xlim([xmin xmin+Seconds2Index-1]);
ylim([-0.03 0.03]); 
grid on 

writematrix(DataMatrix, 'LabelledMatrixTimeDomain.csv')