#see https://ryxcommar.com/2023/06/26/should-you-ask-data-science-job-candidates-this-tricky-math-question/
# for prompt
Σ = [[1, 0] [0, 0.01]]

# see https://math.stackexchange.com/questions/732679/how-to-rotate-a-matrix-by-45-degrees
# for the rotation matrix
R = [[1, 1] [-1, 1]]

S = R * Σ * R'

β = S[2] / S[1]