# we can use the ternary operator for a terser expression of if-else
# a ? b : c
# e.g. (x > y) ? x : y

x = 1
y = 2

z = (x < y) ? x : y
z

# the above is equivalent to
if x > y
    x
else 
    y
end