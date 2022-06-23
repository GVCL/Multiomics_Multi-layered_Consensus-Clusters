# Setting higher memory limit
memory.limit(size = 1000000)

mat <- read.csv("Results/LASSO/Final-BetaMatrix.csv", header = TRUE, row.names = 1)
mat <- (round(mat, 3))

rowIndex <- NULL 
for (i in 1:nrow(mat))
{  
  S <- mat[i,]
  if (nnzero(S) != 0)
  {
    print(i)
    rowIndex <- rbind (rowIndex, i)  
  }
}
length(rowIndex)

colIndex <- NULL 
for (i in 1:ncol(mat))
{  
  S <- mat[,i]
  if (nnzero(S) != 0)
  {
    print(i)
    colIndex <- rbind (colIndex, i)  
  }
}
length(colIndex)

Y <- as.matrix(as.data.table(read_csv(file = "final_mRNA_normalized.csv")), rownames = TRUE)
X <- as.matrix(as.data.table(read_csv(file = "final_methy_data.csv")), rownames = TRUE)
Filebindnew <- read.csv("Results/LASSO/Final-BetaMatrix.csv", header = TRUE, row.names = 1)

Xnew <- X[ ,rowIndex]
Ynew <- Y[ ,colIndex]

rowfilered <- Filebindnew[rowIndex, ]
filtered <- rowfilered[ ,colIndex]
FinalMat <- as.matrix(filtered)
dim(FinalMat)

FinalMat_dim_str <- paste0(dim(FinalMat)[1], 'x', dim(FinalMat)[2])
FinalMat_dim <- dim(FinalMat)
FinalMat_fname <- paste0("Results/BetaMatrix-AfterLasso-forParcorr-", FinalMat_dim_str, ".csv")
Ynew_dim_str <- paste0(dim(Ynew)[1], 'x', dim(Ynew)[2])
Ynew_dim <- dim(Ynew)
Ynew_fname <- paste0("Results/Y-mRNA-AfterLasso-", Ynew_dim_str, ".csv")
Xnew_dim_str <- paste0(dim(Xnew)[1], 'x', dim(Xnew)[2])
Xnew_dim <- dim(Xnew)
Xnew_fname <- paste0("Results/X-Methylation-AfterLasso-forBicor-", Xnew_dim_str, ".csv")

save(
  FinalMat_dim_str, 
  Ynew_dim_str, 
  Xnew_dim_str, 
  FinalMat_dim, 
  Ynew_dim, 
  Xnew_dim, 
  FinalMat_fname,
  Ynew_fname,
  Xnew_fname,
  file = "dims0.Rdata"
)

write.table(FinalMat, FinalMat_fname, sep = ",")
write.table(Ynew, Ynew_fname, sep = ",")
write.table(Xnew, Xnew_fname, sep = ",")
