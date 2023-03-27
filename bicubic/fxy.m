function r = fxy(f, x, y)
   % ============================================================== %
   % Approximates the x and y derivative of f at the point (x, y)   %
   % ============================================================== %

   % f - the pixel matrix written in the form of a function f
   [m n] = size(f);

   % TODO: calculate the derivative

   % In these 4 points (0,0), (0,1), (1,0) and (1,1)
   % the derivatives are known to be 0.

   % FOR derivative of the 2nd order in x & y must satisfy the conditions
   % of derivatives of order 1 in x and in y

   % the maximum length of the image was exceeded x > m - 1
   % minimum image length exceeded x < 2
   % in this case I cannot calculate the partial derivative in x
   % ----------------------------------------------------------------
   % the maximum length of the image was exceeded y > n - 1
   % minimum image length exceeded y < 2
   % in this case I cannot calculate the partial derivative in y
   if  x > m - 1 || x < 2  || y > n - 1 || y < 2
      r = 0;
      return;
   else
      r = (f(x - 1, y - 1) + f(x + 1, y + 1)-...
           f(x + 1, y - 1) - f(x - 1, y + 1)) / 4;
   end
end
