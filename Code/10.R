library(dplyr)

methy_df <- read.csv("methy_gene_rank.csv")
exp_df <- read.csv("mRNA_gene_rank.csv")

req_genes <- intersect(methy_df$Genes, exp_df$Genes)

methy_filt <- (methy_df %>% filter(methy_df$Genes %in% req_genes))
mRNA_filt <- (exp_df %>% filter(exp_df$Genes %in% req_genes))

df <- merge(methy_filt, mRNA_filt, by='Genes')

df$Rank <- df$Rank.x + df$Rank.y

head(df)

df_sorted <- df %>% arrange(desc(Rank))

write.csv(df_sorted, "filtered_ranks.csv", row.names = FALSE)

