# Setting higher memory limit
memory.limit(size = 1000000)

plot1 <- read.csv("Results/PartialCorrelation/PartialCorrelation-Percollation-pValueBased.csv", sep=",", header = TRUE)

t <- 0.38
opt <- 'N'

while (opt == 'N') {
  t1 <- readline("Enter the threshold (default: 0.38)")
  if (t1 != '') t <- as.numeric(t1)
  else t <- 0.38
  par(mfrow=c(1,2))
  plot <- plot1[plot1$cutoff >= 0.1, ]
  
  ## 1. 
  x <- seq(0.2, 0.8, by=0.02)
  y <- plot[,3]
  
  plot(x, y, xaxt="n", main="Finding Threshold Value-Partial Correlation", xlab = "Cutoff on Edge Values",  ylab = "Nodes of Giant Components", cex.lab=1.2, cex.axis = 1, font.axis = 2)
  axis(1, at = seq(0.1, 0.8, by=0.02), las=2, font.axis = 2)
  lines(x, y, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
  lines(x, y, type="l")
  abline(v=t, col="red", lty=2, lwd=3)
  
  
  ## 2.
  x <- seq(0.2, 0.8, by=0.02)
  y <- plot[,2]
  
  plot(x, y, xaxt="n", main="Finding Threshold Value-Partial Correlation", xlab = "Cutoff on Edge Values",  ylab = "Number of Connected Components", cex.lab=1.2, cex.axis = 1, font.axis = 2, xaxt="n")
  axis(1, at = seq(0.2, 0.8, by=0.02), las=2, font.axis = 2)
  #axis(2, at = seq(0, 100, by=10), las=2, font.axis = 2)
  lines(x, y, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
  lines(x, y, type="l")
  abline(v=t, col="red", lty=2, lwd=3)
  
  
  ## 3. 
  x <- seq(0.2, 0.8, by=0.02)
  y1 <- plot[,3]
  y2 <- plot[,2]
  
  par(mar = c(5, 5, 5, 5))
  plot(x, y1, type="n", main="Layer1 - Finding Threshold Value", xlab="",ylab="", lty = 1, cex.axis=1, font = 2, font.sub = 2, xaxt="n")
  mtext(side=1, line=3, "Cutoff on Edge Values", font=2,cex=1.2)
  mtext(side=2, line=2, "#Nodes of Giant Components", font=2, cex=1.2)
  axis(1, at = seq(0.0, 0.8, by=0.02), font=2, las=2)
  lines(x, y1, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
  lines(x, y1, type="l")
  abline(v=t, col="blue", lty=2, lwd=3)
  par(new = TRUE)
  plot(x, y2, type = "n", xaxt = "n", yaxt = "n", ylab = "", xlab = "", col = "black", lty = 1, lwd = 1, cex.axis=4)
  mtext(side=4, line=3.0, "#Components", font=2, cex=1.2, col = "grey")
  axis(4, at = seq(0, 15100, by=150), font=2, las=2, col.axis ="grey")
  lines(x, y2, pch = 19, col = "grey", type = "p", lty = 2, lwd = 1)
  lines(x, y2, type="l")
  
  opt <- as.character(readline("Do you wish to proceed? (Y/N)"))
}

load("dims1a.Rdata")
NewCor <- read.csv(ParCorr_fname, header = TRUE, row.names = 1)
dataNew <- as.matrix(NewCor)
mat <- ifelse(abs(dataNew) < t, 0, dataNew)


ParCorrFiltered_dims <- dim(mat)
ParCorrFiltered_dims_str <- paste0(dim(mat)[1], 'x', dim(mat)[2])
ParCorrFiltered_fname <- paste0("Results/PartialCorrelation/Partial-CorrMatrix-", ParCorrFiltered_dims_str, "_Above(", as.character(t) ,")-pvalueBased.csv")

save(
  ParCorrFiltered_fname,
  ParCorrFiltered_dims,
  ParCorrFiltered_dims_str,
  file = "dims1c.Rdata"
)

write.table(mat, ParCorrFiltered_fname, sep = ",")
