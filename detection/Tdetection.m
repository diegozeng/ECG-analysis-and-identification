% The first T wave is unavailable since the definition of this algorithm
dsig = diff(sig);
dsig = [dsig,0];
for w=2:1:lenrvalue-1
    if rvalue(w)-rvalue(w-1)>0.7*250
        bwind(w-1) = rvalue(w)+0.12*250;
        ewind(w-1) = rvalue(w)+round(0.45*(rvalue(w)-rvalue(w-1)));
    else
        bwind(w-1) = rvalue(w)+0.2*250;
        ewind(w-1) = rvalue(w)+0.3*250;
    end
    [maxp,AX]=max(dsig( bwind(w-1):ewind(w-1)));
    [minp,IN]=min(dsig( bwind(w-1):ewind(w-1)));
    AX=AX+bwind(w-1);
    IN=IN+bwind(w-1);
    for w1 = AX:IN
        if abs(dsig(w1))<0.0011
                T(w) = w1;
        end
    end
end

if (60/Heart_rate) > 0.7 
    b1 = rvalue(1)+0.12*250;  
    e1 = rvalue(1)+round(0.45*(60/Heart_rate*250));
else
    b1 = rvalue(w)+0.2*250;    
    e1 = rvalue(w)+0.3*250;
end
    [max1,AX_1]=max(dsig(b1:e1));
    [min1,IN_1]=min(dsig(b1:e1));
    AX_1=AX_1+b1;
    IN_1=IN_1+b1;

for w2 = AX_1:IN_1
    if abs(dsig(w2))<0.0011
                T(1) = w2;
    end
end

plot(1:lensig,sig,T,sig(T),'r+');
        
    