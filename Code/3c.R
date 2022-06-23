# Setting higher memory limit
memory.limit(size = 1000000)

plot <- read.csv("Results/BiCorr/BiCor-pValbased-Percollation.csv", sep=",", header = TRUE)

t <- 0.36
opt <- 'N'

while (opt == 'N') {
  t1 <- readline("Enter the threshold (default: 0.36) ")
  if (t1 != '') t <- as.numeric(t1)
  else t <- 0.36
  
  par(mfrow=c(1,2))
  plot <- plot[plot$cutoff >= 0.1, ]
  
  ## 1. 
  x <- seq(0.2, 0.8, by=0.02)
  y1 <- plot[,3]
  y2 <- plot[,2]
  
  par(mar = c(5, 5, 5, 5))
  plot(x, y1, type="n", main="Layer2 - Finding Threshold Value", xlab="",ylab="", lty = 1, cex.axis=1, font = 2, font.sub = 2, xaxt="n")
  mtext(side=1, line=3, "Cutoff on Edge Values", font=2,cex=1.2)
  mtext(side=2, line=2, "#Nodes of Giant Components", font=2, cex=1.2)
  axis(1, at = seq(0.2, 0.8, by=0.02), font=2, las=2)
  lines(x, y1, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
  lines(x, y1, type="l")
  abline(v=0.36, col="blue", lty=2, lwd=3)
  par(new = TRUE)
  plot(x, y2, type = "n", xaxt = "n", yaxt = "n", ylab = "", xlab = "", col = "black", lty = 1, lwd = 1, cex.axis=4)
  mtext(side=4, line=2.5, "#Components", font=2, cex=1.2, col = "grey")
  axis(4, at = seq(0, 8760, by=150), font=2, las=2, col.axis ="grey")
  lines(x, y2, pch = 19, col = "grey", type = "p", lty = 2, lwd = 1)
  lines(x, y2, type="l")
  
  opt <- as.character(readline("Do you wish to proceed? (Y/N) "))
}

load("dims3a.Rdata")
NewCor <- read.csv(BiCorr_fname, header = TRUE)
NewCor[(abs(NewCor) < 0.36) ] <- 0

BiCorrFiltered_dims <- dim(NewCor)
BiCorrFiltered_dims_str <- paste0(dim(NewCor)[1], 'x', dim(NewCor)[2])
BiCorrFiltered_fname <- paste0("Results/BiCorr/BiCor_pvalBased-", BiCorrFiltered_dims_str, "_Above(", as.character(t), ").csv")

save(
  BiCorrFiltered_fname,
  BiCorrFiltered_dims,
  BiCorrFiltered_dims_str,
  file = "dims3c.Rdata"
)

write.table(round(NewCor,3), BiCorrFiltered_fname, sep=",")     	
