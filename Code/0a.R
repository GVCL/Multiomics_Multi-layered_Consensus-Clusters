# Setting higher memory limit
memory.limit(size = 1000000)

# Setting Parallel Worker
num_cores <- detectCores() - 1
cl <- makeCluster(num_cores)
registerDoParallel(cl)

# Reading the input files
Y <- as.matrix(as.data.table(read_csv(file = "final_mRNA_normalized.csv")), rownames = TRUE)
X <- as.matrix(as.data.table(read_csv(file = "final_methy_data.csv")), rownames = TRUE)

pred <- as.matrix(X)

k <- ceiling(ncol(Y)/1000)
tic <- proc.time()[3]

for (j in 1:k) {
  betanew <-  NULL
  beta <-  NULL
  n <- j * 1000 
  m <- (n - 1000)+1 
  if (k == j) { n = ncol(Y) }
  cl <- makeCluster(num_cores)
  for (i in m:n)
  { 
    print(i)
    response <- Y[,i]
    fit <- cv.glmnet(pred, response, alpha = 1, parallel = TRUE)
    beta1 <- coef(fit, s=fit$lambda.min)
    beta <- cbind(beta, beta1[,1])
  } 
  print(dim(beta))
  print(beta[1:10, 1:10])
  
  betanew <- (beta[-1,])
  filetowrite <- paste("BetaMatrix-Lasso-",m,"-to-",n,".csv", sep="") 
  write.table(betanew, paste("Results/LASSO/",filetowrite, sep=""), sep=",")
  stopCluster(cl)
}

toc = proc.time()[3]
