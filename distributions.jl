#playing around some with using distributions
using Distributions, Random

Random.seed!(0408)
d_n = Distributions.Normal()

#we can find out what field names are appropriate for a given distribution
fieldnames(Normal)

#and we can see that it's normal
mean(d_n)
std(d_n)

#sampling from the distribution
s = rand(d_n, 1000)

#and let's define a couple more distributions
a = Distributions.Bernoulli()
b = Distributions.LogNormal()
c = Distributions.Normal(1)
d = Distributions.Normal(1, 2)


tmp = s[1]

#and looking at some loglikelihoods
ll1 = -loglikelihood(d_n, s)
ll4 = -loglikelihood(c, s)
ll5 = -loglikelihood(d, s)
ll2 = -loglikelihood(a, s)
ll3 = -loglikelihood(b, s)

#and in theory this should give me the same thing
v = logpdf.(d_n, s)
-sum(v) ≈ ll1
#great!

#creating a new sample from the lognormal distribution
s2 = rand(b, 1000)

#then logging that sample
s2_log = log.(s2)

#and looking at loglikelihood stuff for some combos
ll6 = -loglikelihood(b, s2)
ll6b = -loglikelihood(b, s2_log)
ll6c = -loglikelihood(d_n, s2_log)

