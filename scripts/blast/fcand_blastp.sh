#!/bin/bash
#BSUB -L /bin/bash
#BSUB -J blastp
#BSUB -n 16
#BSUB -R "span[ptile=16]"
#BSUB -N

module add Blast/ncbi-blast/2.2.31+

blastp -query fcand_proteins.fa -db fcand_proteins_database.fa \
-out fcand.blast -evalue 1e-10 -outfmt 6 -num_alignments 5 -num_threads 16



