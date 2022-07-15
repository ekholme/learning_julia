using CUDA

CUDA.versioninfo()

[CUDA.capability(dev) for dev in CUDA.devices()]
#ok so my machine should be gtg for running stuff on my gpu
