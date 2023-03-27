function a = proximal_coef(f, x1, y1, x2, y2)
   % =========================================================================
   % Calculeaza coeficientii a pentru Interpolarea Proximala intre punctele
   % (x1, y1), (x1, y2), (x2, y1) si (x2, y2).
   % =========================================================================

   % TODO: Calculate the matrix A.

   % f(x, y) = a0 + a1*x + a2*y + a3*x*y
   % the form of f(x,y) can reduces to a linear system of equations
   A = [1 x1 y1 x1 * y1;
        1 x1 y2 x1 * y2;
        1 x2 y1 x2 * y1;
        1 x2 y2 x2 * y2];

   % TODO: calculate the coefficients
   b = double([f(y1, x1), f(y2, x1), f(y1, x2), f(y2, x2)]');

   % TODO: calculate the coefficients
   a = A \ b;
end
