# Setting higher memory limit
memory.limit(size = 1000000)

load("dims1a.Rdata")

NewCor <- read.csv(ParCorr_fname, header = TRUE, row.names = 1)

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
