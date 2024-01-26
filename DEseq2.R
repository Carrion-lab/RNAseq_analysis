library(DESeq2)
library(writexl)

#Load and merge count tables of individual samples

files_forward <- list.files('data/', pattern = '_1.fq.gz')
files_reverse <- list.files('data/', pattern = '_2.fq.gz')


df <- data.frame(Forward = files_forward, Reverse = files_reverse)

df$folder <-  gsub('.fq.gz', '',  df$Forward)
df$folder <- paste0('processed/', df$folder)
df$Forward <- paste0('data/', df$Forward)
df$Reverse <- paste0('data/', df$Reverse)

list_counts <- list()
for (i in 1:nrow(df)){
  counts <- read.table( paste0(df[[3]][i], '/counts.txt'), header = T)
  counts <- counts[,c(1,7)]
  list_counts[[i]] <- counts
  
}


M <- list_counts[[1]]
for (i in 2:nrow(df)){
  M <- merge(M, list_counts[[i]], by = 'Geneid', all = T)
  
}

colnames(M)[2:ncol(M)] = sapply(strsplit(colnames(M)[2:ncol(M)],"[.]"), `[`, 2)
writexl::write_xlsx(M, 'tables/raw_reads.xlsx')
rownames(M)= M$Geneid
M$Geneid = NULL




#DESEQ2
#Example of comparison Mock 12h VS Flavo 12h

deseq_dataset <- DESeqDataSetFromMatrix(countData = M[,c(1:6)], colData = data.frame(condition = c(rep('Mock12h', 3), rep('Flavo12h', 3) )), design = ~ condition)
deseq_results <- DESeq(deseq_dataset)
normalized_counts <- as.data.frame(counts(deseq_results, normalized=TRUE))
normalized_counts$gene = rownames(normalized_counts)
res <- lfcShrink(deseq_results, coef="condition_Mock12h_vs_Flavo12h", type="apeglm")
resOrdered <- as.data.frame(res[order(res$pvalue),])
resOrdered$gene = rownames(resOrdered)
final = merge(resOrdered, normalized_counts, by = 'gene', all.x = T)
final$gene = str_remove(final$gene, 'gene-')
writexl::write_xlsx(final, 'tables/Flavo12h_vs_Mock12h.xlsx')








