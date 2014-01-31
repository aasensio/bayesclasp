import numpy as np
import matplotlib.pyplot as pl
import pymc as mc

# Generate artificial data
nObservers = 15
nPoints = 10
noise = 0.4
correctA = np.random.normal(loc=0.0,scale=0.5,size=nObservers)
x = np.random.uniform(low=0.0,high=10.0,size=(nPoints,nObservers))
observations = np.zeros((nPoints,nObservers))

for i in range(nObservers):	
	observations[:,i] = correctA[i] * x[:,i] + noise * np.random.randn(nPoints)


# Hyperpriors
muA = mc.Uniform('muA', lower=-40.0, upper=40.0)
sigmaA = mc.Uniform('sigmaA', lower=0, upper=40.0)

@mc.deterministic(plot=False)
def precision(sigmaA=sigmaA):
	return 1.0 / sigmaA**2

## Priors
A = mc.Normal('A', mu=np.ones(nObservers)*muA, tau=np.ones(nObservers)*precision)
 
@mc.deterministic(plot=False)
def observer_i(A=A):
	arrA = A[np.newaxis,:]
	return arrA * x

### Likelihood
		
obs = mc.Normal('data', mu=observer_i, tau=1.0/noise**2, value=observations, observed=True)	

model = mc.Model([muA, sigmaA, A, obs]) 
mcmc = mc.MCMC(model)
mcmc.sample(iter=20000,burn=10000, thin=2)

var = ['muA','sigmaA']
fig = pl.figure(num=1, figsize=(12,8))
loop = 1
for i in range(2):
	res = mcmc.trace(var[i]).gettrace()
	ax = fig.add_subplot(2,2,loop)
	ax.plot(res)
	loop += 1
	ax = fig.add_subplot(2,2,loop)
	ax.hist(res)
	loop += 1