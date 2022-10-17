# goal: filter and select runs for _S. cerevisiae_ -Pi time course anlaysis
# author: Bin He
# date: 2022-10-07

# the csv file is downloaded from SRA run selector under two accessions: SRP113626 and SRP113638

require(tidyverse)

# import CSV
tb <- read_csv("Gurvich-2017-SraRunTable.csv")
dat <- tb %>% select(run = Run, name = `Library Name`, bases = Bases, exp = Experiment, sra = `SRA Study`)

dat %>% 
  filter(grepl("0_06mM", name), !grepl("recovery", name)) %>% 
  arrange(name) %>% 
  View()
