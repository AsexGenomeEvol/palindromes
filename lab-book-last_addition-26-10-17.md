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

#### Comparison with the actual results from the paper

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