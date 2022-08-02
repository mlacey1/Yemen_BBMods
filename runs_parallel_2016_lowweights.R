
library("doParallel", lib.loc="/home/mlacey1/R/x86_64-pc-linux-gnu-library/3.4")
library("rstan", lib.loc="/home/mlacey1/R/x86_64-pc-linux-gnu-library/3.4")
library("parallel")

registerDoParallel(cores=(Sys.getenv("SLURM_NTASKS_PER_NODE")))

load("yemen_2016_lw_dsets.RData")

foreach(i = 1:19, .packages=c("rstan")) %dopar% {
load("yemen_2016_lw_dsets.RData")

dset=get(names.dsets.2016[i])
dset$a=50
dset$alpha=5
fitname=names.fits.2016[i]

fgmod.update=stan_model(model_code=allfg.nocov.update,model_name='fg_update',verbose=FALSE)
fit.stan <- sampling(fgmod.update, data = dset, pars=c("p","theta","sigma","Omega","L_Omega","y_sim"), chains = 4, iter = 4000, warmup=1000)

save(fit.stan, file=names.fits.2016[i])
}



