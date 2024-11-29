This project is mainly to simulate the whole process of communication process. In general, it simulates that, when a people input a message(text-form), then the people on the other side recept and see this message.
In detail, there are 5 steps to simulate this:
1. Input a message, which can be text form and can include any symbols/punctuations/..., then we encode it to a binary sequence. In this project I use Huffman Code, which can save much space when compression.
   However, you can use any method to transfer your message into a binary sequence, like ASCII/UTF-8/...
2. Then I encode this binary process with LDPC method, which can check and correct some error when there are some wrongs in the transmission process.
   In this step, I first try Gallager's method, which constructs parity-check matrix by a circular matrix. But this method can failed when the sequence's length doesn't satisfy some condtion without append some bits.
   So if Gallger's method doesn't work, then I use Mackey's method, which construct PC matrix randomly first. This method can failed either.
3. At last, the LDPC code method specified in IEEE® 802.11 is used. It use a Quasi-cycle matrix. I didn't write too much detail in this function, as it has function in MATLAB toolbox, which cannot be modified.
   However, it need append some bits ("0"s in this project) to let it works.
4. We use QPSK to modulate the binary sequence.
5. Assume that the signal is transmitted through a MIMO channel， where the noise is Additive White Gaussian Noise.
6. Demodulate the signal to a Log-likelihood sequence.
7. Decode the LDPC-encoded Log-likelihood sequence to recover the sequence before LDPC encode.
8. Decode the binary sequence to the text use Huffman Decoding method (If you use ASCII/UTF-8, you should decode it with the same method).
