# Setting higher memory limit
memory.limit(size = 1000000)

num_cores <- as.integer(detectCores() / 2)
cl <- makeCluster(num_cores)
registerDoParallel(cl)

load("dims0.Rdata")

X <- as.matrix(read.csv(Xnew_fname, header = TRUE,row.names = 1))
dim(X)

mthyCor <- bicorAndPvalue(X)
cor <- mthyCor$bicor
nnzero(cor)
pval <- mthyCor$p

pval[(pval < 0.05) ] <- 1
pval[(pval < 1) ] <- 0 # Created a binary matrix with p val < 0.05 as 1 and rest all 0
nnzero(pval)

NewCor <- pval * cor 
nnzero(NewCor)


BiCorr_dims <- dim(NewCor)
BiCorr_dims_str <- paste0(dim(NewCor)[1], 'x', dim(NewCor)[2])
BiCorr_fname <- paste0("Results/BiCorr/BiCor_pValbased-", BiCorr_dims_str, ".csv")

save(
  BiCorr_fname,
  BiCorr_dims,
  BiCorr_dims_str,
  file = "dims3a.Rdata"
)

write.table(round(NewCor,3), BiCorr_fname, sep = ",")

