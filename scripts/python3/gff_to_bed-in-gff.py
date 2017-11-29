#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov 13 18:17:38 2017

@author: jklopfen
"""
import sys

# Test of input file
if ".gff" not in sys.argv[1]:
    print("Input file must be of .gff extension")
    sys.exit()

# Generation of the name of the output file
in_name = sys.argv[1].split(".")
out_name = (".").join(in_name[0:len(in_name)-1]) + ".bed.gff"

#
#
#
#q = open("1_Tdi_b3v06.max.func.gff")
#f=[]
#t=[]
#for i in range(50):f.append(q.readline())
#    
#t.append(f[0].rstrip().split("\t"))
#for i in range(50):t.append(f[i].rstrip().split("\t"))
#
#t= f[1]
#t= t.rstrip()
#t= t.split("\t")
#
#name = t[-1].split(";")[3].split("=")[1]
#scaf = t[0]
#start = t[3]
#end = t[4]
#
#cc = ("\t").join(tmp)

# I/O
with open(sys.argv[1], 'r') as in_file,\
 open(out_name, 'w') as out_file:
     for line in in_file:
         if "Alias=" in line:
             tmp = line.rstrip()
             tmp = tmp.split("\t")
             if tmp[2]=="mRNA":
                  scaf = tmp[0]
                  start = tmp[3]
                  end = tmp[4]
                  name = tmp[-1].split(";")[3].split("=")[1]
                  to_write = [scaf,name,start,end+"\n"]
                  out_file.write(("\t").join(to_write))
                  
                  
print("The gff file in BED format was correctly generated.")