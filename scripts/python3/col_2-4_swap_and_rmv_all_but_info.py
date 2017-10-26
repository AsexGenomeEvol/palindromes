#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 14:43:07 2017

@author: jklopfen
"""

#needed input file: bed_converted gff.file
import sys

#open file to be read as 1st argument
#second argument is the name of the output
with open(sys.argv[1], 'r') as x, open(sys.argv[2], 'w') as y:
    
    #Swap of the columns
    for line in x:
        columns=line.split('\t')[:4]
        columns[2],columns[3] = columns[3],columns[2]
        columns[1],columns[2] = columns[2],columns[1]
        columns[3] += '\n'
       
        #remove any info on the gene name
       # if ':' in columns[1]:
       #     columns[1] = columns[1][:columns[1].index(':')]
            
        #output generation
        y.write('\t'.join(columns))