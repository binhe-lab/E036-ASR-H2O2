# goal: manually transfer list of genes from https://doi.org/10.1101/2021.09.28.462173 and annotate the list
# author: Bin He
# date: 2023-04-27

require(tidyverse)
# import the manually entered gene list
tmp.list = read_csv("../input/gene-list/c-glabrata-macrophage-induced-raw.csv") %>% 
  # append the CAGL0 prefix
  mutate(geneID = ifelse(is.na(geneID), NA, paste0("CAGL0", geneID)))

# headers for the CGD custom tab format
tmp.tab = c("geneID", "geneName", "aliases", "featureType", "chr", "start",
            "end", "strand", "CGDID", "CGDID2", "desc", "date", "seqDate",
            "blk1", "blk2", "blk3", "resName", "ortholog")

# I took the genes with only gene names and queried them against CGD to get the 
# gene IDs. The results are stored in input/gene-list/tmp
tmp.missingID = read_tsv("../input/gene-list/tmp/20230427-cgla-macrophage-gene-names-only-cgd-query.tsv")

# update the gene list with gene IDs
tmp.list <- rows_update(tmp.list, select(tmp.missingID, geneID, geneName), by = "geneName")

# I then submitted all the geneIDs to CGD and got the annotations
tmp.allcgd <- read_tsv("../input/gene-list/tmp/20230427-cgla-macrophage-all-gene-anno.tsv.gz", col_names = tmp.tab)

# append the gene names from the table
tmp.list <- rows_patch(tmp.list, select(tmp.allcgd, geneID, geneName), by = "geneID")

# merge the two tables
tmp.out <- left_join(tmp.list, select(tmp.allcgd, geneID, geneName, 
                                      chr, start, end, strand, desc, ortholog))

# for some reason, one gene was missing from the second CGD download
# update from the first
tmp.out <- rows_patch(tmp.out, select(tmp.missingID, geneID, geneName, 
                                      chr, start, end, strand, desc, ortholog))

# write the result to a file
write_csv(tmp.out, file = "../input/gene-list/c-glabrata-macrophage-induced.csv")
