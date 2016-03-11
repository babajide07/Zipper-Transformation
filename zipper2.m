function y = zipper2( x )
y1=zipper1(x);
y2=zipper1(y1');
y = y2';
end