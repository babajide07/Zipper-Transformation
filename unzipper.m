function out1 = unzipper(v)

m = length(v);
if rem((m-1),2)==0
    
    out = zeros(m,1);
    out(1) = v(1);
    k=0;
    for i= 2:(m-1)/2 + 1; 
           j = (m-1)/2+2+k;
           k = k+1;
          % if j ~= m
              out(i) = complex(v(i),v(j));       
    end
    k = 1;
    for j =(m-1)/2 + 2:m
        t = j-k;
       out(j) = conj(out(t));
       k = k + 2;
    end
    
elseif rem((m-1),2)~=0
    out = zeros(m,1);
    out(1) = v(1);
    out((m)/2 + 1) = v((m)/2 + 1);
    k=0;
    for i= 2:(m)/2 
           j = m/2+2+k;
           k = k+1;
          % if j ~= m
              out(i) = complex(v(i),v(j));       
    end
    k = 2;
    for j =m/2 + 2:m
        t = j-k;
       out(j) = conj(out(t));
       k = k + 2;
    end
  out1 = ifft(out);      
end