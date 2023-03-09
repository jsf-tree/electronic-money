function [w] = fscpesosmediamovelgamajsf(f, e, p)
x=0:1:50; w=gampdf(x,f,e); w=w/sum(w); w=fliplr(w); w=w(w>p); w=w/sum(w);
end