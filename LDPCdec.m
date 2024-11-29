%decode
function DecodedData=LDPCdec(H,c,rate,redundance1)
if size(c,1)<size(c,2)
    c=c.';
end

maxnumiter=10;
if rate~=1.33
    H=logical(sparse(H));
end
cfgLDPCDec = ldpcDecoderConfig(H);
DecodedData=ldpcDecode(100*(-2*c+1),cfgLDPCDec,maxnumiter);
DecodedData=DecodedData.';
DecodedData(length(DecodedData)-redundance1+1:end)=[];
%disp('output code');
%disp(DecodedData);