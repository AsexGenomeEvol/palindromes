
MCScanX: tool used by the springtail and rotifer people to identify collinear genes block, and thus palindromes.

How to determine if collinear genes block are palindromic or not ? Tandem repeats ?

[Reference](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3326336/)

MCScanX about and [download page](http://chibba.pgml.uga.edu/mcscan2/)

Can be installed on Linux OS, should we install it on vital-it and try it ?

Data from the springtail people
[http://animalecology.labs.vu.nl/collembolomics/folsomia/data.php](http://animalecology.labs.vu.nl/collembolomics/folsomia/data.php)



# MCScanX

### 16/10/17 

Goal is to use MCScanX (which seems to be the go-to package for palindrome detection)
to reproduce the results of the springtail paper using their data

## Installation	

ran into an error when installing MCScanX :


```
make
g++ struct.cc mcscan.cc read_data.cc out_utils.cc dagchainer.cc msa.cc permutation.cc -o MCScanX
msa.cc: In function ‘void msa_main(const char*)’:
msa.cc:289:22: error: ‘chdir’ was not declared in this scope
     if (chdir(html_fn)<0)
                      ^
makefile:2: recipe for target 'mcscanx' failed
make: *** [mcscanx] Error 1
```

[found a fix on package's GitHub](https://github.com/wyp1125/MCScanX/issues/4):

```
"if you are building on 64-bit you may need to add
	#include <unistd.h>
to msa.h, dissect_multiple_alignment.h, and detect_collinear_tandem_arrays.h"
```

ran into a new error when installing MCScanX :

```
jklopfen@acer:~/fp/MCScanX$ make
g++ struct.cc mcscan.cc read_data.cc out_utils.cc dagchainer.cc msa.cc permutation.cc -o MCScanX
g++ struct.cc mcscan_h.cc read_homology.cc out_homology.cc dagchainer.cc msa.cc permutation.cc -o MCScanX_h
g++ struct.cc dup_classifier.cc read_data.cc out_utils.cc dagchainer.cc cls.cc permutation.cc -o duplicate_gene_classifier
g++ dissect_multiple_alignment.cc -o downstream_analyses/dissect_multiple_alignment
g++ detect_collinear_tandem_arrays.cc -o downstream_analyses/detect_collinear_tandem_arrays
cd downstream_analyses/ && make
make[1]: Entering directory '/home/jklopfen/fp/MCScanX/downstream_analyses'
javac -g dot_plotter.java
make[1]: javac: Command not found
makefile:5: recipe for target 'dot_plotter.class' failed
make[1]: *** [dot_plotter.class] Error 127
make[1]: Leaving directory '/home/jklopfen/fp/MCScanX/downstream_analyses'
makefile:2: recipe for target 'mcscanx' failed
make: *** [mcscanx] Error 2"
```

fix: openjdk is not installed...
get installed package:

`dpkg --get-selections | less | grep 'jdk'`
```
openjdk-8-jre:amd64			          	install
openjdk-8-jre-headless:amd64			install
```

purge those packages:
`sudo apt-get purge openjdk-8-jre openjdk-8-jre-headless`
install new packages:
`sudo apt-get install openjdk-9-jre openjdk-9-jdk`

**successful installation** (yee but linux is tryhard if you're a newbie - took me way too much time)
now beginning to try using MCScanX from manual.

## Usage

MCScanX needs 2 input for the standard and easy use

1.  direct Blastp result (available from the data site, using swissprot as db): .blast file
2.  gene annotations (also available) : .gff file

try of generating the .blast file (following manual):

```
jklopfen@acer:~/palindromes/MCS-test$ blastall -i fcan_proteins.fa -d nr -p blastp -e 1e-10 -b 5 -v 5 -m 8 -o fcan.blast
Warning: [blastp] The parameter -num_descriptions is ignored for output formats > 4 . Use -max_target_seqs to control output
BLAST Database error: No alias or index file found for protein database [nr] in search path [/home/jklopfen/palindromes/MCS-test::]
Program failed, try executing the command manually.
```

then with the two files available from the site (renamed original `fcand_swissprot.blastout` file to .blast for program requirements):
```
jklopfen@acer:~/palindromes/MCS-test$ ls fcand*
fcand.blast  fcand.gff
```
(in another folder where the program is installed, for it weighs 241.5 MB and cannot be
in git repository)

```
jklopfen@acer:~/fp/MCScanX$ ./MCScanX MCS-test/fcand
Reading BLAST file and pre-processing
Generating BLAST list
0 matches imported (243460 discarded)
0 pairwise comparisons
0 alignments generated
Pairwise collinear blocks written to MCS-test/fcand.collinearity [1.195 seconds elapsed]
Writing multiple syntenic blocks to HTML files
Fcan01_Sc162.html
Done! [0.000 seconds elapsed]

jklopfen@acer:~/fp/MCScanX/MCS-test$ cat fcand.collinearity 
############### Parameters ###############
# MATCH_SCORE: 50
# MATCH_SIZE: 5
# GAP_PENALTY: -1
# OVERLAP_WINDOW: 5
# E_VALUE: 1e-05
# MAX GAPS: 25
############### Statistics ###############
# Number of collinear genes: 0, Percentage: 0.00
# Number of all genes: 1
##########################################
```
Results of "Hail Mary" try: 
html file is empty, collinearity results file is also empty the command obviously failed, need to better understand what I was actually doing and ask for help maybe.

Possible causes: blastp file was not the one expected for the program, gene annotation file may contain duplicate, ...


### 18.10.17
Will try generating the blastp results out of the example command from the manual, problem was that there was no database for the genome, will use the command `makeblastdb` then use the "typical command".
```
makeblastdb -in fcand_genome.fa -dbtype prot
blastall -i fcand_genome.fa -d fcandgenome.fa -p blastp -e 1e-10 -b 5 -v 5 -m 8 -o fcan.blast
```
This generates an error due to blastall not recognizing the database.

### 20.10.17
Will try generating the blastp results using similar option but with ncbi+ package 
(updated version)
Tried on my computer but the program froze it => moving on vital-it
```
module add Blast/ncbi-blast/2.2.31+

bsub 'makeblastdb -in genome_database.fa -dbtype prot'
bsub -J blastp  'blastp -query fcand_genome.fa -db genome_database.fa -out fcand.blast -evalue 1e-10 -outfmt 6 -num_alignments 5'
```
> exit because of memory (add "-M 6000000" ?)

`TERM_MEMLIMIT: job killed after reaching LSF memory usage limit.
Exited with exit code 130.`

Seems that the command was wrong anyway, I tried aligning a genome on a genome using blastp, I need to align the proteins on the database of the genome.

`bsub 'makeblastdb -in proteins_database.fa -dbtype prot'`
> proteins_database.fa is just the genome with another name: named that way because of name conflict the genome database is then proteins_database.fa

Seems to be wrong, but trying anyway.
Should I make a blast database out of the proteins (fcand_proteins.fa) ?
Should I change the type of database (-dbtype nucl) since the -in is a genome ?

#### launch of the blastp on vital-it:
```
bsub -J blastp  'blastp -query fcand_proteins.fa -db proteins_database.fa -out fcand.blast -evalue 1e-10 -outfmt 6 -num_alignments 5'
```

### 21.10.17:

The blastp results were generated and took more than 6 hour to be done. Is it normal ?

#### Job notification
```
Started at Fri Oct 20 15:33:00 2017
Results reported at Fri Oct 20 22:14:09 2017
Successfully completed.

Resource usage summary:

    CPU time :               22741.03 sec.
    Max Memory :             43.48 MB
    Average Memory :         34.06 MB
    Total Requested Memory : -
    Delta Memory :           -
    (Delta: the difference between total requested memory and actual max usage.)
    Max Swap :               206 MB

    Max Processes :          3
    Max Threads :            4
```

Will use this new blastp results to try the program.

### 22.10.17
#### Second try of using the programm with the new .blast file

``` 
jklopfen@acer:~/fp/MCScanX$ ./MCScanX MCS-test-2/fcand
Reading BLAST file and pre-processing
Generating BLAST list
0 matches imported (93222 discarded)
0 pairwise comparisons
0 alignments generated
Pairwise collinear blocks written to MCS-test-2/fcand.collinearity [0.962 seconds elapsed]
Writing multiple syntenic blocks to HTML files
Fcan01_Sc162.html
Done! [0.000 seconds elapsed]
```

Results: same failure. The results file (`fcand.collinearity`) generated by the MCScanX is still empty. But there is a difference, it seems that fewer genes were imported.

First try, using `fcand_swissprot.blastout` and `fcand_genes.gff` directly from their site:

`0 matches imported (243460 discarded)`

Second try, using self-blastp-generated `fcand.blast` and `fcand_genes.gff`:

`0 matches imported (93222 discarded)`

The gene annotations file is the same. 
How could fewer genes be discarded ? Do the self-generated blastp actually contains fewer proteins/genes ?

Anyway, the program doesn't find any matching genes/proteins from the given input.
Have to review the published article to get how they should match.. But I can try generating an actually accurate 'direct blastp results' using either another database, or with right parameters. Am I wrong on the link between the queries of blastp and the used database ?

### 24.10.17

After talking with Kamil, I think I figured out what I was doing wrong.
Generating the direct blastp results is actually aligning the proteins on the proteins as database. What I took as the database for the blastp was the genome, with the parameters `-dbtype prot`, which is irrelevant/incoherent. What needs to be done is a blastp with the proteins as query and database.

#### Generation of the right blast database.

```
#!/bin/bash
#BSUB -L /bin/bash
#BSUB -J makeblastdb
#BSUB -o fcand_makeblastdb.log
#BSUB -e fcand_makeblastdb_error.log
#BSUB -N

module add Blast/ncbi-blast/2.2.31+
makeblastdb -in fcand_proteins_database.fa -dbtype prot
```
> script is stored in `scripts` folder under the name `fcand_makeblastdb.sh`

#### Generation of the right blastp results

``` bash
#!/bin/bash
#BSUB -L /bin/bash
#BSUB -J blastp
#BSUB -n 16
#BSUB -R "span[ptile=16]"
#BSUB -N

module add Blast/ncbi-blast/2.2.31+

blastp -query fcand_proteins.fa -db fcand_proteins_database.fa \
-out fcand.blast -evalue 1e-10 -outfmt 6 -num_alignments 5 -num_threads 16
```
> script is stored in `scripts` folder under the name `fcand_blastp.sh`

Now waiting for the results to be generated. This time I used 16 cores, so I hope it will take less than 6 hour.


#### Job notification

``` bash
Successfully completed.

Resource usage summary:

    CPU time :               12056.91 sec.
    Max Memory :             79.58 MB
    Average Memory :         55.58 MB
    Total Requested Memory : -
    Delta Memory :           -
    (Delta: the difference between total requested memory and actual max usage.)
    Max Swap :               1879 MB

    Max Processes :          4
    Max Threads :            21
```

The job took 30 minutes, which is really good considering the last attempt that took 6 hour.
```
Started at Tue Oct 24 17:47:11 2017
Results reported at Tue Oct 24 18:17:31 2017
```

Will launch MCScanX using this last blastp results, which seems to be accurately generated.

#### Launch of 3rd try

``` bash 
$ MCScanX ./fcand
Reading BLAST file and pre-processing
Generating BLAST list
0 matches imported (93222 discarded)
0 pairwise comparisons
0 alignments generated
Pairwise collinear blocks written to ./fcand.collinearity [1.412 seconds elapsed]
Writing multiple syntenic blocks to HTML files
Done! [0.001 seconds elapsed]
```
Nothing new here. The error is still the same, but we have the complete set of genes back, which is a good sign.

When looking in the manual, it is said that the program requires a .gff file **but in bed format** and not in the gff (assuming gffv3) format, which I assume is to be the format of `fcand_genes.gff`available on the [sprigtail data site](http://animalecology.labs.vu.nl/collembolomics/folsomia/data.php).

Therefore, `fcand_genes.gff` needs to be converted to bed, for which the differences can be found [here](https://genome.ucsc.edu/FAQ/FAQformat.html#format3). There is an existing tool that provide bed-format utilities, called ["BEDOPS"](https://bedops.readthedocs.io/en/latest/index.html). This program contains a script called `gff2bed` which converts the format from gff to bed (extended bed format, which contain all the features of gffv3 format). 

I've downloaded the latest release (2.4.29) [here](https://github.com/bedops/bedops/releases/download/v2.4.29/bedops_linux_x86_64-v2.4.29.tar.bz2) (direct download link) and installed it locally on my machine, following the [site instruction](https://bedops.readthedocs.io/en/latest/content/installation.html#linux).

Conversion is done by calling this line:
`gff2bed < fcand_genes.gff > fcand_genes.bed`

Will launch MCScanX using this new `fcand_genes.bed` file, renamed `fcand.gff` for program requirements (which I admit is actually confusing from the developers).


#### Launch of 4th try

``` bash
jklopfen@acer:~/fp/MCScanX/MCS-test-3$ ../MCScanX ./fcand
Reading BLAST file and pre-processing
Generating BLAST list
0 matches imported (93222 discarded)
0 pairwise comparisons
0 alignments generated
Pairwise collinear blocks written to ./fcand.collinearity [2.115 seconds elapsed]
Writing multiple syntenic blocks to HTML files
Fcan01_Sc001.html
	.
[lines omitted]
	.
Fcan01_Sc162.html
Done! [0.452 seconds elapsed]
```

Results: all the genes are still discarded. However, this time not only one html was produced, but 162, assuming one for each scaffold. Also, the output result have a difference:

```
$ cat fcand.collinearity 
############### Parameters ###############
# MATCH_SCORE: 50
# MATCH_SIZE: 5
# GAP_PENALTY: -1
# OVERLAP_WINDOW: 5
# E_VALUE: 1e-05
# MAX GAPS: 25
############### Statistics ###############
# Number of collinear genes: 0, Percentage: 0.00
# Number of all genes: 224917
##########################################
```
This time the program recognized all the genes. The new error seems to be linked to matching proteins name with gene id. If we look at the format of the different files and compare them to the example given by the developers in the program folder `MCScanX/data/` we can see that after conversion, the column `seq-id` is not in the right place. 

Original `fcand_genes.gff`:
```
Fcan01_Sc001	maker	exon	15223027	15224536	.	+	.	ID=Fcan01_02451-PA:exon:0;Parent=Fcan01_02451-PA;
Fcan01_Sc001	maker	exon	15224668	15230603	.	+	.	ID=Fcan01_02451-PA:exon:1;Parent=Fcan01_02451-PA;
Fcan01_Sc001	maker	exon	15232085	15232125	.	+	.	ID=Fcan01_02451-PA:exon:2;Parent=Fcan01_02451-PA;
Fcan01_Sc001	maker	exon	15232604	15232712	.	+	.	ID=Fcan01_02451-PA:exon:3;Parent=Fcan01_02451-PA;
```

bed format converted original file `fcand_genes.bed`:
```
jklopfen@acer:~/fp/MCScanX/MCS-test-3$ head fcand.gff
Fcan01_Sc001	43	168	Fcan01_00001-PA:cds	.	-	maker	CDS	2	ID=Fcan01_00001-PA:cds;Parent=Fcan01_00001-PA;
Fcan01_Sc001	43	168	Fcan01_00001-PA:exon:759	.	-	maker	exon	.	ID=Fcan01_00001-PA:exon:759;Parent=Fcan01_00001-PA;
Fcan01_Sc001	43	5998	Fcan01_00001	.	-	maker	gene	.	ID=Fcan01_00001;Name=Fcan01_00001;Alias=maker-Fcan01_Sc001-augustus-gene-0.436;Note=Similar to Arrdc2: Arrestin domain-containing protein 2 (Mus musculus);
```
> this format is actually bed-extended format, sorted (which is done by default when using `gff2bed` unless the `--do-not-sort` option is used).


bed format of `MCScanX/data/at.gff`:
```
jklopfen@acer:~/fp/MCScanX/data$ head at.gff
at1	AT1G01010	3631	5899
at1	AT1G01020	5928	8737
at1	AT1G01030	11649	13714
at1	AT1G01040	23146	31227
```

We can see that there is an obvious difference: in the bed-converted gff file, the gene name is at the 4th column instead of the 2nd column, and additionally there is after more information after the character `:` (eg. `Fcan01_00001-PA:exon:759`). 

I will need to review that reference article to know if additionnal information in the gene name is allowed or not, and if other column are allowed, or if the program strictly require a 4-tab delimited input as gff file. This would actually be a gene annotation file with an `.gff` extension, but in strict BED4 format... This is again source of confusion.

Out of a quick review of the [reference](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3326336/), there is no mention about any usage of MCScanX, other than it was simplified compared to the usage of MCScan. Therefore I will test myself the different interrogations mentioned above.

### 25.10.17

#### Swap of the column 2 and 4 in the `gff2bed` converted original file

In order to do so I wrote a short python3 script `col_2-4_swapper.py`:

```python3
import sys

with open(sys.argv[1], 'r') as x, open(sys.argv[2], 'w') as y:
    for line in x:
        columns=line.split('\t')
        columns[2],columns[3] = columns[3],columns[2]
        columns[1],columns[2] = columns[2],columns[1]
        y.write('\t'.join(columns))
```
> this script take two arguments, first is the file to be read, second is the name of the output file.

Calling of this script
`$python3 col_2-4_swapper.py fcand.gff new_fcand.gff`

#### Launch of MCScanX:
```
jklopfen@acer:~/fp/MCScanX/MCS-test-4$ ../MCScanX ./new_fcand
Reading BLAST file and pre-processing
Generating BLAST list
54507 matches imported (38715 discarded)
2462 pairwise comparisons
14 alignments generated
Pairwise collinear blocks written to ./new_fcand.collinearity [6.143 seconds elapsed]
Writing multiple syntenic blocks to HTML files
Fcan01_Sc001.html
	.
[lines omitted]
	.
Fcan01_Sc162.html
```
**First success !**


Head of the generated result `new_fcand.collinearity`:

```
jklopfen@acer:~/fp/MCScanX/MCS-test-4$ head new_fcand.collinearity 
############### Parameters ###############
# MATCH_SCORE: 50
# MATCH_SIZE: 5
# GAP_PENALTY: -1
# OVERLAP_WINDOW: 5
# E_VALUE: 1e-05
# MAX GAPS: 25
############### Statistics ###############
# Number of collinear genes: 207, Percentage: 0.07
# Number of all genes: 314090
```
Having the program to actually run is great, but there is problems:
1. The number of alignments is not the same. If assuming that these represent the number of syntenic blocks identified, 14 is only a portion of the **55** identified in the paper.
2. The number of all genes is not the same as in the paper (27'594). 314090 is way too much genes taken into account.
3. The number of collinear genes is not the same as in the paper (883). 207 is too little collinear genes. 

I will test different format of tab-delimited columns for the gff file.

#### Outcomes depending on different format for `fcand.gff`

| MCS-test-# | 1st col | 2nd col | 3rd col | 4th col  | other cols ? | generation | # of alignments | # of collinear genes | # of all genes | comments |
|:-------------:|:-------:|:---------:|:-------:|:---------:|:------------:|:--------------------------------------------:|:---------------:|:--------------------:|:--------------:|:-----------------------------------------------------------------------------------------:|
| **reference** | Sc* | start | end | ???????? | don't matter |  | **55 ?** | **883** | **27'594 ?** | -assuming that # of alignments refers to syntenic blocs -assuming the number of all genes |
| 3 | Sc | start | end | gene:info | + | g2b | 0 | 0 | 224917 | does not work, but generates 162 empty html files |
| 4 | Sc | gene:info | start | end | + | g2b + swap | 14 | 207 | 314090 | works: the program needs a gff file in that order |
| 5 | Sc | gene | start | end | + | g2b + swap + remove info | 32 | 609 | 57468 | contains lots of duplicates, thus the loss in # of all genes |
| 6 | Sc | gene | start | end | - | g2b + swap + remove-info + remove other cols | 32 | 609 | 57468 | no difference to #5: other cols don't matter |
| 7 | Sc | gene:info | start | end | - | g2b + swap + remove-other-cols | 14 | 207 | 314090 | no difference to #4: other cols don't matter |

### 26.10.17

Obviously each gene have to have one particular line of the lines that are showed below:

| Scaffold # | gene name | start | end |
|--------------|--------------------------------|-------|------|
| Fcan01_Sc001 | Fcan01_00001-PA:cds | 43 | 168 |
| Fcan01_Sc001 | Fcan01_00001-PA:exon:759 | 43 | 168 |
| Fcan01_Sc001 | Fcan01_00001 | 43 | 5998 |
| Fcan01_Sc001 | Fcan01_00001-PA | 43 | 5998 |
| Fcan01_Sc001 | Fcan01_00001-PA:cds | 3926 | 4233 |
| Fcan01_Sc001 | Fcan01_00001-PA:exon:758 | 3926 | 4233 |
| Fcan01_Sc001 | Fcan01_00001-PA:cds | 4385 | 4568 |
| Fcan01_Sc001 | Fcan01_00001-PA:exon:757 | 4385 | 4568 |
| Fcan01_Sc001 | Fcan01_00001-PA:cds | 4910 | 5060 |
| Fcan01_Sc001 | Fcan01_00001-PA:exon:756 | 4910 | 5060 |
| Fcan01_Sc001 | Fcan01_00001-PA:cds | 5173 | 5418 |
| Fcan01_Sc001 | Fcan01_00001-PA:exon:755 | 5173 | 5418 |
| Fcan01_Sc001 | Fcan01_00001-PA:cds | 5787 | 5905 |
| Fcan01_Sc001 | Fcan01_00001-PA:exon:754 | 5787 | 5998 |
| Fcan01_Sc001 | Fcan01_00001-PA:five_prime_utr | 5905 | 5998 |

Since all the lines describing cds and exons are only part of the gene, it makes sense to remove them. And since all the proteins are named *Fcan_##_#####-PA*, the line of the genes without the "-PA" (eg. `| Fcan01_Sc001 | Fcan01_00001 | 43 | 5998 |`) will not match with the blastp results. After trying, just to be sure, there is indeed no matches if the "-PA" is missing.

Therefore I will run the program with strict "gene-PA" lines only as gene annotation file input.

#### Using only strict gene-PA rows 

With this format, each gene has a single line that looks like:

| Scaffold # | gene name | start | end |
|--------------|--------------------------------|-------|------|
| Fcan01_Sc001 | Fcan01_00001-PA | 43 | 5998 |

Running this gives that output:

| MCS-test-# | 1st col | 2nd col | 3rd col | 4th col  | other cols ? | generation | # of alignments | # of collinear genes | # of all genes | comments |
|:-------------:|:-------:|:---------:|:-------:|:---------:|:------------:|:--------------------------------------------:|:---------------:|:--------------------:|:--------------:|:-----------------------------------------------------------------------------------------:|
8 | Sc | gene-PA | start | end | - | g2b + swap + remove-other-cols + remove aliases | **54** | **871** | **28734** | creates a .tandem file - closest to the actual results yet
| **reference** | Sc* | ????? | start | end | don't matter | ----------------- | **55 ?** | **883** | **27'594 ?** | -assuming that # of alignments refers to syntenic blocs -assuming the number of all genes |

#### Comparison with the actual results form the paper

- number of alignments: 54/55
- number of collinear genes: 871/883
- number of all genes: 28'734/27'594
- *presumed* number of palindromes detected: 10/11

#### Possible issues:

- #### Number of all gene: 
I assumed that the number of all gene from the paper was 27'594, based on the following quote: 
> We observed 883 (3.2% of all genes) collinear genes, which were organized in 55 syntenic blocks.

And thus 883/0.032 = 27593.75, so 27'594 genes or protein were taken in account, as there is the same number in both the gene annotations file and `fcan_proteins.fa`:
```
jklopfen@acer:~/palindromes/data$ wc -l pa-only_fcand.gff 
28734 pa-only_fcand.gff
jklopfen@acer:~/palindromes/data$ grep ">" fcan_proteins.fa | wc -l
28734
```
So they have probably used fewer genes than there is in `fcand_genes.gff`, exactly 1140 genes less.

**Were the genes trimmed before collinearity analysis ?**

Removing genes with too little scores, or too little nucleotide sequence, known duplications with different names, or ..?

**Is the gene annotation file *exactly* the same they have used for their analysis ?**

They could have improved their gene annotations and published the latest version on their website, which could be different from the version used for their analysis in the publication. Although, based on the fact that they made their data available to everybody, I assume that it is *meant* for full disclosure and research reproduction. Therefore I don't think that they've changed the data in anyway.

- #### Different MCScanX parameters
**Were they using parameters that could filter out some genes when using MCScanX ?**

Pure assumption, I do not know at this point if this is possible. Will check.

***

Regardless, at this point, I've run out of ideas on how to improve the input to get exactly the same outcomes as the paper. Nonetheless, the latest outcomes are very closed from what they said have gotten. Write to them, explain the differences obtained when trying to reproduce and ask for the reasons behind could be a solution to resolve the differences. (Feels like giving up though.)

From now on, unless an epiphany occurs, I will describe and test several things on palindromes detection, based on the last results generated.


 