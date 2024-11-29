function [octcode, redundance2, redundance3]=bin2oct(bincode)

if size(bincode,1)>size(bincode,2)
    bincode=bincode.';
end
%In order to transfer to octal(Gray Code also ok), append "0"s to satisfy codelength is multiples of 3
l=length(bincode);
redundance2=0;
while  l/3~=ceil(l/3)
    l=l+1;
    redundance2=redundance2+1;
end
append=zeros(1,redundance2);
app=[bincode append];

%In order to let MIMO channel deal with, append "0"s to satisfy codelength is multiples of 200
block=1;
while block*200<length(app)/3
    block=block+1;
end
octcode=zeros(block*200,1);
redundance3=block*200-length(app)/3;

%transfer to octal(Gray Code also works)
for i=1:length(app)/3
    octcode(i)=bin2dec(num2str(app((i-1)*3+1:(i-1)*3+3)));
end