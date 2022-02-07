%% creating new matrix
column_index = [1:size(DataMatrix,1)];

newMatrix = [column_index', DataMatrix(:,4:end)];

writematrix(newMatrix, 'testMatrix.csv')