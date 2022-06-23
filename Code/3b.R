# Setting higher memory limit
memory.limit(size = 1000000)

num_cores <- as.integer(detectCores() / 2)
cl <- makeCluster(num_cores)
registerDoParallel(cl)

load("dims3a.Rdata")

NewCor <- as.matrix(read.csv(BiCorr_fname, header = TRUE))
corrResult <- melt(NewCor)
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

write.table(data.frame(results,nodesCount), "Results/BiCorr/BiCor-pValbased-Percollation.csv", sep = ",", col.names= c("cutoff","ConnectedComponentsCount","GiantComponentNodesCount"), row.names = FALSE)
