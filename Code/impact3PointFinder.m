function [PB] = impact3PointFinder(px,py,ox,oy,r)

syms a b c d x y h
eqn1 = (a-x)^2 + (b-y)^2 + (c-x)^2 + (d-y)^2 == h^2;
xSol = isolate(eqn1,x);
eqn2 = ((b-y)/(a-x))*((d-y)/(c-x)) == -1;
ySol = isolate(eqn2,y);
snew = subs(xSol, y, ySol);
eqn3 = (a/2 + c/2 + (2*a*c + 4*b*(b/2 + d/2 + (4*a*x - 2*b*d - 4*a*c + 4*c*x...
+ b^2 + d^2 - 4*x^2)^(1/2)/2) + 4*d*(b/2 + d/2 + (4*a*x - 2*b*d - 4*a*c +... 
4*c*x + b^2 + d^2 - 4*x^2)^(1/2)/2) - a^2 - 2*b^2 - c^2 - 2*d^2 + 2*h^2 -...
4*(b/2 + d/2 + (4*a*x - 2*b*d - 4*a*c + 4*c*x + b^2 + d^2 - 4*x^2)^(1/2)/2)^2)^(1/2)/2)-x == 0;
snew2 = subs(eqn3,[a b c d h],[px py ox oy r]);
pSolx = solve(snew2,x);
Px0 = double(pSolx);
pSoly = subs(ySol-y,[a b c d h x],[px py ox oy r Px0]);
Py0 = isolate(pSoly,y);
Py0 = double(solve(Py0,y));
PB = [Px0 Py0];

end

%impact3PointFinder(1.4e-7,0.5e-7,1.5e-7,0.5e-7,0.1e-7)
%impact3PointFinder(3, 8, 10, 2, sqrt(85))

