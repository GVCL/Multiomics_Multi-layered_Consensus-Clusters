# Setting higher memory limit
memory.limit(size = 1000000)

plot1 <- read.csv("Results/SpearmanCorrelation/Spearman-Percollation-pvalBased.csv", sep=",", header = TRUE)

t <- 0.3
opt <- 'N'

while (opt == 'N') {
  t1 <- readline("Enter the threshold (default: 0.30)")
  if (t1 != '') t <- as.numeric(t1)
  else t <- 0.30
  
  par(mfrow=c(1,2))
  plot <- plot1[plot1$cutoff >= 0.1, ]
  
  # 1. 
  x <- seq(0.2, 0.8, 0.02)
  y <- plot[,3]
  
  plot(x, y, xaxt="n", main="Finding Threshold Value", xlab = "Cutoff on Edge Values",  ylab = "Nodes of Giant Components", cex.lab=1.2, cex.axis = 1, font.axis = 2)
  axis(1, at = seq(0.1, 0.74, by=0.02), las=2, font.axis = 2)
  lines(x, y, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
  lines(x, y, type="l")
  abline(v=t, col="red", lty=2, lwd=3)
  
  
  ## 2.
  x <- seq(0.2, 0.8, by=0.02)
  y <- plot[,2]
  
  plot(x, y, xaxt="n", main="Finding Threshold Value", xlab = "Cutoff on Edge Values",  ylab = "Number of Connected Components", cex.lab=1.2, cex.axis = 1, font.axis = 2, xaxt="n", yaxt = "n")
  axis(1, at = seq(0.2, 0.8, by=0.02), las=2, font.axis = 2)
  axis(2, at = seq(0, 500, by=10), las=2, font.axis = 2)
  lines(x, y, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
  lines(x, y, type="l")
  abline(v=t, col="red", lty=2, lwd=3)
  
  opt <- as.character(readline("Do you wish to proceed? (Y/N)"))
}

load("dims2a.Rdata")
MAT <- as.matrix(read.csv(SpearmanRank_fname, header = TRUE, row.names = 1))
mat <- ifelse(abs(MAT) < t, 0, MAT)

SpearmanRankFiltered_dims <- dim(mat)
SpearmanRankFiltered_dims_str <- paste0(dim(mat)[1], 'x', dim(mat)[2])
SpearmanRankFiltered_fname <- paste0("Results/SpearmanCorrelation/SpearmanRank-CorrMatrix-Filtered_", SpearmanRankFiltered_dims_str, "-pvalbaed(", as.character(t), " cutoff).csv")

save(
  SpearmanRankFiltered_fname,
  SpearmanRankFiltered_dims,
  SpearmanRankFiltered_dims_str,
  file = "dims2c.Rdata"
)

write.table(mat, SpearmanRankFiltered_fname, sep=",")     	
