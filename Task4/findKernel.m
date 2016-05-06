 function w = findKernel(x,y)
x = double(x);
y = double(y);
initial_theta = exppdf(1:100,1);
options = optimset('GradObj', 'on', 'MaxIter', 100);
[w, cost] = ...
	fminunc(@(t)(costTraces(t, x, y)), initial_theta, options);


