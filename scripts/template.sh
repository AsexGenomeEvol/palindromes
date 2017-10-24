#!/bin/bash
#BSUB -L /bin/bash
#BSUB -J <> #job_name
#BSUB -q <> #queue wanted [def:normal,priority,long]
#BSUB -o <> #name of the log output file
#BSUB -e <> #name of the error output file
#BSUB -n x #number of threads
#BSUB -M y #memory in byte
#BSUB -R "rusage[mem=y/1000] span[ptile=x]" #request of memory and threads on the same host

rest of the script

module add my_programm
my_programm --number_of_threads x #do not forget this !



