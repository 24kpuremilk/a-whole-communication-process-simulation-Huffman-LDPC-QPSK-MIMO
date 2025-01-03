function [encodedData, pcmatrix,redundance,rate] = QC_LDPC(origindata)

P = [
    16 17 22 24  9  3 14 -1  4  2  7 -1 26 -1  2 -1 21 -1  1  0 -1 -1 -1 -1
    25 12 12  3  3 26  6 21 -1 15 22 -1 15 -1  4 -1 -1 16 -1  0  0 -1 -1 -1
    25 18 26 16 22 23  9 -1  0 -1  4 -1  4 -1  8 23 11 -1 -1 -1  0  0 -1 -1
     9  7  0  1 17 -1 -1  7  3 -1  3 23 -1 16 -1 -1 21 -1  0 -1 -1  0  0 -1
    24  5 26  7  1 -1 -1 15 24 15 -1  8 -1 13 -1 13 -1 11 -1 -1 -1 -1  0  0
     2  2 19 14 24  1 15 19 -1 21 -1  2 -1 24 -1  3 -1  2  1 -1 -1 -1 -1  0
    ];
i=3;
blockSize = i^3;
pcmatrix = ldpcQuasiCyclicMatrix(blockSize,P);
cfgLDPCEnc = ldpcEncoderConfig(pcmatrix);
while cfgLDPCEnc.NumInformationBits<length(origindata)
    blockSize = i^3;
    i=i+1;
    pcmatrix = ldpcQuasiCyclicMatrix(blockSize,P);
    cfgLDPCEnc = ldpcEncoderConfig(pcmatrix);
end

origindata=origindata.';
data=zeros(cfgLDPCEnc.NumInformationBits,1);
data(1:length(origindata))=origindata;
redundance=cfgLDPCEnc.NumInformationBits-length(origindata);

encodedData = ldpcEncode(data,cfgLDPCEnc);
rate=1.33;
disp('Configure the 3/4 rate LDPC code specified in IEEE® 802.11., check matrix is generated through QC_LDPC method');