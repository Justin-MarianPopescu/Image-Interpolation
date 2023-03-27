function R = bicubic_resize(I, p, q)
    % ========================================================== %
    % Image upscaling using the bicubic interpolation algorithm  %
    %     Transform image I from size m x n to size p x q        %
    % ========================================================== %

    [m n nr_colors] = size(I);

    % Initializes the final array
    R = zeros(p, q);

    % TODO: cast I la double
    I = cast(I, "double");

    % If the image is black and white, ignore it
    if nr_colors > 1
       R = -1;
       return
    end

    % If you work in indices from 1 to n and multiply x and y by s_x
    % and s_y, then the origin of the image will move from (1, 1) to (sx, sy)!
    % Therefore, you must work with indices in the range from 0 to n - 1!

    % TODO: calculate the scaling factors
    % Note: if working with indices in the interval [0, n - 1], the last one
    % pixel of the image will move from (m - 1, n - 1) to (p, q).
    % s_x will not be q ./ n

    % resize image of size m X n in q X p
    % p > m & q > n , we perform the transformation of the COORD system
    % by using the scaling constants s_x = q/n && s_y = p/m
    % subtract -1 from each dimension to have an index from 0
    % indexarea initial era de la 1
    s_x = (q - 1) / (n - 1);
    s_y = (p - 1) / (m - 1);

    % TODO: define the transformation matrix for resizing
    T = [s_x 0;
         0 s_y];

    % TODO: calculate the inverse of the transformation
    T = inv(T);

    % TODO: precalculate the derivatives
    [Ix Iy Ixy] = precalc_d(I);

    % goes through every pixel in the image, uses coordinates from 0 to n - 1
    for y = 0 : p - 1
       for x = 0 : q - 1
          % TODO: apply the inverse transformation on (x, y) and calculate
          % x_p and y_p from the initial image space

          % x_0 = x_i * s_x
          % y_0 = y_i * s_y

          % the system obtained above is solved as follows:
          % initial pixel coord vector V = (x_0, y_0) that will follow
          % to be modified in such a way the pixel matrix to reach the size pXq
          V = T * [x, y]';
          V = V';

          % TODO: switch (xp, yp) from the coordinate system from 0 to n - 1 in
          % the coordinate system from 1 to n to apply the interpolation

          % take x_0 & y_0 which will be used for
          xp = V(1);  yp = V(2);
          xp = xp + 1;  yp = yp + 1;

          % TODO: find the 4 points surrounding the point x, y

          % IF x1, y1 are on the last line-column
          % WE NEED TO BE SURE THAT x2, y2 will not leave the pixel matrix

          y1 = floor(yp);
          y2 = floor(yp) + 1;
          if y1 == m %% y - last row
            y1--;
            y2--;
          end
          x1 = floor(xp);
          x2 = floor(xp) + 1;
          if x1 == n %% x - last column
            x1--;
            x2--;
          end

          % TODO: calculate the interpolation coefficients A
          % coordonates x1, x2, y1, y2 helps us build the square
          % size [0,1] x [0,1] points x1, y1, x2, y2
          % surround the point (xp, yp) the 4 points form a square
          A = bicubic_coef(I, Ix, Iy, Ixy, x1, y1, x2, y2);

          % TODO: pass the coordinates (xp, yp) to the unit square,
          % subtracting (x1, y1)
          xp = xp - x1; yp = yp - y1;

          % TODO: calculate the interpolated value of the pixel (x, y)
          % Note: for writing in the image, x and y are in coordinates of
          % to 0 to n - 1 and must be brought in coordinates from 1 to n

          % can be rewritten differently, in the form of a product
          % line vector for x * 4x4 dim coef matrix * column vector for y:
          % +1 the indexing of the pixels in the image is from 1 to n
          R(y + 1, x + 1) = [1 xp xp^2 xp^3] * A * [1 yp yp^2 yp^3]';
       end
   end

   % TODO: convert the resulting array to uint8 to be a valid image
   R = cast(R, "uint8");
end
