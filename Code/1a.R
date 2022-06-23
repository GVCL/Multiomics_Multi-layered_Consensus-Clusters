# Setting higher memory limit
memory.limit(size = 1000000)

load("dims0.Rdata")

Ynew <- as.matrix(read.csv(Ynew_fname, header = TRUE,row.names = 1))
Xnew <- as.matrix(read.csv(Xnew_fname, header = TRUE,row.names = 1))
Betas <- as.matrix(read.csv(FinalMat_fname, header = TRUE, row.names = 1))

dim(Ynew)
dim(Xnew)
dim(Betas)

Ypredict <- Xnew %*% (Betas)  
Residuals <- Ynew - Ypredict 
Ynew <- NULL
Xnew <- NULL
Betas <- NULL
Ypredict <- NULL
dim(Residuals)

gc()

parCor <- corAndPvalue(Residuals, method = "pearson")
cor <- parCor$cor
nnzero(cor)
pval <- parCor$p
nnzero(pval)

pval[(pval < 0.05) ] <- 1
pval[(pval < 1) ] <- 0 # Created a binary matrix with p val < 0.05 as 1 and rest all 0
nnzero(pval)

NewCor <- pval * cor 
nnzero(NewCor)

ParCorr_dims <- dim(NewCor)
ParCorr_dims_str <- paste0(dim(NewCor)[1], 'x', dim(NewCor)[2])
ParCorr_fname <- paste0("Results/PartialCorrelation/ParCorr-Lasso-pvalueBased-", ParCorr_dims_str, ".csv")

save(
  ParCorr_fname,
  ParCorr_dims,
  ParCorr_dims_str,
  file = "dims1a.Rdata"
)

write.table(round(NewCor,3), ParCorr_fname, sep=",")     	

Residuals <-NULL
pval <- NULL
cor <- NULL