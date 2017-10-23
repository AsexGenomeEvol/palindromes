
MCScanX: tool used by the springtail and rotifer people to identify collinear genes block, and thus palindromes.

How to determine if collinear genes block are palindromic or not ? Tandem reapeats ?

[Reference](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3326336/)

MCScanX about and [download page](http://chibba.pgml.uga.edu/mcscan2/)

Can be installed on linux OS, should we install it on vital-it and try it ?

Data from the springtail people
[http://animalecology.labs.vu.nl/collembolomics/folsomia/data.php](http://animalecology.labs.vu.nl/collembolomics/folsomia/data.php)



# MCScanX

### 16/10/17 

: Goal is to use MCScanX (which seems to be the go-to package for palindrome detection)
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

[found a fix on package's github](https://github.com/wyp1125/MCScanX/issues/4):

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

then with the two files avaiable from the site (renamed original `fcand_swissprot.blastout` file to .blast for program requirements):
```
jklopfen@acer:~/palindromes/MCS-test$ ls fcand*
fcand.blast  fcand.gff
```
(in another folder where the programm is installed, for it weighs 241.5 MB and cannot be
in git repo)

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
: Results of "hail mary" try: 
html file is empty, collinearity results file is also empty the command obviously failed, need to better understand what I was actually doing and ask for help maybe.

: Possible causes: blastp file was not the one expected for the program, gene annotation file may contain duplicate, ...


### 18.10.17
Will try generating the blastp results out of the example command from the manual, problem was that there was no database for the genome, will use the command `makeblastdb` then use the "typical command".
```
makeblastdb -in fcand_genome.fa -dbtype prot
blastall -i fcand_genome.fa -d fcandgenome.fa -p blastp -e 1e-10 -b 5 -v 5 -m 8 -o fcan.blast
```
: This generates an error due to blastall not recognizing the database.

### 20.10.17
Will try generating the blastp results using similar option but with ncbi+ package 
(updated version)
Tried on my computer but the programm froze it => moving on vital-it
```
module add Blast/ncbi-blast/2.2.31+

bsub 'makeblastdb -in genome_database.fa -dbtype prot'
bsub -J blastp  'blastp -query fcand_genome.fa -db genome_database.fa -out fcand.blast -evalue 1e-10 -outfmt 6 -num_alignments 5'
```
: exit because of memory (add "-M 6000000" ?)

`TERM_MEMLIMIT: job killed after reaching LSF memory usage limit.
Exited with exit code 130.`

Seems that the command was wrong anyway, I tried aligning a genome on a genome using blastp, I need to align the proteins on the database of the genome.

`bsub 'makeblastdb -in proteins_database.fa -dbtype prot'`
> proteins_database.fa is just the genome with another name: named that way because of name conflict
> the genome database is then proteins_database.fa

Seems to be wrong, but trying anyway
Should I make a blast database out of the proteins (fcand_proteins.fa) ?
Should I change the type of database (-dbtype nucl) since the -in is a genome ?

#### launch of the blastp on vital-it:
bsub -J blastp  'blastp -query fcand_proteins.fa -db proteins_database.fa -out fcand.blast -evalue 1e-10 -outfmt 6 -num_alignments 5'

	21.10.17:

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

Will use this new blastp results to try the programm

### 22.10.17
####Second try of using the programm with the new .blast file

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
First try, using fcand_swissprot.blastout and fcand_genes.gff directly from their site:
`0 matches imported (243460 discarded)`
Second try, using self-blastp-generated fcand.blast and fcand_genes.gff:
`0 matches imported (93222 discarded)`
The gene anotations file is the same. How could fewer genes be discarded ?
Anyway, the programm doesn't find any matching genes/proteins from the given input.
Have to review the published article to get how they should match.. But I can try generating an actually accurate 'direct blastp results' using either another database, or with right parameters. Am I wrong on the link between the queries of blastp and the used database ?
	
		































