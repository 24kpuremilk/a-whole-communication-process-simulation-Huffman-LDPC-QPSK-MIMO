function [r1_out, r2_out, r3_out] = get_redundance(encoded_oct_Data)

newb = encoded_oct_Data(end-199:end); % Extract the last 200 elements

% Extract r1
r1_bin = 0;
[A,I] = min(newb(1:50)==0);
begin = 50 ;
if ~isempty(I)
    begin = I(1);
end
for i = begin:1:50
    r1_bin = r1_bin * 8 + newb(i);
end

% Extract r2
r2_bin = 0;
begin = 100 ;
for i = begin:1:100
    r2_bin = r2_bin * 8 + newb(i);
end

% Extract r3
r3_bin = 0;
[A,I] = min(newb(148:150)==0);
begin = 150 ;
if ~isempty(I)
    begin = I(1)+147;
end
for i = begin:1:150
    r3_bin = r3_bin * 8 + newb(i);
end
r1_out = r1_bin;
r2_out = r2_bin;
r3_out = r3_bin;
end

