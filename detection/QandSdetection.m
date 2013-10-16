% Q detection
wtsig2 = cwt(sig,8,'mexh'); % order-8 Mexico Hat wavelet 
lenrvalue = length(rvalue);
qvalue = [];
for i = 1:lenrvalue
    for j = rvalue(i):-1:(rvalue(i) - 30) %find Q, so search left area
        if wtsig1(rvalue(i)) > 0 
            if wtsig2(j) < wtsig2(j - 1) & wtsig2(j) < wtsig2(j + 1)
                tempqvalue = j - 10;                 
            break;                        
            end;

        else
             if wtsig2(j) > wtsig2(j - 1) & wtsig2(j) > wtsig2(j + 1)
                tempqvalue = j - 10;                
            break;                      
            end;
        end;
    end;
    % Slope method to find Q 
    x1 = tempqvalue; 
    y1 = sig(tempqvalue);
    x2 = rvalue(i);
    y2 = sig(rvalue(i));
    a0 = (y2 - y1)/(x2 - x1);
    b0 = -1;
    c0 = - a0*x1 + y1;                        
    dist = [];
    for k = tempqvalue:rvalue(i)
        tempdist = (abs(a0*k + b0*sig(k) + c0))/sqrt(a0^2 + b0^2);
        dist = [dist;tempdist];
    end;                                  
    [a,b] = max(dist);                     
    tempqvalue = tempqvalue + b - 1;
    l = (tempqvalue - 5):rvalue(i);
    [c,d] = min(sig(l));
    tempqvalue = tempqvalue - 6 + d;            
    qvalue = [qvalue;tempqvalue];       
end;

% S detection 
svalue = [];
for i = 1:lenrvalue - 1
    for j = rvalue(i):1:(rvalue(i) + 100) %find Q, so search left area
        if wtsig1(rvalue(i)) > 0
           if (wtsig2(j) < wtsig2(j - 1))&(wtsig2(j) < wtsig2(j + 1))
               tempsvalue = j + 10;      
               break;
           end;

        else
            if (wtsig2(j) > wtsig2(j - 1))&(wtsig2(j) > wtsig2(j + 1))
               tempsvalue = j + 10;     
               break;
           end;
    end;
end;
    % Slope method to find Q 
    x1 = tempsvalue;
    y1 = sig(tempsvalue);
    x2 = rvalue(i);
    y2 = sig(rvalue(i));
    a0 = (y2 - y1) / (x2 - x1);
    b0 = -1;
    c0 = -a0 * x1 + y1;                        
    dist = [];
    for k = rvalue(i):tempsvalue
        tempdist = (abs(a0 * k + b0 * sig(k) + c0))/sqrt(a0^2 + b0^2);
        dist = [dist;tempdist];
    end;                                  
    [a,b] = max(dist);                  
    tempsvalue = rvalue(i) + b - 1;
    l = rvalue(i):(tempsvalue + 10);
    [c,d] = min(sig(l));
    tempsvalue = rvalue(i) + d - 1;       
    svalue = [svalue;tempsvalue];       
end;

%Plot Q & S
qrvalue = [qvalue];
qrvalue = sort(qrvalue);
qrsvalue = [svalue;];
qrsvalue = sort(qrsvalue);
figure(3);
subplot(2,1,1),plot(1:lensig,sig,qrvalue,sig(qrvalue),'r+');
subplot(2,1,2),plot(1:lensig,sig,qrsvalue,sig(qrsvalue),'r.');
