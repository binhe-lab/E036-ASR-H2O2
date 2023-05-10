## Goal
Predict Msn2/4 and Skn7 binding sites in the _CgCTA1_ promoter

## Steps
### Assembly PWMs for the TFs
We obtained PWMs from [Yetfasco](http://yetfasco.ccbr.utoronto.ca), which is based on _S. cerevisiae_ TFs. The main caveat is that if the _C. glabrata_ orthologs diverged in their specificities, using _S. cerevisiae_ matrices will result in false positives and false negatives. The reason to use this database is because of TF binding specificities are extremely well characterized and validated in _S. cerevisiae_, and also because previous studies have shown TF binding specificities are generally conserved across long evolutionary distances, and that it is very difficult for mutations to alter the binding specificity without destroying the binding function (PMID: 19841254). We also looked at a second database, [PathoYeastract](www.pathoyeastract.org), which contains _Candida_ species TF matrices. This dataset is much more limited and of greatly varying qualities. While a Msn4p motif was available there, it was mainly a consensus sequence (little quantitative information), and is based on microarray transcription data (Roetzer et al 2008). We didn't use this information for the prediction.

In the Yetfasco database, each TF has multiple motifs, ranked by various measures. We relied on their "Expert curation confidence", where the authors manually examined the evidence and assigned (usually) a single motif for each TF as the expert curated one. For Skn7, however, two discordant motifs were identified as expert curated, likely reflecting different binding modes (as monomer vs dimer). Msn2/4 has a single expert curated motif.

### Calculate _C. glabrata_ promoter sequence GC content
This will be used as the background model for the prediction. I downloaded the 1kb upstream sequences for the CBS138 genome from <pathoyeastract.org> and stored it in the `input` folder. To calculate the GC content, I used the following command:

```bash
gunzip -c pathoyeastract-c-glabrata-1kb-upstream.fasta.gz | infoseq -auto -only -name -length -pgc stdin > c-glabrata-1kb-upstream-gc-content.txt
```

I then calculated the mean and median GC% from the output using R. Mean = 38.7% and median = 39.9%

### Predicting BS in Yetfasco
I went back to Yetfasco and did the sequence scan using the Skn7 and Msn4 motifs selected, with a background A/T% = 1 - 0.39 = 0.61

The prediction result is stored in the `output` folder.

## Jinye's notes on her original analysis
1. Go to the YetFasco website, choose scan sequence: http://yetfasco.ccbr.utoronto.ca/scanSeqs.php

2, Scan using: scroll down the bar, choose Motif Set

3, Select TF Set: Expert Curated - no dubious

4, Enter DNA sequence: 1kb 5'UTR of CgCTA1

Then it will give u the TFs prediction output (based on S. cerevisiae)

Weak base pair
Y = C or T = pYrimidine. K = G or T = Keto. M = A or C = aMino. S = G or C = Strong base pair. W = A or T = Weak base pair.


PathoYeastract Yap1 binding site summary
TTACAAA
TTAGTAA


VTTACWAAB 
VDTASTAA


V: A/C/G
W: A/T
B: C/G/T

D: A/G/T
S: G/C

