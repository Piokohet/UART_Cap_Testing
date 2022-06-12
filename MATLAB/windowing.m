N = 2048;
w = window(@blackmanharris,N);
w1 = window(@hamming,N); 
w2 = window(@gausswin,N,2.5); 
wvtool(w,w1,w2)
plot(N,w);