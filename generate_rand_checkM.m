function H = generate_rand_checkM(inp,rate,maxite)
%inp represent the bits of uncoded sequence of check matrix H
%m represent the rows of check matrix H
%n represent the columns of check matrix H, also bits of after coding
%j represent the numbre of 1 in each row
%k represent the number of 1 in each column
n=rate*inp; %rate of code
m=n-inp;
H=zeros(m,n);

for r=1:maxite
for j=floor(n/5):floor(n/3)
for k=floor(m/5):floor(m/3)
for i=1:n
    order=randperm(m);
    sumcol=sum(H,1);    %sum each row
    sumrow=sum(H,2);    %sum each column
    for l=1:m
        if sumcol(i)<k && sumrow(order(l))<j
            H(l,i)=0;
        end
    end
end
end
end
end

%Determine if the check matrix H is ​​generated successfully
if any((sum(H,1)==k)==0) || any((sum(H,2)==j)==0)
    H=0;
else
    disp('check matrix is generated through Mackay’s method');
end