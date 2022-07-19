using ForwardDiff

# unicode can be used for function names
Σ(x, y) = x + y

Σ(2, 3)

#let's redefine
function Σ(z)
    s = 0
    for i in 1:length(z)
        s += z[i]
    end
    return s
end

aa = 1:5
Σ(aa)
#this works but I doubt it's the best way to do it

#suppose we have the following function:
# f_1(x) = 3x^2 + 5x + 2
# if we want to do this for an entire array, X, we would write it as follows:

X = 1:10

f₁(x) = 3 .* x .^ 2 .+ 5 .* x .+ 2

Y = f₁(X)

#the . notation above broadcasts the operations to be vectorized

# autodiff
ForwardDiff.derivative(f₁, 5)

#and let's say we want a function that had multiple inputs
f₂(x, y, z) = 5sin(x * y) + 2 * y / 4z
f₂(v) = f₂(v[1], v[2], v[3])

#let's first evaluate this
f₂(1, 2, 3)

#and then let's take the gradient
ForwardDiff.gradient(f₂, [1, 2, 3])

#and we can check the above by adding some small changes to each variable
ϵ = 0.01

∂f₂∂x = (f₂(1 + ϵ, 2, 3) - f₂(1, 2, 3)) / ϵ
∂f₂∂y = (f₂(1, 2 + ϵ, 3) - f₂(1, 2, 3)) / ϵ
∂f₂∂z = (f₂(1, 2, 3 + ϵ) - f₂(1, 2, 3)) / ϵ

∇f = [∂f₂∂x, ∂f₂∂y, ∂f₂∂z]

#resume at section 4.4 of https://computationalthinking.mit.edu/Spring21/transformations_and_autodiff/
#and watch the autodiff video

# Anonymous/Lambda Functions
# we can write anonymous functions in Julia as follows:
f3 = x -> x^2

f3(2)

# Duck Typing
f(x) = x^2

#f will work on a matrix bc squaring a matrix is well-defined in math
A = rand(3, 3)
f(A)

#but it won't work on a vector
v = rand(3)
f(v)

# Mutating Functions
# by convention, functions followed by ! alter their contents and functions lacking ! do no
v = [3, 5, 2]

sort(v)

v

#but then this will sort v in place
sort!(v)

v

# Broadcasting
# by placing a . between any function name and its argument list, we tell that function to be
# broadcast over the elements of the input objects

#let's define a new matrix
A = [i + 3*j for j in 0:2, i in 1:3]

#recall that f(A) = A^2 = A*A
f(A)

#but f.(A) will square each element
f.(A)

#this means that for a vector, v, f.(v) is defined even though f(v) is not
v = [1, 2, 3]
f.(v)

# misc
x = 1.0001
y = 1.0

x == y 
y ≈ y
# ≈ (i.e. \approx ) is defined as a mathematical operator, which is pretty dope

