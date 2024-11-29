function EnData=add_redundance(data,redundance1,redundance2,redundance3)

newb=zeros(200,1);
%transfer decimal to binary, preparing transfer to octal
r1=dec2bin(redundance1);
r2=dec2bin(redundance2);
r3=dec2bin(redundance3);
l1=length(r1);
l2=length(r2);
l3=length(r3);
diff1=ceil(l1/3)*3-l1;
diff2=ceil(l2/3)*3-l2;
diff3=ceil(l3/3)*3-l3;

%append "0"s at the beginning of the string
if redundance1~=0
for i=1:diff1
    tem=zeros(diff1,1);
    temp=num2str(tem);
    r1=[temp r1];
end
end

if redundance2~=0
for i=1:diff2
    tem=zeros(diff2,1);
    temp=num2str(tem);
    r2=[temp r2];
end
end

if redundance3~=0
for i=1:diff3
    tem=zeros(diff3,1);
    temp=num2str(tem);
    r3=[temp r3];
end
end

l1=length(r1);
l2=length(r2);
l3=length(r3);

%transfer binary to octal, place the octal number from last to first (0~50,51~100,101~150)
if redundance1~=0
for i=1:ceil(l1/3)
    newb(50-i+1)=bin2dec(r1(l1-3*(i)+1:l1-3*(i-1)));
end
end

if redundance2~=0
for i=1:ceil(l2/3)
    newb(100-i+1)=bin2dec(r2(l2-3*(i)+1:l2-3*(i-1)));
end
end

if redundance3~=0
for i=1:ceil(l3/3)
    newb(150-i+1)=bin2dec(r3(l3-3*(i)+1:l3-3*(i-1)));
end
end

EnData=[data;newb];