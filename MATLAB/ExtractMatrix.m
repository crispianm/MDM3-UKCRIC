% First load up the 'Extracting Labels' workspace
%% Note: Mislabelling afer bug at 14:33:09:250 which is the 1030081th data point
%% i.e at 7.5 second bands, nothing after row 2147 is correctly labelled

%% Matrix Dimension
Bandwidth = 5;
Seconds2Index = 64*Bandwidth;

Labels = CarLabels';
C_Labels = CliftonLabels';
LW_Labels = LWLabels';

Labels(1030081:end)=[];
C_Labels(1030081:end) = [];
LW_Labels(1030081:end) = [];

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

%% Shifted Labels
[Shifted_Labels, ShiftedC_Labels, ShiftedLW_Labels] = ShiftingLabels(0,80,Labels, C_Labels, LW_Labels, DataVec);


removeB4Labels = Seconds2Index*round(40000/Seconds2Index);

DataVec(1:removeB4Labels) = [];
Labels(1:removeB4Labels) = [];
C_Labels(1:removeB4Labels) = [];
LW_Labels(1:removeB4Labels) = [];
Shifted_Labels(1:removeB4Labels) = [];
ShiftedC_Labels(1:removeB4Labels) =[];
ShiftedLW_Labels(1:removeB4Labels)=[];


NumOfRows = floor(length(Labels)/Seconds2Index);

%% Making the Matrix
DataVec = DataVec(1:NumOfRows*Seconds2Index);
Labels = Labels(1:NumOfRows*Seconds2Index);
C_Labels = C_Labels(1:NumOfRows*Seconds2Index);
LW_Labels = LW_Labels(1:NumOfRows*Seconds2Index);
Shifted_Labels = Shifted_Labels(1:NumOfRows*Seconds2Index);
ShiftedC_Labels = ShiftedC_Labels(1:NumOfRows*Seconds2Index);
ShiftedLW_Labels = ShiftedLW_Labels(1:NumOfRows*Seconds2Index);

DataMatrix = reshape(DataVec',Seconds2Index,NumOfRows);
LabelsMatrix = reshape(Labels',Seconds2Index,NumOfRows);
C_LabelsMatrix = reshape(C_Labels',Seconds2Index,NumOfRows);
LW_LabelsMatrix = reshape(LW_Labels',Seconds2Index,NumOfRows);
ShiftedLabelsMatrix = reshape(Shifted_Labels',Seconds2Index,NumOfRows);
ShiftedC_LabelsMatrix = reshape(ShiftedC_Labels',Seconds2Index,NumOfRows);
ShiftedLW_LabelsMatrix = reshape(ShiftedLW_Labels',Seconds2Index,NumOfRows);

NumOfCars = sum(LabelsMatrix);
NumOfCars_Clifton = sum(C_LabelsMatrix);
NumOfCars_LW = sum(LW_LabelsMatrix);
NumOfCars_shifted = sum(ShiftedLabelsMatrix);
NumOfCars_Clifton_shift = sum(ShiftedC_LabelsMatrix);
NumOfCars_LW_shift = sum(ShiftedLW_LabelsMatrix);
size(NumOfCars)
size(NumOfCars_LW_shift)

theData = DataMatrix;
DataMatrix = [NumOfCars' NumOfCars_Clifton' NumOfCars_LW' theData'];
ShiftedDataMatrix = [NumOfCars_shifted' NumOfCars_Clifton_shift' NumOfCars_LW_shift' theData'];

%% Plotting

row = 2869;
xmin = (row-1)*Seconds2Index +1 ;
x = [xmin :xmin+Seconds2Index-1];
figure;
plot(x',ShiftedDataMatrix(row,4:end));

hold on
scatter(find(ShiftedC_Labels),zeros(1,length(find(ShiftedC_Labels))));
scatter(find(ShiftedLW_Labels),zeros(1,length(find(ShiftedLW_Labels))));
xlim([xmin xmin+Seconds2Index-1]);
ylim([-0.03 0.03]); 
grid on 



writematrix(DataMatrix, 'LabelledMatrixTimeDomain.csv')
writematrix(ShiftedDataMatrix, 'ShiftedLabelsMatrixTimeDomain.csv')