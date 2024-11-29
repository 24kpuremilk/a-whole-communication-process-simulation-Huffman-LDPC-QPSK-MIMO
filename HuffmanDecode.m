function Text=HuffmanDecode(decocded_bin_Data,dict)

Text=cell2mat(huffmandeco(double(decocded_bin_Data),dict));
disp(Text);