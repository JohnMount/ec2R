
ncorePerMachine = 3
primary <- 'ip-172-31-36-131'
clusters <- c('ip-172-31-36-132')
mSet <- unique(c(primary,clusters))
spec <- lapply(mSet,function(ip) {
   rep(list(list(host=ip,user='ubuntu')),ncorePerMachine)
})
spec <- unlist(spec,recursive=FALSE)
cl <- parallel::makeCluster(type='PSOCK',
                            master=primary,
                            spec=spec
                            )


jobs <- 1:100
worker <- function(job) {
   res <- 0
   for(i in 1:100000) {
      res <- res + sqrt(job)    
   }
   data.frame(job=job,res=res)
}

dat <- parallel::parLapplyLB(cl,jobs,worker)

if(!is.null(cl)) {
  parallel::stopCluster(cl)
  cl <- NULL
}

res <- data.frame(data.table::rbindlist(dat))

print(res)


