% Thao Vo - ECE 578
% Concurrent Communication - VCS

clc
clear all;

%Given Paramater:
% dataFrameSize 1500 bytes;
% SlotDuration = 20 microsec;
% SIFS = 10microscs; 0.5 slots => rounding to 1 slot
% lambdaA/C {50, 100, 200, 300} frames/sec
% ACK, RTS, CTS = 30 bytes; => 2 slots = round to 1 slot
%DIFS = 40 microsec;
%Transmission rate = 6Mbps;
%ContentionMax = 1024 slots;
%simulation time = 10 sec;
% 1 sec = 50,000 slots since each slot = 20 microsec
% 2 sec = 100,000 slots 
%RTS, CTS, ACK = 40 microsec = 2 slots


lambdaA=500;
lambdaC=lambdaA/2;
Contention_Window=4;
nPackets=50;

A=zeros(1,50000);%the status of node A and C
C=zeros(1,50000);
B_freeze=zeros(1,50000);%if node B or C is freezed,set the corresponding number to 1
C_freeze=zeros(1,50000);


UA=rand(1,nPackets);
XA=-log(1-UA)./lambdaA;
frameA=round(XA./0.00002);%generate the frames by Poisson Distribution,the unit is slot
UC=rand(1,nPackets);
XC=-log(1-UC)./lambdaC;
frameC=round(XC./0.00002);

for i=2:nPackets%compute the time each frame was generated
    frameA(i)=frameA(i)+frameA(i-1);
    frameC(i)=frameC(i)+frameC(i-1);
end
frameA=[frameA,80000];
frameC=[frameC,80000];

A_Ready_To_Send=1;%the number of packet that is going to be transmitted
A_DIFS=2; %40 microsec = 2 slots
A_Contention_Window=0;
A_Sending=100;
A_SIFS=0.5; %10 microsec = 0.5 slots
A_collision=0;
A_success=0;
A_RTS=2; %40 microsec = 2 slots
A_SIFS_CTS=1;%the SIFS before CTS
A_CTS=2;  %40 microsec = 2 slots. SIFS before ACK
A_SIFS_DATA=0.5;% the SIFS before DATA


C_Ready_To_Send=1;
C_DIFS=2;
C_Contention_Window=0;
C_Sending=100;
C_SIFS=0.5;
C_collision=0;
C_success=0;
C_RTS=2;
C_SIFS_CTS=0.5;
C_CTS=2;
C_SIFS_DATA=0.5;


for t=1:50000%Main loop, use this to update the data in A and C
% ------------------------------------------------
% A B

    if frameA(A_Ready_To_Send)>t
        idle_A=1; %idle
    else
        idle_A=0;
    end
 
    if idle_A==1
        A(t)=0; % idle
    else
        if A_DIFS>0
            A(t)=1; % every station sense for DIFS
            A_DIFS=A_DIFS-1;
        else
            if A_Contention_Window>0
                A(t)=2; %Contention Window Min [beg]
                A_Contention_Window=A_Contention_Window-1;
            else         
                if A_RTS>0 % RTS
                    A(t)=6;
                    A_RTS=A_RTS-1;
                else
                    if C(t-1)==6 || C(t-2)==6 %judge whether RTS transmissions collide
                        A_collision=A_collision+1;

                        A(t)=4;
                        A_Contention_Window=randi(Contention_Window,1)-1;
                        A_DIFS=2;
                        A_RTS=2;
                        Contention_Window=Contention_Window*2;
                        if Contention_Window>1024
                            Contention_Window=1024;
                        end
                    else
                        if A_SIFS_CTS>0% if RTS didn't collide, continue to transmit the SIFS
                            A(t)=4;
                            A_SIFS_CTS=A_SIFS_CTS-0.5;
                        else
                            if B_freeze(t)==1%now it's time for B to send CTS, but if B is freezed,invoke the exponential backoff mechanism
                                A(t)=1;
                                A_Contention_Window=randi(Contention_Window,1)-1;
                                A_DIFS=1;
                                A_RTS=2;
                                A_SIFS_CTS=0.5;
                                Contention_Window=Contention_Window*2;
                                if Contention_Window>1024
                                    Contention_Window=1024;
                                end
                            else
                                if A_CTS>0% B is not freezed, send CTS
                                    A(t)=7;
                                    for i=t+1:t+103
                                        C_freeze(i)=1;
                                    end
                                    A_CTS=A_CTS-1;
                                else
                                    if A_SIFS_DATA>0 % send the SIFS before DATA
                                        A(t)=4;
                                        A_SIFS_DATA=A_SIFS_DATA-0.5;
                                    else
                                        if A_Sending>0 % send the frame
                                            A(t)=(3);
                                            A_Sending=A_Sending-1;
                                        else
                                            if A_SIFS>0 % the SIFS before ACK
                                                A(t)=4;
                                                A_SIFS=A_SIFS-0.5;
                                            else
                                                A(t)=5;
                                                A_success=A_success+1; %transmit successfully
                                                Contention_Window=4;
                                                A_Ready_To_Send=A_Ready_To_Send+1;
                                                A_DIFS=2;
                                                A_Contention_Window=randi(Contention_Window,1)-1;
                                                A_Sending=100;
                                                A_SIFS=0.5;
                                                A_RTS=2;
                                                A_SIFS_CTS=0.5;
                                                A_CTS=2;
                                                A_SIFS_DATA=0.5;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

