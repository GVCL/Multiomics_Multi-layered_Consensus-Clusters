# Setting higher memory limit
memory.limit(size = 1000000)

load('dims3c.Rdata')

L1 = read.csv(BiCorrFiltered_fname, header=TRUE, row.names = 1)

L1 <- as.matrix(abs(round(L1,3)))
g2 <- graph_from_adjacency_matrix(L1, weighted=TRUE, mode="undirected")

len <- ncol(L1)

L1 <- NULL
gc()

clust <- walktrap.community(g2, weights = E(g2)$weight) 
moduleswalktrap <- clust$membership
length(unique(moduleswalktrap)) # 597 communities
table(moduleswalktrap)

clust <- fastgreedy.community(g2, weights = E(g2)$weight) 
modulesfastgreedy <- clust$membership
length(unique(modulesfastgreedy)) # 191 Communitites
table(modulesfastgreedy)

groups <- cluster_louvain(g2)
n <- length(groups)
n # 151
x <- NULL
for (i in 1:n)
{
  xnew <- data.frame(groups[[i]],i, fix.empty.names = FALSE)
  x <- rbind(x, xnew)
}

toWrite <- data.frame(c(1:len), x, data.frame(moduleswalktrap), data.frame(modulesfastgreedy))

write.table(toWrite, "Results/Communities/L1/BiCor--PvalueBaseedigraphCommunities.csv", sep = ",", col.names= c("NodeIds", "NodeNames", "LouvaninCommu", "WalkTrapCommu","FastGreedyComm"), row.names = FALSE)
