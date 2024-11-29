% Given a string, the function finds its letters, their frequencies, and
% constructs a Huffman code. It provides the dictionary for the Huffman
% code, as well as its average length and the compressed signal.
function [dict_,avglen,sig_comp] = HuffmanEncode(sig)
letters_str = unique(sig);
letters = {};
M = numel(letters_str);
L = length(sig);

%% Compute the frequencies of the letters
freq = zeros(1,M);
for i = 1:M
    for j = 1:L
        if letters_str(i) == sig(j)
            freq(i) = freq(i) + 1;
        end
    end
    letters{i} = letters_str(i);
end
freq = freq/sum(freq);

%% find the huffman code and code lengths
[dict, avglen]  = huffmandict(letters,freq);
dict = table(dict(:,1),dict(:,2)); dict.Properties.VariableNames={'letter','codeword'};
freq_table=table(letters',freq'); freq_table.Properties.VariableNames = {'letter','freq'};
dict = join(dict,freq_table,"Keys","letter");
dict.lens = cellfun(@(x) length(x), dict.codeword);
dict = sortrows(dict,{'lens','letter'});

%% preform encoding
dict_ = table2cell(dict(:,[1,2]));
sig_comp = huffmanenco(sig,dict_);
%sig_comp = num2str(sig_comp,'%d');