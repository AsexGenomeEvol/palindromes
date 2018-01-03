#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import sys

## Testing
#f = open("mcs_explo.log", "r")
#q = []
#for i in range(50): q.append(f.readline())
#t = q[10].rstrip()
#tt = t.split(" ");tt
#max_gap = tt[2]
#match_size = tt[4]
#tt[4] = "SSS"


# Test of input file
if ".log" not in sys.argv[1]:
    print("Input file must be of .log extension")
    sys.exit()


# Generation of the name of the output file
#in_name = sys.argv[1].split(".")
out_name = "e10_mcs_explo.csv"


with open(sys.argv[1], 'r') as in_file,\
 open(out_name, 'w') as out_file:
     
     # header generation
     out_file.write("alignments,palindromes,match_size\n")
     
     # log parsing
     for line in in_file:
         block_end = False
         tmp = []
         if "match_size" in line:
             tmp = line.rstrip().split(" ")
             match_size = tmp[4]
         if "alignments" in line:
             tmp = line.rstrip().split(" ")
             alignments = tmp[0]
         if "identified" in line:
             tmp = line.rstrip().split(" ")
             palindromes = tmp[6]
             block_end = True
         if (block_end):
             towrite=[alignments,palindromes,match_size + "\n"]
             out_file.write((",").join(towrite))
             
