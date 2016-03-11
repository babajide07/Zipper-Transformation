function y = zipper1(x)

[M N] = size(x);

y2 = [];
for i = 1:N
   y1=zipper(x(:,i));
   y2 = [y2,y1];
end

y = y2;