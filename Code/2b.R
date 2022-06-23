# Setting higher memory limit
memory.limit(size = 1000000)

load("dims2a.Rdata")

MAT <- as.matrix(read.csv(SpearmanRank_fname, header = TRUE, row.names = 1))
hist(MAT,
     main="Histogram Spearman Correlation", 
     xlab="EdgeWeight", 
     col= "cyan3", 
     border="blue")
xlim=c(min(MAT),max(MAT))
abline(v = 0.1)
abline(v = -0.1)


# Matrix to edges convertion
corrResult <- melt(MAT)
names(corrResult) <- c("Source","Target","Corr")

results = NULL
Finalaccum = NULL
nodesCount = NULL

for(i in seq(0.2,0.8,0.02)) 
{       
  print (i)
  sublist <- corrResult[abs(corrResult$Corr) >=i ,]
  
  newData <- as.matrix(data.frame(sublist$Source,sublist$Target))
  graph <- graph.edgelist(newData,directed=FALSE)
  
  comps <- components(graph, mode = c("strong"))
  count <- comps$no
  
  print(max(comps$csize))
  maxNodes <- max(comps$csize)
  nodesCount <- rbind(nodesCount, maxNodes)
  new <- cbind(i, count)
  results <- rbind(results, new)
}

write.table(data.frame(results,nodesCount), "Results/SpearmanCorrelation/Spearman-Percollation-pvalBased.csv", sep = ",", col.names= c("cutoff","ConnectedComponentsCount","GiantComponentNodesCount"), row.names = FALSE)