% ------------------------------------------------
% C
    if frameC(C_Ready_To_Send)>t
        idle_C=1; % idle
    else
        idle_C=0;
    end
 
    if idle_C==1
        C(t)=0; % still idle
    else
        if C_DIFS>0
            C(t)=1; % DIFS
            C_DIFS=C_DIFS-1;
        else
            if C_Contention_Window>0
                C(t)=2;
                C_Contention_Window=C_Contention_Window-1;
            else %before transmitting the RTS, judge whether C is freezed
                if C_freeze(t)==1
                    C(t)=1;
                    C_Contention_Window=randi(Contention_Window,1)-1;
                    C_DIFS=1;
                    Contention_Window=Contention_Window*2;
                    if Contention_Window>1024
                        Contention_Window=1024;
                    end
                else
                    if C_RTS>0
                        for i=t+1:t+106
                            B_freeze(i)=1;
                        end
                        C(t)=6;
                        C_RTS=C_RTS-1;
                    else
                        if C_SIFS_CTS>0
                            C(t)=4;
                            C_SIFS_CTS=C_SIFS_CTS-0.5;
                        else
                            if C_CTS>0;
                                C(t)=7;
                                C_CTS=C_CTS-1;
                            else
                                if C_SIFS_DATA>0
                                    C(t)=4;
                                    C_SIFS_DATA=C_SIFS_DATA-0.5;
                                else
                                    if C_Sending>0
                                        C(t)=3;
                                        C_Sending=C_Sending-1;
                                    else
                                        if C_SIFS>0
                                            C(t)=4;
                                            C_SIFS=C_SIFS-0.5;
                                        else
                                            C(t)=5;
                                            C_success=C_success+1;
                                            Contention_Window=4;
                                            C_Ready_To_Send=C_Ready_To_Send+1;
                                            C_DIFS=2;
                                            C_Contention_Window=randi(Contention_Window,1)-1;
                                            C_Sending=100;
                                            C_SIFS=0.5;
                                            C_RTS=2;
                                            C_SIFS_CTS=0.5;
                                            C_CTS=2;
                                            C_SIFS_DATA=0.5;
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
end
% -------------------------------------------------------------

%calculate Throughput & delay
A_first=find(A~=0);
A_end=find(A==5);
A_throughput=A_success*1500*8/((A_end(end)-A_first(1))*0.00002);
A_delay=(sum(A_end(1:A_success))-sum(frameA(1:A_success)))*0.00002/nPackets;

C_first=find(C~=0);
C_end=find(C==5);
C_throughput=C_success*1500*8/((C_end(end)-C_first(1))*0.00002);
C_delay=(sum(C_end(1:C_success))-sum(frameC(1:C_success)))*0.00002/nPackets;


%Print out result at bottom
Title="Figure A - VCS"
A_Throughput=A_throughput
A_Delay=A_delay
C_Throughput=C_throughput
C_Delay=C_delay

