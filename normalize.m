function y=normalize(x)
mx=max(max(x));
mn=min(min(x));
y = (x-mn)/(mx-mn);