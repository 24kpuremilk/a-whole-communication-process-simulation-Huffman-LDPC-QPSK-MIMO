frmLen = 600;       % frame length , must be divisible by N*2
% numPackets = 1000;  % number of packets
EbNo = 0:2:20;      % Eb/No varying to 20 dB
numPackets = 1;
% EbNo = 20; 
N = 4;              % maximum number of Tx antennas
M = 4;              % maximum number of Rx antennas M=N
P = 8;				% modulation order

SNR = convertSNR(EbNo,"ebno","BitsPerSymbol",1);

errorCalc1 = comm.ErrorRate;

s = rng(55408);

sym_In = zeros(frmLen, 1);
chanIn = zeros(frmLen/N, N);
Enc_chanIn = zeros(frmLen/N, N);
H = zeros(frmLen/N, M, N);
chanOut = zeros(frmLen/N, M);
chanOut_n = zeros(frmLen/N, M);
sym_n = zeros(frmLen, 1);
Estimate_sym = zeros(frmLen, 1);

ber_multiple_eign  = zeros(3,length(EbNo));
ber_thy2     = zeros(1,length(EbNo));
%%

% Set up a figure for visualizing BER results
fig = figure; 
grid on;
ax = fig.CurrentAxes;
hold(ax,'on');

ax.YScale = 'log';
xlim(ax,[EbNo(1), EbNo(end)]);
ylim(ax,[1e-4 1]);
xlabel(ax,'Eb/No (dB)');
ylabel(ax,'BER'); 
fig.NumberTitle = 'off';
fig.Name = 'Multiple-eigenmode transmission';
title(ax,'Multiple-eigenmode transmission');
set(fig, 'DefaultLegendAutoUpdate', 'off');
fig.Position = figposition([15 50 25 30]);

% Loop over several EbNo points
for idx = 1:length(EbNo)
    reset(errorCalc1);
    % Loop over the number of packets
    for packetIdx = 1:numPackets
        % Generate data vector per frame 
        % sym_In = randi([0 P-1], frmLen, 1); 
        sym_In = encoded_Data;
        % Modulate data
        modData = pskmod(sym_In,P);
        chanIn = reshape(modData,[N , frmLen/N]).' ; 
       
        % Create the Rayleigh distributed channel response matrix
        %   for two transmit and two receive antennas
        H(1:2:end, :, :) = (randn(frmLen/N/2, M,N) + ...
                         1i*randn(frmLen/N/2, M,N))/sqrt(2);
        %   assume held constant for 2 symbol periods
        H(2:2:end, :, :) = H(1:2:end, :, :);
        
        for i = 1:2: frmLen/N 
            [U,S,V] = svd(squeeze(H(i,:,:))) ;
            Enc_chanIn(i,:) = (V*chanIn(i,:).').';
            Enc_chanIn(i+1,:) = (V*chanIn(i+1,:).').';
            chanOut(i,:) = squeeze(H(i,:,:)) * Enc_chanIn(i,:).' ;
            chanOut(i+1,:) = squeeze(H(i,:,:)) * Enc_chanIn(i+1,:).' ;
        end
        chanOut_n = reshape(awgn(reshape(chanOut.',[frmLen/N*M, 1]),SNR(idx)),[M, frmLen/N]).';
        for i = 1:2: frmLen/N 
            [U,S,V] = svd(squeeze(H(i,:,:)))  ;
            sym_n((i-1)*M+1:i*M) = U'*chanOut_n(i,:).';
            sym_n(i*M+1:(i+1)*M) = U'*chanOut_n(i+1,:).';
        end
              

        % ML Detector (minimum Euclidean distance)
        Estimate_sym = pskdemod(sym_n,P);

        
        % Calculate and update BER for current EbNo value
        ber_multiple_eign(:,idx)  = errorCalc1(sym_In, Estimate_sym);
    end % end of FOR loop for numPackets

    % Calculate theoretical second-order diversity BER for current EbNo
    ber_thy2(idx) = berfading(EbNo(idx), 'psk', 2, 2);
    
    % Plot results
    semilogy(ax,EbNo(1:idx), ber_multiple_eign(1,1:idx), 'r*', ...
             EbNo(1:idx), ber_thy2(1:idx), 'm');
    legend(ax,'multiple_eignmode transmission',...
           'Theoretical 2nd-Order Diversity');
    
    drawnow;
end  % end of for loop for EbNo
 
% Perform curve fitting and replot the results
fitBER_eign = berfit(EbNo, ber_multiple_eign(1,:));
semilogy(ax,EbNo, fitBER_eign, 'r');
hold(ax,'off');

% Restore default stream
rng(s);