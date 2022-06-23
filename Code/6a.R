# Setting higher memory limit
memory.limit(size = 1000000)

L1_clusters = data.table(read.csv("Results/Communities/L1/L1_CoANsCommunities_Louvain.csv", sep=",", header = TRUE))

head(L1_clusters)

len <- length(unique(L1_clusters$Communities))

newVal <- NULL
for (i in 1:len){
  ClustersNew <- L1_clusters[which(L1_clusters$Communities == i),]
  if (nrow(ClustersNew) > 1)
  {
    print("########################")
    print(i)
    tab <- table(ClustersNew$Communities)
    print((tab))
    val <- tab[[1]]
    newVal <- rbind(val , newVal)
  }
}

L1_meanthreshold <- floor(mean(newVal)) 
L1_meanthreshold 

save(L1_meanthreshold, file = 'dims6a.Rdata')
