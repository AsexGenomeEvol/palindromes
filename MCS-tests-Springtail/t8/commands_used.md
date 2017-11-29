## Commands to generate this attempt

`grep -e "-PA" new_fcand.gff | grep -v -e ":" > parsed_fcand.gff`

with 

| MCS-test-# | 1st col | 2nd col | 3rd col | 4th col  | other cols ? | generation | # of alignments | # of collinear genes | # of all genes | comments |
|:-------------:|:-------:|:---------:|:-------:|:---------:|:------------:|:--------------------------------------------:|:---------------:|:--------------------:|:--------------:|:-----------------------------------------------------------------------------------------:|
7 | Sc | gene:info | start | end | - | g2b + swap + remove-other-cols | 14 | 207 | 314090 | no difference to #4: other cols don't matter

then the parsed .gff looks like

```
jklopfen@acer:~/fp/MCScanX/MCS-test-8$ head parsed_fcand.gff
Fcan01_Sc001	Fcan01_00001-PA	43	5998
Fcan01_Sc001	Fcan01_00002-PA	7791	8360
Fcan01_Sc001	Fcan01_00003-PA	10747	13085
Fcan01_Sc001	Fcan01_00004-PA	13573	15596
Fcan01_Sc001	Fcan01_00005-PA	19716	23405
```

and the new entry in the table of attempts is:

| MCS-test-# | 1st col | 2nd col | 3rd col | 4th col  | other cols ? | generation | # of alignments | # of collinear genes | # of all genes | comments |
|:-------------:|:-------:|:---------:|:-------:|:---------:|:------------:|:--------------------------------------------:|:---------------:|:--------------------:|:--------------:|:-----------------------------------------------------------------------------------------:|
8 | Sc | gene-PA | start | end | - | g2b + swap + remove-other-cols + remove aliases | **54** | **871** | **28734** | creates a .tandem file - closest to the actual results yet