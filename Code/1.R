# Setting higher memory limit
memory.limit(size = 1000000)

Ynew <- as.matrix(read.csv("Results/Y-mRNA-AfterLasso-209x16092.csv", header = TRUE,row.names = 1))
Xnew <- as.matrix(read.csv("Results/X-Methylation-AfterLasso-forBicor-209x11596.csv", header = TRUE,row.names = 1))
Betas <- as.matrix(read.csv("Results/BetaMatrix-AfterLasso-forParcorr-11596x16092.csv", header = TRUE, row.names = 1))

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

write.table(round(NewCor,3), "Results/PartialCorrelation/ParCorr-Lasso-pvalueBased-16092x16092.csv", sep=",")     	

Residuals <-NULL
pval <- NULL
cor <- NULL

# ----

NewCor <- read.csv("Results/PartialCorrelation/ParCorr-Lasso-pvalueBased-16092x16092.csv", header = TRUE, row.names = 1)

dataNew <- as.matrix(NewCor)
NewCor <- NULL
hist(dataNew,
     main="Histogram Partial Correlation", 
     xlab="EdgeWeight", 
     col= "cyan3", 
     border="blue")
xlim=c(min(dataNew),max(dataNew))
abline(v = 0.1)
abline(v = -0.1)


results <- melt(dataNew)
names(results) <- c("Source","Target","Corr")

finalresults = NULL
nodesCount = NULL

for(i in seq(0.2,0.8,0.02)) 
{       
  print (i)
  sublist <- results[abs(results$Corr) >=i ,]
  newData <- as.matrix(data.frame(sublist$Source,sublist$Target))
  graph <- graph.edgelist(newData,directed=FALSE)
  
  comps <- components(graph, mode = c("strong"))
  count <- comps$no
  
  print(max(comps$csize))
  maxNodes <- max(comps$csize)
  nodesCount <- rbind(nodesCount, maxNodes)
  new <- cbind(i, count)
  finalresults <- rbind(finalresults, new)
}


write.table(data.frame(finalresults,nodesCount), "Results/PartialCorrelation/PartialCorrelation-Percollation-pValueBased.csv", sep = ",", col.names= c("cutoff","ConnectedComponentsCount","GiantComponentNodesCount"), row.names = FALSE)

######### Percollation Analysis Plot #############

plot1 <- read.csv("Results/PartialCorrelation/PartialCorrelation-Percollation-pValueBased.csv", sep=",", header = TRUE)

par(mfrow=c(1,2))
plot <- plot1[plot1$cutoff >= 0.1, ]

## 1. 
x <- seq(0.2, 0.8, by=0.02)
y <- plot[,3]

plot(x, y, xaxt="n", main="Finding Threshold Value-Partial Correlation", xlab = "Cutoff on Edge Values",  ylab = "Nodes of Giant Components", cex.lab=1.2, cex.axis = 1, font.axis = 2)
axis(1, at = seq(0.1, 0.8, by=0.02), las=2, font.axis = 2)
lines(x, y, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
lines(x, y, type="l")
abline(v=0.38, col="red", lty=2, lwd=3)


## 2.
x <- seq(0.2, 0.8, by=0.02)
y <- plot[,2]

plot(x, y, xaxt="n", main="Finding Threshold Value-Partial Correlation", xlab = "Cutoff on Edge Values",  ylab = "Number of Connected Components", cex.lab=1.2, cex.axis = 1, font.axis = 2, xaxt="n")
axis(1, at = seq(0.2, 0.8, by=0.02), las=2, font.axis = 2)
#axis(2, at = seq(0, 100, by=10), las=2, font.axis = 2)
lines(x, y, pch = 18, col = "black", type = "p", lty = 2, lwd = 1)
lines(x, y, type="l")
abline(v=0.35, col="red", lty=2, lwd=3)


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
abline(v=0.38, col="blue", lty=2, lwd=3)
par(new = TRUE)
plot(x, y2, type = "n", xaxt = "n", yaxt = "n", ylab = "", xlab = "", col = "black", lty = 1, lwd = 1, cex.axis=4)
mtext(side=4, line=3.0, "#Components", font=2, cex=1.2, col = "grey")
axis(4, at = seq(0, 15100, by=150), font=2, las=2, col.axis ="grey")
lines(x, y2, pch = 19, col = "grey", type = "p", lty = 2, lwd = 1)
lines(x, y2, type="l")


############ Find filtered row ids and column ids
library(Matrix)

mat <- ifelse(abs(dataNew) < 0.38, 0, dataNew)
write.table(mat, "Results/PartialCorrelation/Partial-CorrMatrix-16092x16092_Above(0.38)-pvalueBased.csv", sep = ",")

# ----