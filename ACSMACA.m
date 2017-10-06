%ThaoVo
%Concurrent Communication - CSMA:CA
%Stations A,B,C,D of Figure 1a are  within the same collision domain
% (any transmission is received by all). Communication takes place between pairs
% A B and C D. Traffic is generated at A and C according to a Poisson arrival 
% process with parameters A and C, respectively.

clc
clear all
%Given Paramater:
% dataFrameSize 1500 bytes;
% SlotDuration = 20 microsec;
% SIFS = 10microscs; 0.5 slots
% lambdaA/C {50, 100, 200, 300} frames/sec
% ACK, RTS, CTS = 30 bytes; => 2 slots = round to 1 slot
%DIFS = 40 microsec;
%Transmission rate = 6Mbps;
%ContentionMax = 1024 slots;
%simulation time = 10 sec;
% 1 sec = 50,000 slots since each slot = 20 microsec
% A&C Concurrently => 100,000 slots

Contention_Window=4; %contention_window
lambdaA=500; %plug in multiple values for lambda to get results
lambdaC=lambdaA;
nPackets=100;
A=zeros(1,100000); C=zeros(1,100000);

%simulating the traffic by using rand
UA=rand(1,nPackets);
XA=-log(1-UA)./lambdaA;
frameA=round(XA./0.00002); %poisson distribution
UC=rand(1,nPackets);
XC=-log(1-UC)./lambdaC;
frameC=round(XC./0.00002); %poisson distribution

% 1 sec = 50,000 slots
% for each slot, update status of node A & C

for i=2:nPackets
    frameA(i)=frameA(i)+frameA(i-1);
    frameC(i)=frameC(i)+frameC(i-1);
end

frameA=[frameA,160000];
frameC=[frameC,160000];

% Frame A
frameA_ready_to_send=1;
A_DIFS=2; % DIFS = 40 microsec = 2 slots
A_Contention_Window=randi(Contention_Window,1)-1;
A_sending=100;
A_SIFS=0.5; % SIFS = 10 microsec = 0.5 slots
A_collision=0;
A_success=0;

% Frame C
frameC_ready_to_send=1;
C_DIFS=2;
C_Contention_Window=randi(Contention_Window,1)-1;
C_sending=100;
C_SIFS=0.5;
C_collision=0;
C_success=0;

% Begin
for t=1:100000
	%frame A
    if frameA(frameA_ready_to_send)>t
        idleA=1;
	else
		idleA=0;
	end
    if idleA==1
        A(t)=0;
    else
        if A_DIFS>0 && C(t)<3
            A(t)=1;
            A_DIFS=A_DIFS-1;
        else
            if A_Contention_Window>0
				A(t)=2;
				if A_Contention_Window<C_Contention_Window
					A_Contention_Window=A_Contention_Window-1;
					C_Contention_Window=C_Contention_Window-1;
				elseif A_Contention_Window==C_Contention_Window
					A_Contention_Window=A_Contention_Window-1;
					C_Contention_Window=C_Contention_Window-1;
					if A_Contention_Window==0 && C_Contention_Window==0
						A_collision=A_collision+1;
						C_collision=C_collision+1;
						Contention_Window=Contention_Window*2;
						if Contention_Window>1024
							Contention_Window=1024;
						end
						A_DIFS=2;
						A_Contention_Window=randi(Contention_Window,1)-1;
						C_DIFS=2;
						C_Contention_Window=randi(Contention_Window,1)-1;
					end
				elseif A_Contention_Window>C_Contention_Window
					if C_Contention_Window>0
						A_Contention_Window=A_Contention_Window-1;
						C_Contention_Window=C_Contention_Window-1;
					end
				end
            else
                if A_sending>0
                    A(t)=3;
                    A_sending=A_sending-1;
                else
                    if A_SIFS>0
                        A(t)=4;
                        A_SIFS=A_SIFS-0.5;
                    else
                        A_success=A_success+1;
                        A(t)=5;
                        Contention_Window=4;
                        frameA_ready_to_send=frameA_ready_to_send+1;
                        A_DIFS=2;
                        A_Contention_Window=randi(Contention_Window,1)-1;
                        A_sending=100;
                        A_SIFS=0.5;
                    end
                end
            end
        end
    end

	%frame C
	if frameC(frameC_ready_to_send)>t
        idleC=1;
    else
        idleC=0;
    end
    if idleC==1
        C(t)=0;
    else
        if C_DIFS>0 && A(t)<3
            C(t)=1;
            C_DIFS=C_DIFS-1;
        else
            if C_Contention_Window>0
				C(t)=2;
            else
                if C_sending>0
                    C(t)=3;
                    C_sending=C_sending-1;
                else
                    if C_SIFS>0
                        C(t)=4;
                        C_SIFS=C_SIFS-0.5;
                    else
                        C_success=C_success+1;
                        C(t)=5;
                        Contention_Window=4;
                        frameC_ready_to_send=frameC_ready_to_send+1;
                        C_DIFS=2;
                        C_Contention_Window=randi(Contention_Window,1)-1;
                        C_sending=100;
                        C_SIFS=0.5;
                    end
                end
            end
        end
    end
end

%Finally
A_first=find(A~=0);
A_end=find(A==5);
A_throughput=A_success*1500*8/((A_end(end)-A_first(1))*0.00002);
A_delay=(sum(A_end(1:A_success))-sum(frameA(1:A_success)))*0.00002/nPackets;

C_first=find(C~=0);
C_end=find(C==5);
C_throughput=C_success*1500*8/((C_end(end)-C_first(1))*0.00002);
C_delay=(sum(C_end(1:C_success))-sum(frameC(1:C_success)))*0.00002/nPackets;

Title="Figure A - CSMA:CA"
A_Throughput=A_throughput
A_Delay=A_delay
C_Throughput=C_throughput
C_Delay=C_delay
