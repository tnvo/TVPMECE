% Thao Vo
% Hidden Terminal = CSMA:CA

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

lambdaA=50; % intialize
lambdaC=lambdaA; %A & C are the same
Contention_Window=4; %Contention Window
nPackets=50;

%node A/C slot
A=zeros(1,50000); 
C=zeros(1,50000);
UA=rand(1,nPackets);
XA=-log(1-UA)./lambdaA;
%Poisson dist slots
frame_A=round(XA./0.00002);

UC=rand(1,nPackets);
XC=-log(1-UC)./lambdaC;
frame_C=round(XC./0.00002);

% time of frame generation
for i=2:nPackets
    frame_A(i)=frame_A(i)+frame_A(i-1); frame_C(i)=frame_C(i)+frame_C(i-1);
end
frame_A=[frame_A,80000]; frame_C=[frame_C,80000];

% ------------------------------------------------
% A 
% Packets that will be transmitted
A_Ready_To_Send=1;
A_DIFS=2; % DIFS = 40 microsec = 2 slots
A_Contention_Window=randi(Contention_Window,1)-1;
A_Sending=100;
% SIFS = 10 microsec = 0.5 slots
A_SIFS=0.5;
A_ACK_Allow=0;
A_collision=0;
A_success=0;
% ------------------------------------------------
% C
C_Ready_To_Send=1;
C_DIFS=2;
C_Contention_Window=randi(Contention_Window,1)-1;
C_sending=100;
C_SIFS=0.5;
C_ACK_allow=0;
C_collision=0;
C_success=0;
% ------------------------------------------------

% Begins logic
for t=1:50000 % 1 sec =  50,000 slots (1 / (2 * 10^-5) = 50,000 slots
  %------------FRAME A-------------------------------------------
    if frame_A(A_Ready_To_Send)>t
        idle_A=1;%means the frame is idle
    else
        idle_A=0;
    end
 % Note: network status are all represented by number
    if idle_A==1
        A(t)=0; % idle, first stage
    else
        if A_DIFS>0
            A(t)=1; % DIFS - next stage
            A_DIFS=A_DIFS-1;
        else
            if A_Contention_Window>0
                A(t)=2; % CW
                A_Contention_Window=A_Contention_Window-1;
            else 
                if A_Sending>0
                    A(t)=3; % sending data
                    A_Sending=A_Sending-1;
                else
                    if A_SIFS>0
                        A(t)=4; %SIF
                        A_SIFS=A_SIFS-0.5;
                    else
                        for i=t-100:t %see if there's a collision or not
                            if C(i)<3 %if not collision, then proceed
                                A_ACK_Allow=A_ACK_Allow+2;
                            end
                        end
                        if A_ACK_Allow>100 
                            A_success=A_success+1; %data sent
                            A(t)=5; %ACK
                            Contention_Window=4;
                            A_Ready_To_Send=A_Ready_To_Send+1;
                            A_DIFS=2;
                            A_Contention_Window=randi(Contention_Window,1)-1;
                            A_Sending=100;
                            A_SIFS=0.5;
                            A_ACK_Allow=0;
                        else 
                            %If a collision occurs, the stations that collided double their contention 
                            % window CW and repeat the backoff  process.  After 
                            % k collisions, the backoff  value is selected from [0;2kCW01]:
                            % The CW value cannot exceed threshold CWmax
                            A_collision=A_collision+1; %collision occur detected at end of contention slot
                            Contention_Window=Contention_Window*2; 
                            if Contention_Window>1024 %CWMax - end of contention window
                                Contention_Window=1024;
                            end
                            A_DIFS=2;
                            A_Contention_Window=randi(Contention_Window,1)-1;
                            A_Sending=100;
                            A_SIFS=0.5;
                            A_ACK_Allow=0;
                            
                        end
                    end
                end
            end
        end
    end
    
    %--------FRAME C-----------------------------------------------
    if frame_C(C_Ready_To_Send)>t
        idle_C=1;
    else
        idle_C=0;
    end
 
    if idle_C==1
        C(t)=0;
    else
        if C_DIFS>0
            C(t)=1;
            C_DIFS=C_DIFS-1;
        else
            if C_Contention_Window>0
                C(t)=2;
                C_Contention_Window=C_Contention_Window-1;
            else 
                if C_sending>0
                    C(t)=3;
                    C_sending=C_sending-1;
                else
                    if C_SIFS>0
                        C(t)=4;
                        C_SIFS=C_SIFS-0.5;
                    else
                            C_success=C_success+1; % C& D doesnt have collision
                            C(t)=5;
                            Contention_Window=4;
                            C_Ready_To_Send=C_Ready_To_Send+1;
                            C_DIFS=2;
                            C_Contention_Window=randi(Contention_Window,1)-1;
                            C_sending=100;
                            C_SIFS=0.5;
                            C_ACK_allow=0;
                        
                    end
                end
            end
        end
    end
end

%calculate Throughput & delay
A_first=find(A~=0);
A_end=find(A==5);
A_throughput=A_success*1500*8/((A_end(end)-A_first(1))*0.00002);
A_delay=(sum(A_end(1:A_success))-sum(frame_A(1:A_success)))*0.00002/nPackets;

C_first=find(C~=0);
C_end=find(C==5);
C_throughput=C_success*1500*8/((C_end(end)-C_first(1))*0.00002);
C_delay=(sum(C_end(1:C_success))-sum(frame_C(1:C_success)))*0.00002/nPackets;


%Print out result at bottom
Title="Figure B - CSMA:CA"
A_Throughput=A_throughput
A_Delay=A_delay
C_Throughput=C_throughput
C_Delay=C_delay

