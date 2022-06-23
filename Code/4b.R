# Setting higher memory limit
memory.limit(size = 1000000)

load('dims1c.Rdata')

L2 = read.csv(ParCorrFiltered_fname, header=TRUE, row.names = 1)
dim(L2)

L2 <- as.matrix(abs(round(L2,3)))
g2 <- graph_from_adjacency_matrix(L2, weighted=TRUE, mode="undirected")

len <- ncol(L2)

L2 <- NULL
gc()

clust <- walktrap.community(g2, weights = E(g2)$weight) 
moduleswalktrap <- clust$membership
length(unique(moduleswalktrap)) # 1966 Communities
#table(moduleswalktrap)

clust <- fastgreedy.community(g2, weights = E(g2)$weight) 
modulesfastgreedy <- clust$membership
length(unique(modulesfastgreedy)) # 537 Communities
#table(modulesfastgreedy)

groups <- cluster_louvain(g2)
n <- length(groups)
n # 349 Communities
x <- NULL
for (i in 1:n)
{
  xnew <- data.frame(groups[[i]],i, fix.empty.names = FALSE)
  x <- rbind(x, xnew)
}

toWrite <- data.frame(c(1:len), x, data.frame(moduleswalktrap), data.frame(modulesfastgreedy))
length(unique(moduleswalktrap))
length(unique(modulesfastgreedy))
n
write.table(toWrite, "Results/Communities/L2/parCor-igraphCommunities-pvalueBased.csv", sep = ",", col.names= c("NodeIds", "NodeNames", "LouvaninCommu", "WalkTrapCommu","FastGreedyComm"), row.names = FALSE)
