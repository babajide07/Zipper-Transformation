function e=entropy(x)
s=size(x);
x1 =reshape(x,s(1)*s(2),1);
p=hist(double(x1),256);
p = p / sum(p);
e = 0;
for i = 1 : 256
    if p(i) > 0
        e = e - p(i)*log(p(i))/log(2);
    end;
end;