
library("doParallel", lib.loc="/home/mlacey1/R/x86_64-pc-linux-gnu-library/3.4")
library("rstan", lib.loc="/home/mlacey1/R/x86_64-pc-linux-gnu-library/3.4")
library("parallel")

registerDoParallel(cores=(Sys.getenv("SLURM_NTASKS_PER_NODE")))

load("yemen_2014_bygov.RData")

foreach(i = 1:19, .packages=c("rstan")) %dopar% {
load("yemen_2014_bygov.RData")

dset=get(names.dsets[i])
fitname=names.fits[i]

fgmod.nocov=stan_model(model_code=allfg.nocov,model_name='fg_nocov',verbose=FALSE)
fit.stan <- sampling(fgmod.nocov, data = dset, pars=c("p","theta","sigma","Omega","L_Omega","y_sim","log_lik","lp__"), chains = 4, iter = 4000, warmup=1000)

save(fit.stan, file=names.fits[i])
}



