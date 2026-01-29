clear;clc;

a = [1, 2, 3, 4, 5, 6, 7, 8]; 
n = length(a);
d = 1;

while d < n
    temp_a = a; 
    parfor i = 1 : n
        if mod(i-1, 2*d) == 0 && (i + d) <= n
            a(i) = temp_a(i) + temp_a(i + d);
        end
    end
    d = d * 2;
end

total = a(1);
disp(['Total Sum: ', num2str(total)]);