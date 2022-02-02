%% Extracting direction matrix
A=ShiftedDataMatrix;
A(:,1) = [];
DirectionMatrix=zeros(1,size(A,2)); %Create dummy row, gets removed after.
for i = 1:size(A,1)
    R=A(i,:);
    if A(i,1)==1
        if A(i,2)==0
           DirectionMatrix=[DirectionMatrix;R]; %#ok<AGROW> 
        end
    else
        if A(i,1)==0
           if A(i,2)==1
           DirectionMatrix=[DirectionMatrix;R]; %#ok<AGROW>
           end
        end
    end
end
DirectionMatrix(1,:) = [];
DirectionMatrix(:,2) = [];
%writematrix(DirectionMatrix, 'DiretionMatrix.csv')
