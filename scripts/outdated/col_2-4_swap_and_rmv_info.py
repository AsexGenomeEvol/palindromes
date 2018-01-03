#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 14:43:07 2017

@author: jklopfen
"""

import sys

with open(sys.argv[1], 'r') as x, open(sys.argv[2], 'w') as y:
    for line in x:
        columns=line.split('\t')
        columns[2],columns[3] = columns[3],columns[2]
        columns[1],columns[2] = columns[2],columns[1]
        if ':' in columns[1]:
            columns[1] = columns[1][:columns[1].index(':')]
        y.write('\t'.join(columns))