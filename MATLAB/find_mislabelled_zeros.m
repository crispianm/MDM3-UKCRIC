function [mislabelled_zeros_index] = find_mislabelled_zeros(indexing,data)
mislabelled_zeros_index = [];
for i = 1:length(indexing)
    if data(indexing(i))== 0
        mislabelled_zeros_index(end+1) = indexing(i);
    end
end

        