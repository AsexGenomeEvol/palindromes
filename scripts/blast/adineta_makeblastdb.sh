#!/bin/bash
#BSUB -L /bin/bash
#BSUB -J makeblastdb
#BSUB -o fcand_makeblastdb.log
#BSUB -e fcand_makeblastdb_error.log
#BSUB -N


module add Blast/ncbi-blast/2.2.31+

makeblastdb -in adineta_pep_database.fa -dbtype prot
