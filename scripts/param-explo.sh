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
