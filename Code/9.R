memory.limit(size = 1000000)

load('dims1c.Rdata')
load('dims3c.Rdata')
load('dims7.Rdata')

data <- read.csv(paste0("Results/SelectedGenes/EdgeBetweenNess-FilteredEdges_", val_str, ".csv"), sep=",", header = TRUE)

exp <- unique(gsub("mRNA_", "", data$from))
methy <- unique(gsub("methy_", "", data$to))

genes <- union(methy, exp)

methyMat <- as.matrix(fread(BiCorrFiltered_fname), rownames=1)

methyDims <- dim(methyMat)
methyDims

selRows <- unique(intersect(methy, rownames(methyMat)))
selInd <- match(selRows, rownames(methyMat))

stopifnot(length(selRows) == length(methy))

methyMat <- methyMat[selInd, selInd]
methyDims <- dim(methyMat)
methyDims

genes <- rownames(methyMat)
corrVals <- rep(0, methyDims[1])

for (i in 1:methyDims[1]) {
  row <- methyMat[i, ]
  colnames(row)
  row[i] <- 0
  corrVals[i] <- max(row)
}

corrVals

sortedCorr <- sort(corrVals, index.return=TRUE)
sortedCorr$x
sortedCorr$ix

methy_df <- data.frame(genes, sortedCorr$ix)
colnames(methy_df) <- c("Genes", "Rank")

write.csv(methy_df, "methy_gene_rank.csv", row.names = FALSE)

expMat <- as.matrix(fread(ParCorrFiltered_fname), rownames=1)

expDims <- dim(expMat)
expDims
selRows <- unique(intersect(exp, rownames(expMat)))
selInd <- match(selRows, rownames(expMat))

stopifnot(length(selRows) == length(exp))

expMat <- expMat[selInd, selInd]
expDims <- dim(expMat)
expDims

genes <- rownames(expMat)
corrVals <- rep(0, expDims[1])

for (i in 1:expDims[1]) {
  row <- expMat[i, ]
  colnames(row)
  row[i] <- 0
  corrVals[i] <- max(row)
}

corrVals

sortedCorr <- sort(corrVals, index.return=TRUE)
sortedCorr$x
sortedCorr$ix

exp_df <- data.frame(genes, sortedCorr$ix)
colnames(exp_df) <- c("Genes", "Rank")

write.csv(exp_df, "mRNA_gene_rank.csv", row.names = FALSE)
