#!/bin/bash
source ~/.bash_profile
mkdir e10_collinearity_files
for j in {1..5}
do
	echo "E-value cut-off: 10, match_size(s): $j" >> e10_mcs_explo.log
	MCScanX -a -e 10 -s $j ./$1 >> e10_mcs_explo.log
	echo -e "\n" >> e10_mcs_explo.log
	mv $1".collinearity" $1"_e10s"$j".collinearity"
	echo "palindromes_parser output:" >> mcs_explo.log
	python3 ../../palindromes_collinearity_parser.py $1"_e10s"$j".collinearity" >> e10_mcs_explo.log
	echo -e "\n" >> e10_mcs_explo.log
	mv *.collinearity e10_collinearity_files/
done
python3 ../../e10mcs-log-parser.py e10_mcs_explo.log

# This script will run MCScanX with a E-value cut-off of 10, MAX-GAPS setting of 25, and MATCH-SIZE setting increasing from 1 to 5. It creates a log of all bash outputs in e10_mcs_explo.log, which is then parsed to generate a .csv file countaining the number of collinear blocks and palindromes detected in each run.

# Each .collinearity file generated are moved to the folder "e10_collinearity_files".

# necessary argument is the MCScanX argument (blastp results and gene annotation, with a common name and .gff and .blast extensions)
