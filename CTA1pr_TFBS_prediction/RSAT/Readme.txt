RSAT - matrix_scan full option
0. sequence - fasta
	CgCTA1pr 1kb upstream of the CDS

1. matrix - tab
	For matrices extracted from the YeTFasCO database, matrices are in tab format, with // to separate each matrix 
		(ranked by the total score, 
			File: 
				Yap1TFBS_YeTFasCO_tab: Yap1 8th highest total score rank and a EMSA PFM;
				Msn4TFBS_YeTFasCO_tab: Msn4 4th highest total score rank
				Skn7TFBS_YeTFasCO_tab: Skn7 6th highest total score rank and 2 EMSA PFM)
	For those from the Pathoyeast database, matrices are in TRANSFAC format, no CgSkn7 info

2. background model organism - C. glabrata

3. P-value (Upper threshold: 1e-3: one false positive prediction is expected in every kilobase) [most important]

4. Other settings: default

5. Output file: 
	Matrix_scan....
	RSAT_table: summary of the table info


