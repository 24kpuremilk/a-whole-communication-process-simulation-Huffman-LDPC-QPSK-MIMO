function H = generate_cyclic_checkM(inp,rate)
%inp represent the bits of uncoded sequence of check matrix H
%m represent the rows of check matrix H
%n represent the columns of check matrix H, also bits of after coding
%j represent the numbre of 1 in each row
%k represent the number of 1 in each column
n=rate*inp; %rate of code
m=n-inp;
H=zeros(m,n);

%let 1 in each rows and each columns are the same, respectively
for j=ceil(n/5+1):-1:1
    if n/j==ceil(n/j) && m/(n/j)==ceil(m/(n/j))
        break
    end
end
% spar=5; %check matrix H should be sparse
% j=ceil(spar/6);

%Generate H1
for i=1:n/j
    H(i,(i-1)*j+1:(i-1)*j+j)=1;
end
% i=i+1;
% H(i,(i-1)*j+1:end)=1;

%Generate H2, H3, ...
for i=2:m/(n/j)
    for ii=1:n/j
        for iii=1:j
            H((i-1)*n/j+ii,(iii-1)*i+iii+ii-1)=1;  %for Hi, its "1" on is seperated by i 0s
        end
    end
end

% Hn=zeros(m,ceil(m/j));
% for ii=1:ceil(m/j)-1
%     for iii=1:j
%         Hn(ii,(iii-1)*i+iii+ii-1)=1;  %for Hi, its "1" on is seperated by i 0
%     end
% end
% 
% d=n-i*ceil(m/j);
% H(i+1:end,:)=Hn(1:d,:);


%Determine if the check matrix H is ​​generated successfully
if any((sum(H,1)==sum(H(:,1)))==0) || any((sum(H,2)==j)==0)
    H=0;
else
    disp('check matrix is generated through Gallager’s method');
end