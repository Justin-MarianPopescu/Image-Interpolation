function R = proximal_rotate(I, rotation_angle)
   [m n nr_colors] = size(I);

    % TODO: cast I to double
    I = cast(I, "double");

   % if the image is black and white, ignore it
   if nr_colors > 1
       R = -1;
      return
   end

   % Note: In Octave, image pixels are indexed from 1 to n by default.
   % When scaling is applied, the point (0, 0) of the image will not travel.
   % If you work in indices from 1 to n and multiply x and y by s_x and s_y,
   % then the origin of the image will move from (1, 1) to (sx, sy)!
   % Therefore, you must work with indices in the range from 0 to n - 1!

   % TODO: calculate cos and sine of rotation_angle
   COS = cos(rotation_angle);
   SIN = sin(rotation_angle);

   % TODO: initializeaza matricea finala
   R = zeros(m, n);

   % TODO: initialize the rotation matrix
   T_rot = [ COS -SIN;
             SIN  COS ];

   % TODO: Calculate the inverse of the rotation matrix
   T_rot = inv(T_rot);

   % goes through every pixel in the image
   % uses coordinates from 0 to n - 1
   for y = 0 : m - 1
       for x = 0 : n - 1
          % TODO: apply the inverse transformation on (x, y) and calculate
          % x_p and y_p from the initial image space

          % x_0 = x_i * s_x
          % y_0 = y_i * s_y

          % the system obtained above is solved as follows:
          % initial pixel coord vector V = (x_0, y_0) that will follow
          % to be modified a.i the pixel matrix
          % to reach the size p X q
          % V = T * (x_i, y_i)
          V = T_rot * [x y]';
          V = V';

          % TODO: switch (xp, yp) from the coordinate system from 0 to n - 1
          % in the coordinate system from 1 to n to apply the interpolation
          xp = V(1); yp = V(2);
          xp = xp + 1; yp = yp + 1;

          % TODO: if xp or yp is outside the image
          % put a pixel black in the image and move on
          if (xp < 1) || (yp < 1)
            R(y + 1, x + 1) = 0;
            continue;
          end
          if (xp > n) || (yp > m)
            R(y + 1, x + 1) = 0;
            continue;
          end

          % TODO: find the points surrounding the point (xp, yp)
          % IF x1, y1 are on the last line-column
          % WE NEED TO BE SURE THAT x2, y2 will not leave the pixel matrix

          % I : verify the width
          y1 = floor(yp);
          y2 = floor(yp) + 1;
          if y1 == m %% y - last row
            y1--; y2--;
          end
          % II : verify the height
          x1 = floor(xp);
          x2 = floor(xp) + 1;
          if x1 == n %% x - last column
              x1--; x2--;
          end

          % TODO: calculate the interpolation coefficients := a
          a = proximal_coef(I, x1, y1, x2, y2);

          % TODO: calculate the interpolated value of the pixel (x, y)
          % Note: for writing in the image, x and y are in coordinates of
          % to 0 to n - 1 and must be brought in coordinates from 1 to n
          R(y + 1, x + 1) = a(1) +...
                            a(2) * xp +...
                            a(3) * yp +...
                            a(4) * xp * yp;
       end
   end

   % transform the resulting array into uint8 to be a valid image
   R = cast(R, "uint8");
end
