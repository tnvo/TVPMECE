# TVPMECE

Working folder for my networking class. Read more in project 1 pdf. Context:

```
Our group will model the behavior of a Carrier Sense Multiple Access(CSMA)/Collision Avoidance (CA) and CSMA/CA with Virtual Carrier Sensing (VCS) to simulate and evaluate the performance metrics between them. The main differences between CSMA/CA vs. VCS are as follows:

CSMA:
Detect a collision early and abort the transmission.
Each node tries to retransmit at a contention slot with probability p. 
If a collision occurs, it is detected at the end of the contention slot.
If the transmission is a success, no other host tries to transmit till the end of the packet slot.

VCS:
Collisions are receiver dependent, both transmission will be successful.
Senses channel for DIFs (DCF Interframe Space), if the channel is busy continue to sense, otherwise select a random backoff time b in [0, CW] and reduce by one with every idle slot.
 If the channel becomes busy, freeze the counter. If counter = 0, send RTS with NAV (Network Allocation Vector). Receiver acknowledges via CTS after SIFS (Short Interframe Space). 
CTS reserves channel for sender, notifying possibly hidden stations; any station hearing the CTS should be silent for the NAV. Sender can now send data immediately.

```
