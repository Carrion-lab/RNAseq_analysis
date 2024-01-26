# RNAseq Analysis Repository

Welcome to the repository for the analysis of the RNAseq dataset presented in the paper by Arezoo et al, 2024.

## Overview

This repository contains two essential scripts that were employed in the analysis:

1. **pipeline.R**: This script is designed to be executed in a Linux environment. It sequentially invokes various software tools for each step of the analysis. The steps include:

   - Trimmomatic
   - Hisat2
   - Samtools
   - FeatureCounts

   The ultimate goal is to generate a comprehensive table that captures raw counts of each gene across all samples.

2. **Deseq2.R**: Following the execution of the "pipeline.R" script, this script processes and consolidates all the outputs into a unified table. This resultant table is then subjected to further normalization and statistical analysis using the Deseq2 R package.

## Usage

To replicate the analysis or adapt it for your own dataset, follow these steps:

1. Execute the "pipeline.R" script in a Linux environment, ensuring that the necessary dependencies (Trimmomatic, Hisat2, Samtools, and FeatureCounts) are installed.
2. Run the "Deseq2.R" script in Rstudio, which will process the outputs of the previous step and perform normalization and statistical analysis using the Deseq2 R package.

Feel free to explore, adapt, and contribute to this repository. If you have any questions or encounter issues, please don't hesitate to open an issue or reach out.

Happy analyzing! 🧬🔬
