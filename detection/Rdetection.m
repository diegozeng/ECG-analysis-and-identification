rate=360; % set sampling rate, usually is the integer integer multiple of power-line frequency, since the test data is from MIT, so 360/60=6, satisfied.
sig=M_1; %Load channel 1 data sequence from the ".dat" file  
lensig=length(sig);
wtsig1=cwt(sig,6,'mexh'); %Utilize mexico hat wavelet to decompose the signal
lenwtsig1=length(wtsig1);
wtsig1(1:20)=0; 
wtsig1(lenwtsig1-20:lenwtsig1)=0;
y=wtsig1;
yabs=abs(y);        %select absolute value(for slope threshold)

%find the zeros of first-order derivative of the wavelet coeffients
sigtemp=y;
siglen=length(y);
sigmax=[];
for i=1:siglen-2
    if (y(i+1)>y(i)&y(i+1)>y(i+2))|(y(i+1)<y(i)&y(i+1)<y(i+2))
        sigmax=[sigmax;abs(sigtemp(i+1)),i+1];
    end;
end;
%plot original signal and 
figure(1);
subplot(2,1,1),plot(sig);
subplot(2,1,2),plot(wtsig1);


%R-peak amplitude threshold control (50% of the differential value of the sequence)
thrtemp=sort(sigmax);
thrlen=length(sigmax);
thr=0;
for i=(thrlen-7):thrlen
    thr=thr+thrtemp(i);
end;
thrmax=thr/8;         

%Upper threshold: determined by Top 8 maximum value
zerotemp=sort(y);
zerovalue=0;
for i=1:100
    zerovalue=zerovalue+zerotemp(i);
end;
zerovalue=zerovalue/100;    %?????????????100?????????
thr=(thrmax-zerovalue)*0.25; %< constant threshold                     
%Upper threshold: determined by Lowest 100 of minimum value

%R value refresh
rvalue=[];
for i=1:thrlen
    if sigmax(i,1)>thr
        rvalue=[rvalue;sigmax(i,2)];
    end;
end;
rvalue_1=rvalue;
leng2 = length(rvalue); 

%Negative value filter
for j=1:1:leng2
    if y(rvalue(j))<0
       rvalue(j)=0;
    end
end
rvalue=sort(rvalue);
leng=size(rvalue,1);
Len=length(find(rvalue==0));
rvalue=rvalue([Len+1:leng]);
leng1=length(rvalue);
rvalue_2=rvalue; 

%R-peak frequency threshold control
lenvalue=length(rvalue);
i=2;
while i<=lenvalue
      if (rvalue(i)-rvalue(i-1))/rate<0.3  %worth to debate(can test up to 200/min heart rate)
          if yabs(rvalue(i))>yabs(rvalue(i-1))
              rvalue(i-1)=[];
          else
              rvalue(i)=[];
          end;

          lenvalue=length(rvalue);
          i=i-1;
      end;
      i=i+1;
end;        
lenvalue=length(rvalue);

%Redirection of the time point when R-peak appears.(Make the resluts more accurate)
for i=1:lenvalue
    if (wtsig1(rvalue(i))>0)
        k=(rvalue(i)-5):(rvalue(i)+5);
        [a,b]=max(sig(k));
        rvalue(i)=rvalue(i)-6+b; 
    else
        k=(rvalue(i)-5):(rvalue(i)+5);
        [a,b]=min(sig(k));
        rvalue(i)=rvalue(i)-6+b; 
    end;
end;

%Output the approximate heart rate (per minute). 
Heart_rate = 60*(rate*(lenvalue-1))/(max(rvalue)-min(rvalue))

%plot result in the sub 2 figure, sub 1 figure is used to test.
figure(2);
subplot(2,1,1),plot(1:lensig,wtsig1,rvalue_2,wtsig1(rvalue_2),'r+');
subplot(2,1,2),plot(1:lensig,sig,rvalue,sig(rvalue),'r+');
