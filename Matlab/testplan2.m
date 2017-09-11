input_resolution = 12;
output_resolution = 12;
iteration_number = 8;

for it = 1:iteration_number
   x = rand * (1 << input_resolution)
end
