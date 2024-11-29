clear
clc

InText='Hello World';
[dict,~,origincode]=HuffmanEncode(InText);   %transfer text to binary data using Huffman code method

[encoded_bin_Data,pcmatrix,redundance1,rate]=LDPCenc(origincode);   %generate encoded data using LDPC
[encoded_oct_Data, redundance2, redundance3]=bin2oct(encoded_bin_Data); %transfer binary data
                                                        %to octal data, and append it as multiples of 200
encoded_Data=add_redundance(encoded_oct_Data,redundance1,redundance2,redundance3);   %add a new 200-item block
                                                                            %to store redundances
                                                                            
decocded_bin_Data=LDPCdec(pcmatrix,encoded_bin_Data,rate,redundance1);  %decod the decoded binary LDPC code to origincode
OutText = HuffmanDecode(decocded_bin_Data,dict);