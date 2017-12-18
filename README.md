# polar-3gpp-matlab
Matlab simulations of the encoder and SCL decoder for the New Radio polar code from 3GPP Release 15.

At the time of writing, the most recent version of the relevant 3GPP standard is [TS38.212 V1.2.1](http://www.3gpp.org/ftp/TSG_RAN/WG1_RL1/TSGR1_91/Docs/R1-1721342.zip).


![PBCH](./results/PBCH.svg) | ![PDCCH](./results/PDCCH.svg)
--- | ---
Plot of Block Error Rate (BLER) versus channel Signal to Noise Ratio (SNR) E<sub>s</sub>/N<sub>0</sub> for the Public Broadcast Channel (PBCH) polar code of 3GPP New Radio, when using Quadrature Phase Shift Keying (QPSK) for communication over an Additive White Gaussian Noise (AWGN) channel. Here, A is the number of bits in each information block, E is the number of bits in each encoded block and L is the list size used during min-sum Successive Cancellation List (SCL) decoding. The simulation of each SNR was continued until 1000 block errors were observed. | Plot of Signal to Noise Ratio (SNR) E<sub>s</sub>/N<sub>0</sub> required to achieve a Block Error Rate (BLER) of 10<sup>-3</sup> versus number bits in each information block A for the Physical Downlink Control Channel (PDCCH) polar code of 3GPP New Radio, when using Quadrature Phase Shift Keying (QPSK) for communication over an Additive White Gaussian Noise (AWGN) channel. Here, E is the number of bits in each encoded block and L is the list size used during min-sum Successive Cancellation List (SCL) decoding. The simulation of each SNR was continued until 100 block errors were observed.


Section of TS38.212 | Implemented in | Comment
--- | --- | ---
5.1 |  [components/get_crc_generator_matrix.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_crc_generator_matrix.m) | The CRC bits are generated using b = [a, mod(a*G_P, 2)].
5.2.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) | The first and second segments are obtained as a(1:floor(A/C)) and a(floor(A/C)+1:A), respectively.
5.3.1 | [components/get_3GPP_N.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_N.m) |
5.3.1.1 | [components/get_3GPP_crc_interleaver_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_crc_interleaver_pattern.m) | Interleaving is implemented using c_prime = c(Pi).
5.3.1.2 Q<sub>0</sub><sup>N-1</sup> | [components/get_3GPP_sequence_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_sequence_pattern.m) | The elements of Q<sub>0</sub><sup>N-1</sup> are incremented by 1, since indices begin at 1 in Matlab.
5.3.1.2 Q<sub>PC</sub><sup>N</sup> | [components/get_PC_bit_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_PC_bit_pattern.m) | Provides a vector of N elements, in which the elements with the indices Q<sub>PC</sub><sup>N</sup> are set to true and all other elements are set to false.
5.3.1.2 u | [components/PCCA_polar_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/PCCA_polar_encoder.m) | Other components/\*_polar_encoder.m files are also useful for special cases without PC bits, without CRC bits or with distributed CRC bits.
5.3.1.2 G<sub>N</sub> | [components/get_G_N.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_G_N.m) | Encoding is implemented using d = mod(u\*G_N, 2).
5.4.1.1 P(i) | [components/get_3GPP_rate_matching_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_rate_matching_pattern.m) |
5.4.1.1 Q<sub>I</sub><sup>N</sup> | [components/get_3GPP_info_bit_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_info_bit_pattern.m) | Provides a vector of N elements, in which the elements with the indices Q<sub>I</sub><sup>N</sup> are set to true and all other elements are set to false.
5.4.1.2 | [components/get_3GPP_rate_matching_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_rate_matching_pattern.m) | Rate matching is implemented using e = d(rate_matching_pattern).
5.4.1.3 | [components/get_3GPP_channel_interleaver_pattern.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/components/get_3GPP_channel_interleaver_pattern.m) | Interleaving is implemented using f = e(channel_interleaver_pattern).
5.5 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) | The first and second segments are concatenated using f = [f, ...].
6.3.1.2.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) |
6.3.1.3.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) |
6.3.1.4.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) | Rate matching is implemented, but not the determination of E<sub>UCI</sub>.
6.3.1.5 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) |
6.3.2.2.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) |
6.3.2.3.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) |
6.3.2.4.1 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) | Rate matching is implemented, but not the determination of E<sub>UCI</sub>.
6.3.2.5 | [PUCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PUCCH_encoder.m) |
7.1.3 | [PBCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PBCH_encoder.m) |
7.1.4 | [PBCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PBCH_encoder.m) |
7.1.5 | [PBCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PBCH_encoder.m) |
7.3.1 | [PDCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PDCCH_encoder.m) | Only implements the zero padding of DCI formats, to increase their length to 12 bits.
7.3.2 | [PDCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PDCCH_encoder.m) |
7.3.3 | [PDCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PDCCH_encoder.m) |
7.3.4 | [PDCCH_encoder.m](https://github.com/robmaunder/polar-3gpp-matlab/blob/master/PDCCH_encoder.m) |

Each of the \*_encoder.m files has corresponding \*_decoder.m files, for performing the corresponding operation of the receiver.

Many thanks to my colleagues at [AccelerComm](http://www.accelercomm.com), who have spent lots of time double checking that this code matches the standard.

Have fun! Rob.

