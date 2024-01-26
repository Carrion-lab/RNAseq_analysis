
files_forward <- list.files('data/', pattern = '_1.fq.gz')
files_reverse <- list.files('data/', pattern = '_2.fq.gz')


df <- data.frame(Forward = files_forward, Reverse = files_reverse)

df$folder <-  gsub('.fq.gz', '',  df$Forward)
df$folder <- paste0('processed/', df$folder)
df$Forward <- paste0('data/', df$Forward)
df$Reverse <- paste0('data/', df$Reverse)
dir.create('processed')

for (i in 1:nrow(df)){
  system(paste0("mkdir ", df[[3]][i]))
  system(paste0("trimmomatic PE -phred33 -threads 20 ", df[[1]][i], " ", df[[2]][i], " ", df[[3]][i], "/sequence_1_trimmed.fastq ", df[[3]][i], "/sequence_1_unpair_trimmed.fastq ", df[[3]][i], "/sequence_2_trimmed.fastq ", df[[3]][i], "/sequence_2_unpair_trimmed.fastq HEADCROP:11 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36"))
  system(paste0("hisat2 -p 20 -x index/hisat2_index -1 ", df[[3]][i], "/sequence_1_trimmed.fastq -2 " , df[[3]][i], "/sequence_2_trimmed.fastq -S ", df[[3]][i], "/hisat2_alignment.sam"))
  
  system(paste0("samtools view -S -b ", df[[3]][i], "/hisat2_alignment.sam > ", df[[3]][i], "/hisat2_alignment.bam"))
  system(paste0("samtools sort ", df[[3]][i], "/hisat2_alignment.bam -o ", df[[3]][i], "/hisat2_alignment_sorted.bam"))
  system(paste0("samtools index ", df[[3]][i], "/hisat2_alignment_sorted.bam"))
  system(paste0("featureCounts -T 24 -t transcript -g gene_id -O -a GTF.gtf -o ", df[[3]][i], "/counts.txt ", df[[3]][i], "/hisat2_alignment_sorted.bam"))
  print(paste0('Sample ', df[[3]][i] , ' is finished' ) )
  }


