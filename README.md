# Physical Layer Security Implementations

This project showcases practical implementations of security techniques at the physical layer of the OSI model. It includes simulations and code-based examples demonstrating how confidentiality, authentication, and key agreement can be achieved using physical layer attributes such as channel randomness and noise.

## 🛡️ Overview

The physical layer is traditionally viewed as a passive transmission medium, but it can actively contribute to system security. This repository explores key concepts such as:

- **Wiretap Channel Models**
- **Secrecy Capacity Analysis**
- **Channel-based Key Generation**
- **Jamming and Anti-jamming Techniques**
- **Physical Layer Authentication**
- **Channel Reciprocity Exploitation**

## 📂 Contents

Repo is organized as follows:
- Each section has its own function or script
- For ease-of-use a Live script is included
- Important results have been saved to be loaded in Workspace

## ⚙️ Technologies Used

The whole project is implemented in MATLAB.

## 📈 Use Cases

- Demonstrating information-theoretic security principles
- Analyzing and comparing secure communication channel models
- Studying the impact of channel conditions on secrecy capacity
- Understanding key generation from physical layer properties
- Evaluating anti-jamming and signal obfuscation methods
- Understanding the theoretical part of the subject called "Physical Security"

<h1>⚓ Sections</h1>
Let's describe each section:
<h3>1. Creation of a Uniformly Distributed Message Source</h3>
I designed a source that generates eight messages (000 to 111 in binary) with uniform probability (1/8 each). The entropy of this source was calculated using Shannon's formula:

A sequence of 100,000 messages was generated for transmission from Alice to Bob.

<h3>2. Introduction of Local Randomness</h3>
The message size was expanded from 3 to 6 bits by introducing randomness.
Matching with new 6-bit message, I thought that for each original 3-bit message we map it to a group of 8 new 6-bit messages.  In this mapping, each original 3-bit message can mapped to a number from 0 to 7. To determine the new group and  of new messages each original message will be offset to a group of 8 new 6-bit messages. For extra randomness we randomly select one of the 8 new messages within this group (choice of 0 - 7).
	Example: The original index of the message 000 (original message) will be at position 1.
		(original_index * 1) * 8 selects the first in every team, for the original message at position 1 we have (1-1) * 8 = 0.

<h3>3. Cyclic Redundancy Check (CRC)</h3>
For every 20 intermediate messages (6-bit each), a 32-bit CRC was appended.
- **Polynomial Used:** CRC-24 = `1100001100100110011111011`
- **Implementation:** A pre-existing CRC library was used (e.g., Python's `binascii.crc32` or MATLAB’s `comm.CRCGenerator`)
- **Message Blocks:** Each block now consists of 20 × 6 = 120 bits + 32-bit CRC = **152 bits**

<h3>4. Hamming Code for Error Detection & Correction</h3>
The data was grouped into 32-bit blocks, and (7,4) Hamming encoding was applied.
NOTE: I try to use comm.HammingEncoder but it won't work.
Every 4-bit will be encoded in a 7-bit codeword. So we will get messages with length 32-bit so 32/4=8bit. Total message length: 8 * 7=56bit and in total: 56 * 100000 = 5600000 bits.
I use Hamming(7,4) which matches 4-bit messages in codewords of length 7-bit. So, 2^7=128 possible codewords. We also know that we have 32-bit messages, so 32/4=8 segments.

<h3>5. 64-QAM Modulation</h3>
The encoded bits were modulated using **64-QAM**, mapping every 6 bits to a complex symbol.

<h3>6. Superposition Coding</h3>
The bits were split into pairs, and each pair was mapped to a **subset of the 64-QAM constellation**

<h3>7. AWGN Channel Model</h3>
A Gaussian channel is created and σ is calculated with the help of the SNR.
NOTE: As input I add the messages created from section 5.

<h3>8. Channel Modeling for Bob and Eve</h3>
Two channels were simulated:
- **Bob’s Channel:** y =x+w1 
- **Eve’s Channel**: y​=x+w2

<h3>9. QAM Demodulation</h3>
Now we are on the receiver part and we demodulate 64-QAM and real messages were formed from the complex nums.

<h3>11. Reverse process in Receiver</h3>
Apply Hamming decoding and then CRC to find errors.

<h3>12. Secrecy Analysis and Protocol Suggestions</h3>
Check if secrecy achieved, do this by testing SNR values (from 25dB to 15dB). Dynamic and static test is done, 

<h3>13. Comments</h3>
Based on my results no, we would like to see the channel of Eve to be worst than the one of Alice - Bob. We want, PER of Alice-Bob channel to be as low as possible and Eve higher. I find out earlier that PER of the two channels are very close so we don't have any secrecy. 
A solution to that is to add LDPC that provides a powerful error correction which improves the reliability of communication for Bob while enhancing security by making the process of decoding the interceptor more difficult (with higher errors for Eve).
Another solution is to introduce Artificial Noise in Eve.

<h3>14. Refactoring</h3>
Now, we consider that the transmitter (Alice) now has 3 transmit antennas and 3 receive antennas on Bob, like this:
	Hm = [1.6330 0.4082 - 0.7071*1i 0.4082 + 0.7071*1i ; 1.1547 -0.5774 + 1*1i -0.5774 - 1*1i ; 0 0.7071 - 1.2247*1i -0.7071 - 1.2247*1i]

<h3>15. Choose over Beamforming and Artificial Noise</h3>
Calculate special prices (svd) and we find that they are very close to each other and none is 0, so the answer is Beamforming.
S = 3×3
    2.0000         0         0
         0    2.0000         0
         0         0    1.9999

<h3>16. Implement Beamforming</h3>
The function takes the channel matrix **Hm**, operation mode (sender/receiver), and message **s** as inputs. First, it dynamically computes power levels based on **Hm**'s dimensions (following page 24), summing them for total power—though I assumed a total power of 1 (split equally across antennas), which accidentally exceeded the theoretical limit, but I proceeded. Testing with the PDF’s example confirmed correctness. For **sender** mode, it formats the message (using **build_message_array** to replicate **s** per **Hm**’s rows) and applies the transmission formula (page 25); for **receiver** mode, it decodes using page 26’s formula, adding random noise (0–1). A test case with message **[1 0 1 0]** verified functionality. Note: this function handles **Bob only** (Eve’s case is separate). The power discrepancy remains unresolved but didn’t hinder core operations. Noise injection mimics real-world channel effects, and SVD-based precoding (for MIMO) was considered but not implemented here.

<h3>17. Find secrecy capacity</h3>
We assume channel between Alice and Eve: 
	He = [ 5 -1+1*i 3+3*i ; -3 -1-1*i -1+4*i ; -1 0 -1-7*i ]
We know Rs = Rb - Re and we want Rb > Re.
In the end we find that there is no secrecy.

<h3>18. Transmit the messages</h3>
We have:
	Hm = [ 1.6330 0.4082 - 0.7071*i 0.4082 + 0.7071*i ; 1.1547 -0.5774 + 1*i -0.5774 - 1*i ; 0 0.7071 - 1.2247*i -0.7071 - 1.2247*i ]
	and
	He = [ 5 -1+1*i 3+3*i ; -3 -1-1*i -1+4*i ; -1 0 -1-7*i ]
Repeat the process again for Bob and Eve.

## 🚀 Getting Started

Clone the repository:
```bash
git clone https://github.com/your-username/physical-layer-security.git
cd physical-layer-security
