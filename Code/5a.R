# Setting higher memory limit
memory.limit(size = 1000000)

fileread <- data.table(read.csv("Results/Communities/L1/BiCor--PvalueBaseedigraphCommunities.csv", sep=",", header = TRUE))
head(fileread)
k <- nrow(fileread)
k

fileread <- fileread[order(fileread$NodeNames), ]
fileread$NodeIds <- 1:k
head(fileread)

nodeNames <- fileread$NodeNames

commuDistinct <- unique(fileread$LouvaninCommu)
n <- length(commuDistinct)
n

methodLouvain <- matrix(rep(0, len=k*k), nrow = k)

for (i in 1:n)
{ 
  Nodes <- fileread$NodeIds[fileread$LouvaninCommu  == i]
  if(length(Nodes) > 1)
  {
    permuts <- permutations(n = length(Nodes), r = 2, v = Nodes)
    for (j in 1:nrow(permuts))
    {
      cs <- permuts[j,]
      methodLouvain[cs[1],cs[2]] <- 1
    }
  }  
}

commuDistinct <- unique(fileread$WalkTrapCommu)
n <- length(commuDistinct)
n
methodWalk <- matrix( rep( 0, len=k*k), nrow = k)

for (i in 1:n)
{ 
  Nodes <- fileread$NodeIds[fileread$WalkTrapCommu  == i]
  if(length(Nodes) > 1)
  {
    permuts <- permutations(n = length(Nodes), r = 2, v = Nodes)
    for (j in 1:nrow(permuts))
    {
      cs <- permuts[j,]
      methodWalk[cs[1],cs[2]] <- 1
    }
  }  
}

commuDistinct <- unique(fileread$FastGreedyComm)
n <- length(commuDistinct)
n
fastGreedy <- matrix( rep( 0, len=k*k), nrow = k)

for (i in 1:n)
{ 
  Nodes <- fileread$NodeIds[fileread$FastGreedyComm  == i]
  if(length(Nodes) > 1)
  {
    permuts <- permutations(n = length(Nodes), r = 2, v = Nodes)
    for (j in 1:nrow(permuts))
    {
      cs <- permuts[j,]
      fastGreedy[cs[1],cs[2]] <- 1
    }
  }  
}

commonMat <- methodLouvain & methodWalk & fastGreedy
commonMat <- commonMat*1
likelihoodMat <- (methodLouvain + methodWalk + fastGreedy)/3
likelihoodMat <- ifelse(abs(likelihoodMat) < 1, 0, likelihoodMat)

methodLouvain = NULL
methodWalk = NULL
fastGreedy = NULL

g  <- graph.adjacency(likelihoodMat,weighted=TRUE,mode="lower", diag=FALSE)
df <- get.data.frame(g)
head(df)

write.table(commonMat, "Results/Communities/L1/Common-Matrix.csv", sep=",", row.names = FALSE)
write.table(likelihoodMat, "Results/Communities/L1/CoANs-Matrix.csv", sep=",", row.names = FALSE)
write.table(df, "Results/Communities/L1/CoANs-Edges.csv", sep=",", col.names= c("Source","Target","CoONs-Averaged-EdgeWeight"), row.names = FALSE)

list <- as.matrix(read.csv("Results/Communities/L1/Common-Matrix.csv", sep=",", header = TRUE))

xlist <- graph_from_adjacency_matrix(commonMat, weighted=TRUE, mode="undirected")

#plot(xlist)
groups <- cluster_louvain(xlist)
n <- length(groups)
n
x <- NULL

for (i in 1:n)
{
  print(i)
  xnew <- data.frame(groups[[i]], nodeNames[groups[[i]]], i, fix.empty.names = FALSE)
  x <- rbind(x, xnew)
}

write.table(x, "Results/Communities/L1/L1_CoANsCommunities_Louvain.csv", sep=",", col.names= c("Nodes","NodeNames","Communities"), row.names = FALSE)
