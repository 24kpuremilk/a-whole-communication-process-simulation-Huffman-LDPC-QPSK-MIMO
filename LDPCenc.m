function [c,H,redundance1,rate]=LDPCenc(origincode)
k = length(origincode); % length of binary code

% Generate sparse check matrix H (k*rate-k rows, k*rate columns)
rate=2;
m=k*rate-k;
n=k*rate;
H = generate_cyclic_checkM(k,rate);
if all(H(:) == 0)
    maxite=10;
    H = generate_rand_checkM(k,rate,maxite);
end
redundance1=0;

% Generate generator matrix G
if ~all(H(:) == 0)
    H2=H;
    H2(:,1:m)=H(:,n-m+1:n);
    H2(:,m+1:n)=H(:,1:n-m);
    H3=rref(H2);
    P=H3(:,m+1:n);
    I_k = eye(m);
    G = [I_k P.'];

% encode
    c = mod(origincode * G, 2); % generate code according to generator matrix G
end

%QC-LDPC
if all(H(:)==0)
    [c,H,redundance1,rate]=QC_LDPC(origincode);
end

% disp('output code');
% disp(c);