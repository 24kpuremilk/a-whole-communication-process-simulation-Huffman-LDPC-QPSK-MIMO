function Estimate_sym = mimo_channel(sym_In, EbNo)
    frmLen = 200;       % frame length , must be divisible by N*2
    % numPackets = 1000;  % number of packets
    % EbNo = 0:2:20;      % Eb/No varying to 20 dB
    numPackets = length(sym_In)/frmLen;
    Estimate_sym = zeros(numPackets*frmLen,1);
    EbNo = EbNo; 
    N = 4;              % maximum number of Tx antennas
    M = 4;              % maximum number of Rx antennas M=N
    P = 8;				% modulation order
    
    SNR = convertSNR(EbNo,"ebno","BitsPerSymbol",1);
    
    errorCalc1 = comm.ErrorRate;
    
    % s = rng(55408);
    
    % sym_In = zeros(frmLen, 1);
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
    % fig = figure; 
    % grid on;
    % ax = fig.CurrentAxes;
    % hold(ax,'on');
    
    % ax.YScale = 'log';
    % ylim(ax,[1e-4 1]);
    % xlabel(ax,'Eb/No (dB)');
    % ylabel(ax,'BER'); 
    % fig.NumberTitle = 'off';
    % fig.Name = 'Multiple-eigenmode transmission';
    % title(ax,'Multiple-eigenmode transmission');
    % set(fig, 'DefaultLegendAutoUpdate', 'off');
    % fig.Position = figposition([15 50 25 30]);
    
    % Loop over several EbNo points
    for idx = 1:length(EbNo)
        reset(errorCalc1);
        % Loop over the number of packets
        for packetIdx = 1:numPackets
            % Generate data vector per frame 
            % sym_In = randi([0 P-1], frmLen, 1); 
            % Modulate data
            modData = pskmod(sym_In((packetIdx-1)*frmLen+1:(packetIdx)*frmLen),P);
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
            Estimate_sym((packetIdx-1)*frmLen+1:(packetIdx)*frmLen) = pskdemod(sym_n,P);
    
            
            % Calculate and update BER for current EbNo value
            ber_multiple_eign(:,packetIdx)  = errorCalc1(sym_In((packetIdx-1)*frmLen+1:(packetIdx)*frmLen), Estimate_sym((packetIdx-1)*frmLen+1:(packetIdx)*frmLen));
        end % end of FOR loop for numPackets
        
        % % Plot results
        % semilogy(ax,1:numPackets, ber_multiple_eign(1,1:numPackets), 'r*');
        % legend(ax,'multiple_eignmode transmission');
        % drawnow;
    end  % end of for loop for EbNo
     
    % Perform curve fitting and replot the results
    % fitBER_eign = berfit(EbNo, ber_multiple_eign(1,:));
    % semilogy(ax,EbNo, fitBER_eign, 'r');
    % hold(ax,'off');
    
    % Restore default stream
    % rng(s);