function [ output_args ] = sixtwo( num )
%SIXTWO1 Summary of this function goes here
%   Detailed explanation goes here
output_args=0;
s=length(num);
for i=1:1:s
    output_args=output_args+sixtwocompare(num(i))*(62^(s-i));
end

end

