memory.limit(size = 1000000)

L2_clusters = data.table(read.csv("Results/Communities/L2/L2_CoANsCommunities_Louvain.csv", sep=",", header = TRUE))
head(L2_clusters)

load('dims1c.Rdata')
L2_mat = as.matrix(read.csv(ParCorrFiltered_fname, sep=",", header = TRUE))
dim(L2_mat)
head(L2_mat)

len <- length(unique(L2_clusters$Communities))

load('dims6b.Rdata')
meanthreshold = L2_meanthreshold

finalDegreeGenes <- NULL
finalBetweenGenes <- NULL
finalEccenGenes <- NULL

j <- 0 
me <- 0
mr <- 0

for (i in 1:len){   
  ClustersNew <- L2_clusters[which(L2_clusters$Communities == i),]
  
  if (nrow(ClustersNew) > meanthreshold)
  {
    j <- j + 1
    #print (j)
    
    filtered <- ClustersNew[order(ClustersNew$NodeNames),]
    
    m <- nrow(filtered)
    
    if(m != 0)
    {  
      me <- me+1  
      methygenes <- ClustersNew$NodeNames
      newL2 <- L2_mat[(match(methygenes,colnames(L2_mat))),]
      L2 <- newL2[,(match(methygenes, colnames(L2_mat)))]
      
      g1 <- graph_from_adjacency_matrix(abs(L2), weighted=TRUE, mode="undirected")
      NodeDegree_methy <- degree(g1)    
      Eccentr_methy <- eccentricity(g1)
      Between_methy <- betweenness(g1)
      Radius_methy <- radius(g1)
      
      limit <-  ceiling(m*tval)       
      selectedDegree <- names(sort(NodeDegree_methy, decreasing = TRUE)[1:limit])
      selectedBetween <- names(sort(Between_methy, decreasing = TRUE)[1:limit])
      selectedEccen <- names(which(Eccentr_methy == Radius_methy))       
      
      Degree <-  paste("mRNA_",selectedDegree, sep="")
      Between <- paste("mRNA_",selectedBetween, sep="")
      Ececen <- paste("mRNA_",selectedEccen, sep="")
      finalDegreeGenes <- c(Degree, finalDegreeGenes)     
      finalBetweenGenes <- c(Between, finalBetweenGenes)
      finalEccenGenes <- c(Ececen, finalEccenGenes)       
    }     
  }  
}  
j  
length(finalDegreeGenes)
length(finalBetweenGenes)
length(finalEccenGenes)

SelectedHCCNodes <- Reduce(union, list(finalDegreeGenes, finalBetweenGenes, finalEccenGenes))
length(SelectedHCCNodes)

write.table(finalDegreeGenes, paste0("Results/SelectedGenes/L2/NodeDegreeBasedGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
write.table(finalBetweenGenes, paste0("Results/SelectedGenes/L2/NodeBetweenessBasedGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
write.table(finalEccenGenes, paste0("Results/SelectedGenes/L2/NodeEccentricityBasedGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
write.table(SelectedHCCNodes, paste0("Results/SelectedGenes/L2/HCCs-FinalGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))


meGenes <- SelectedHCCNodes[SelectedHCCNodes %like% "methy_"]
mRGenes <- SelectedHCCNodes[SelectedHCCNodes %like% "mRNA_"]

methygenes <- gsub('methy_','', meGenes)
mRNAgenes <- gsub('mRNA_','', mRGenes)

# --- NCC --- #

j <- 0
collectedGenes <- NULL
for (i in 1:len){   
  ClustersNew <- L2_clusters[which(L2_clusters$Communities == i),]
  if ((nrow(ClustersNew) < meanthreshold) & (nrow(ClustersNew) > 1))
  { 
    j <- j+1
    genesSelected <- ClustersNew$NodeNames
    collectedGenes <- c(genesSelected, collectedGenes)
  }  
}  
j ## total are 1463 Clusters outof which 199 are > mean threshold so j should be 1463-199 = 1264

finalDegreeGenes <- NULL
finalBetweenGenes <- NULL
finalEccenGenes <- NULL

mRNAgenes <- collectedGenes
newL2 <- L2_mat[(match(mRNAgenes,colnames(L2_mat))),]
L2 <- newL2[,(match(mRNAgenes, colnames(L2_mat)))]
g2 <- graph_from_adjacency_matrix(abs(L2), weighted=TRUE, mode="undirected")
NodeDegree_mRNA <- degree(g2)    
Eccentr_mRNA <- eccentricity(g2)
Between_mRNA <- betweenness(g2)

limit <-  ceiling(length(mRNAgenes)*tval)       
selectedDegree <- names(sort(NodeDegree_mRNA, decreasing = TRUE)[1:limit])
selectedBetween <- names(sort(Between_mRNA, decreasing = TRUE)[1:limit])
selectedEccen <- names(which(Eccentr_mRNA == 0))       

Degree <-  paste("mRNA_",selectedDegree, sep="")
Between <- paste("mRNA_",selectedBetween, sep="")
Ececen <- paste("mRNA_",selectedEccen, sep="")
finalDegreeGenes <- c(Degree, finalDegreeGenes)
finalBetweenGenes <- c(Between, finalBetweenGenes)
finalEccenGenes <- c(Ececen, finalEccenGenes)

length(finalDegreeGenes)
length(finalBetweenGenes)
length(finalEccenGenes)

SelectedNCCNodes <- Reduce(union, list(finalDegreeGenes, finalBetweenGenes, finalEccenGenes))

write.table(finalDegreeGenes, paste0("Results/SelectedGenes/L2/NCCs-NodeDegreeBasedGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
write.table(finalBetweenGenes, paste0("Results/SelectedGenes/L2/NCCs-NodeBetweenessBasedGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
write.table(finalEccenGenes, paste0("Results/SelectedGenes/L2/NCCs-NodeEccentricityBasedGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
write.table(SelectedNCCNodes, paste0("Results/SelectedGenes/L2/NCCs-FinalGenes_", val_str, ".csv"), sep=",", col.names = c("Genes"))
