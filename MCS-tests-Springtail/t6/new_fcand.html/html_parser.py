#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 18:29:07 2017

@author: jklopfen
"""

import sys

with open(sys.argv[1], 'r') as x, open(sys.argv[2], 'w') as y:
    for line in x:
        if '<td>0</td>' not in line:
            y.write(line)
            
        
