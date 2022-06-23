# Setting higher memory limit
memory.limit(size = 1000000)

no_cores <- detectCores() - 1  
cl <- makeCluster(no_cores)
registerDoParallel(cl)

Y <- as.matrix(as.data.table(read_csv(file = "final_mRNA_normalized.csv")), rownames = TRUE)
X <- as.matrix(as.data.table(read_csv(file = "final_methy_data.csv")), rownames = TRUE)

stopCluster(cl)

cl <- makeCluster(no_cores)
Filebind <- 1
k <- ceiling(ncol(Y)/1000)

for (i in 1:k){ 
  n <- i*1000
  m <- (n - 1000)+1 
  if (k == i){ n = ncol(Y) }
  filetoread <- paste("Results/LASSO/BetaMatrix-Lasso-",m,"-to-",n,".csv", sep="") 
  fileNew <- read.csv (filetoread, header = TRUE, row.names = 1)
  print(filetoread)
  print(dim(fileNew))
  Filebind <- cbind(Filebind, fileNew)
  print(dim(Filebind))
}

stopCluster(cl)

dim(Filebind)
Filebindnew <- (Filebind[,-1])
row.names(Filebindnew) <-colnames(X)
colnames(Filebindnew) <- colnames(Y)

nonzeroBetas <- nnzero(Filebindnew, na.counted = NA)
nonzeroBetas

write.table(Filebindnew, "Results/LASSO/Final-BetaMatrix.csv", sep=",")
