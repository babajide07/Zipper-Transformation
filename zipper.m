function out = zipper(v)

v_fft = fft(v);
m = length(v_fft);

if rem((m-1),2)==0
    out1 = zeros((m-1)/2+1,1);
    out2 = zeros((m-1)/2,1);
    out1(1) = v_fft(1);
    for i= 2:(m-1)/2+1;
           j = i-1;
           out1(i) = real(v_fft(i));
           out2(j) = imag(v_fft(i));
        
    end
    out = [out1;out2];
elseif rem((m-1),2)~=0
    %out = zeros(m/2+1,1);
    out1 = zeros((m)/2+1,1);
    out2 = zeros((m)/2-1,1);
    out1(1) = v_fft(1);
    for i= 2:m/2+1;
        if i ~= m/2+1
          j = i-1;
        else
          j = [];
        end
           out1(i) = real(v_fft(i));
           out2(j) = imag(v_fft(i));
    end
    out = [out1;out2];
end