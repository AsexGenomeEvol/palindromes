#!/bin/bash
for i in 0 1 5
do
	for j in {1..5}
	do
		echo "max gap(m): $i match_size(s): $j" >> mcs_explo.log
		MCScanX -a -m $i -s $j ./$1 >> mcs_explo.log
		echo -e "\n" >> mcs_explo.log
		mv $1".collinearity" $1"_m"$i"s"$j".collinearity"
		echo "palindromes_parser output:" >> mcs_explo.log
		python3 palindromes_collinearity_parser.py $1"_m"$i"s"$j".collinearity" >> mcs_explo.log
		echo -e "\n" >> mcs_explo.log
	done
done

# This script will run MCScanX with a default E-value cut-off, MAX-GAPS setting of 0, 1 and 5, and MATCH-SIZE setting increasing from 1 to 5. It creates a log of all bash outputs in mcs_explo.log, which can be parsed to generate a .csv file countaining the number of collinear blocks and palindromes detected in each run (15 in total).

# Each .collinearity file generated are renamed to a filename containing the parameters used for the run.

# Necessary argument is the MCScanX argument (blastp results and gene annotation, with a common name and .gff and .blast extensions)
