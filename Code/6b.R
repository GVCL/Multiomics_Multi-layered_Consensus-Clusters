# Setting higher memory limit
memory.limit(size = 1000000)

L2_clusters = data.table(read.csv("Results/Communities/L2/L2_CoANsCommunities_Louvain.csv", sep=",", header = TRUE))

head(L2_clusters)

len <- length(unique(L2_clusters$Communities))

newVal <- NULL
for (i in 1:len){
  ClustersNew <- L2_clusters[which(L2_clusters$Communities == i),]
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

L2_meanthreshold <- floor(mean(newVal)) # 1080 clusters in newVal
L2_meanthreshold # Evaluated: 11

save(L2_meanthreshold, file = 'dims6b.Rdata')
