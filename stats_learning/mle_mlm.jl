using Distributions
using DataFrames
using Random
using Optim
using CairoMakie
using MixedModels

#see example mixedmodels here: https://juliastats.org/MixedModels.jl/stable/constructors/#Examples-of-linear-mixed-effects-model-fits

#see mlm with max likelihood here: https://towardsdatascience.com/linear-mixed-model-from-scratch-f29b2e45f0a4?gi=3fdc5408293b

#and here: https://towardsdatascience.com/maximum-likelihood-ml-vs-reml-78cf79bef2cf

#and here: https://www.r-bloggers.com/2021/01/random-effects-model-from-scratch/

#and here: http://www.jld-stats.com/2020/04/24/point-estimation-in-mixed-models-from-scratch-2/

#and here: http://www.jld-stats.com/2020/04/07/point-estimation-in-mixed-models-from-scratch-1/

#and here: chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://si.biostat.washington.edu/sites/default/files/modules/Seattle-SISG-18-MM-Lecture03.pdf

#note to self -- i probably need to do a bit more reading on linear algebra before playing around with this