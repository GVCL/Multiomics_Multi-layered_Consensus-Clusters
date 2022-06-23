# Setting higher memory limit
memory.limit(size = 1000000)

num_cores <- as.integer(detectCores() / 2)
cl <- makeCluster(num_cores)
registerDoParallel(cl)

load("dims0.Rdata")

Y <- as.matrix(read.csv(Ynew_fname, header = TRUE,row.names = 1))
X <- as.matrix(read.csv(Xnew_fname, header = TRUE,row.names = 1))
dim(Y)
dim(X)

xmethylation.names <- colnames(X)
mRNA.names <- colnames(Y)

parCor <- corAndPvalue(Y, X, method = "spearman")
cor <- parCor$cor
nnzero(cor)
pval <- parCor$p
nnzero(pval)

pval[(pval < 0.05) ] <- 1
pval[(pval < 1) ] <- 0 # Created a binary matrix with p val < 0.05 as 1 and rest all 0
nnzero(pval)

NewCor <- pval * cor 
nnzero(NewCor)

MAT <- as.matrix(round(NewCor,3))

NewCor <- NULL
cor <- NULL
pval <- NULL
Y <- NULL
X <- NULL


SpearmanRank_dims <- dim(MAT)
SpearmanRank_dims_str <- paste0(dim(MAT)[1], 'x', dim(MAT)[2])
SpearmanRank_fname <- paste0("Results/SpearmanCorrelation/SpearmanRank-CorrMatrix-pvalBased-", SpearmanRank_dims_str, ".csv")

save(
  SpearmanRank_fname,
  SpearmanRank_dims,
  SpearmanRank_dims_str,
  file = "dims2a.Rdata"
)

write.table(MAT, SpearmanRank_fname, sep=",")     	
