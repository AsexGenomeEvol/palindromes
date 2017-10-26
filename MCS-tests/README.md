# Results of the differents attemps at reproducing the collinearity analysis of the springtail paper

MCScanX needs 2 input for the standard and easy use:

1. direct Blastp result of all against all
2. gene annotations file in BED format with a .gff extension

###Each folder contains the results of the attempts described in the table below:


#### Outcomes depending on different format for `fcand.gff`

| MCS-test-# | 1st col | 2nd col | 3rd col | 4th col  | other cols ? | generation | # of alignments | # of collinear genes | # of all genes | comments |
|:-------------:|:-------:|:---------:|:-------:|:---------:|:------------:|:--------------------------------------------:|:---------------:|:--------------------:|:--------------:|:-----------------------------------------------------------------------------------------:|
| **reference** | Sc* | start | end | ???????? | don't matter |  | **55 ?** | **883** | **27'594 ?** | -assuming that # of alignments refers to syntenic blocs -assuming the number of all genes |
| 3 | Sc | start | end | gene:info | + | g2b | 0 | 0 | 224917 | does not work, but generates 162 empty html files |
| 4 | Sc | gene:info | start | end | + | g2b + swap | 14 | 207 | 314090 | works: the program needs a gff file in that order |
| 5 | Sc | gene | start | end | + | g2b + swap + remove info | 32 | 609 | 57468 | contains lots of duplicates, thus the loss in # of all genes |
| 6 | Sc | gene | start | end | - | g2b + swap + remove-info + remove other cols | 32 | 609 | 57468 | no difference to #5: other cols don't matter |
| 7 | Sc | gene:info | start | end | - | g2b + swap + remove-other-cols | 14 | 207 | 314090 | no difference to #4: other cols don't matter |
8 | Sc | gene-PA | start | end | - | g2b + swap + remove-other-cols + remove aliases | **54** | **871** | **28734** | creates a .tandem file - closest to the actual results yet

Attempt 1 & 2 are not relevant. Read lab-book for more information.