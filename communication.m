clear
clc
packet_num = 100 ;
error_num = 0;
EbNo = 20 ; 
for pkt_ind = 1: packet_num 
    try
        length_of_string = 10;  % Specify the length of the string
        characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        random_indices = randi(numel(characters), [1, length_of_string]);
        input_str = characters(random_indices);
        [dict,~,origincode]=HuffmanEncode(input_str);   %transfer text to binary data using Huffman code method
        
        [encoded_bin_Data,pcmatrix,redundance1,rate]=LDPCenc(origincode);   %generate encoded data using LDPC
        [encoded_oct_Data, redundance2, redundance3]=bin2oct(encoded_bin_Data); %transfer binary data
                                                                %to octal data, and append it as multiples of 200
        encoded_Data=add_redundance(encoded_oct_Data,redundance1,redundance2,redundance3);   %add a new 200-item block
                                                                                    %to store redundances
        mimo_out = mimo_channel(encoded_Data, EbNo);                                                                     
        [redundance1_out,redundance2_out,redundance3_out] = get_redundance(mimo_out);
        encoded_bin_Data = get_bin_input(mimo_out, redundance2_out, redundance3_out);
        decocded_bin_Data=LDPCdec(pcmatrix,encoded_bin_Data,rate,redundance1);  %decod the decoded binary LDPC code to origincode
        OutText = HuffmanDecode(decocded_bin_Data,dict);
        assert(strcmp(OutText, input_str));
        disp(['Pkt [',num2str(pkt_ind),']: transmission finished']);
        disp(OutText);
    catch ME
        disp(['Pkt [',num2str(pkt_ind),']: transmission failed']);
        error_num = error_num +1;
    end 
end
error_rate = error_num/packet_num;
disp("error_rate at EbNo="+num2str(EbNo)+" is "+num2str(error_rate));