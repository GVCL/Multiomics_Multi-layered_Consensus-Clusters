memory.limit(size = 1000000)

load('dims2c.Rdata')
L3Mat <- as.matrix(read.csv(SpearmanRankFiltered_fname, sep=",", header = TRUE, row.names = 1))

rownames(L3Mat) <- gsub('mRNA_ ','mRNA_', rownames(L3Mat))
colnames(L3Mat) <- gsub('methy_.','methy_', colnames(L3Mat))

L3Mat[1:10,1:10]

load('dims7.Rdata')
L1_HCCgenes <- read.csv(paste0("Results/SelectedGenes/L1/HCCs-FinalGenes_", val_str, ".csv"), sep=",", header = TRUE)
L2_HCCgenes <- read.csv(paste0("Results/SelectedGenes/L2/HCCs-FinalGenes_", val_str, ".csv"), sep=",", header = TRUE)

L1_NCCgenes <- read.csv(paste0("Results/SelectedGenes/L1/NCCs-FinalGenes_", val_str, ".csv"), sep=",", header = TRUE)
L2_NCCgenes <- read.csv(paste0("Results/SelectedGenes/L2/NCCs-FinalGenes_", val_str, ".csv"), sep=",", header = TRUE)

methy <- rbind(L1_HCCgenes, L1_NCCgenes)
exp <- rbind(L2_HCCgenes, L2_NCCgenes)

newL3 <- L3Mat[,(match(gsub("methy_", "", methy$Genes), colnames(L3Mat)))]
L3 <- newL3[(match(gsub("mRNA_", "", exp$Genes),rownames(newL3))),]

L3_dims = dim(L3)
L3_dims_str <- paste0(as.character(L3_dims[1]), 'x', as.character(L3_dims[2]))
L3_fname <- paste0("Results/SpearmanCorrelation/SpearmanRank-CorrMatrix-NodedegreebasedSelectedMatrix[", L3_dims_str , "]_", val_str, ".csv")
write.table(L3, L3_fname, sep = ",")

g2 <- graph_from_incidence_matrix(as.matrix(abs(L3)), weighted=TRUE)

edgeBetween <- edge_betweenness(g2 , weights = E(g2)$weight)
Edges <- as_data_frame(g2, what="edges")
betweenNess <- data.frame(Edges, edgeBetween)

write.table(betweenNess,paste0("Results/SelectedGenes/EdgeBetweenNess_", val_str, ".csv"), sep = ",")

cutoff <- ceiling(max(betweenNess$edgeBetween)*tval)
selectedEdges <- betweenNess[betweenNess$edgeBetween >= cutoff ,]

write.table(selectedEdges,paste0("Results/SelectedGenes/EdgeBetweenNess-FilteredEdges_", val_str, ".csv"), sep = ",")
