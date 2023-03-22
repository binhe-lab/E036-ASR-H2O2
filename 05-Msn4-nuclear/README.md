``` r
require(tidyverse)
```

    ## Loading required package: tidyverse

    ## ── Attaching packages ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0     ✔ purrr   0.3.4
    ## ✔ tibble  3.1.8     ✔ dplyr   1.0.9
    ## ✔ tidyr   1.2.1     ✔ stringr 1.4.1
    ## ✔ readr   2.1.2     ✔ forcats 0.5.2
    ## ── Conflicts ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
require(cowplot)
```

    ## Loading required package: cowplot

## Goal

Use fluorescent microscopy to track Msn4 (and Msn2) nuclear localization
in both *S. cerevisiae* and *C. glabrata* under different conditions.

## *rim15∆* effect on CgMsn4<sup>nuc</sup>

### data

| Date_from  | Date_to    | Strains    | Experiment                             |
|:-----------------|:-----------------|:-----------------|:-----------------|
| 2022/11/15 | 2022/11/17 | wt, rim15∆ | determine Msn4<sup>nuc</sup> under -Pi |

``` r
dat.f7 <- read_tsv("input/20221117-rim15-noPi-raw.tsv", col_types = cols())
```

### summary and stat test

1.  sum the total number of nuc and cyto cells for the same strain
    across replicates
2.  calculate the percentage of Msn4<sup>nuc</sup> cells in each
    genotype
3.  conduct Fisher’s exact test to determine if the difference between
    strains under -Pi or rich conditions are significant

``` r
sum.f7 <- dat.f7 %>% 
  group_by(treatment, genotype) %>% 
  summarize(across(nuc:cyto, sum), .groups = "drop") %>% 
  mutate(percent = scales::percent(nuc / (nuc+cyto)))
sum.f7
```

    ## # A tibble: 4 × 5
    ##   treatment genotype   nuc  cyto percent
    ##   <chr>     <chr>    <dbl> <dbl> <chr>  
    ## 1 0Pi       rim15_ko    58   133 30.4%  
    ## 2 0Pi       wt         141    96 59.5%  
    ## 3 Ctrl      rim15_ko    15   225 6.2%   
    ## 4 Ctrl      wt          19   174 9.8%

Fisher’s exact test comparing *rim15∆* vs wild type under 0Pi condition

``` r
tmp <- sum.f7 %>% 
  filter(treatment == "0Pi") %>% 
  select(genotype, nuc, cyto) %>% 
  column_to_rownames(var = "genotype") %>% 
  as.matrix()
fisher.test(tmp)
```

    ## 
    ##  Fisher's Exact Test for Count Data
    ## 
    ## data:  tmp
    ## p-value = 2.133e-09
    ## alternative hypothesis: true odds ratio is not equal to 1
    ## 95 percent confidence interval:
    ##  0.1942704 0.4528026
    ## sample estimates:
    ## odds ratio 
    ##  0.2978022

Fisher’s exact test comparing *rim15∆* vs wild type under rich media
condition

``` r
tmp <- sum.f7 %>% 
  filter(treatment == "Ctrl") %>% 
  select(genotype, nuc, cyto) %>% 
  column_to_rownames(var = "genotype") %>% 
  as.matrix()
fisher.test(tmp)
```

    ## 
    ##  Fisher's Exact Test for Count Data
    ## 
    ## data:  tmp
    ## p-value = 0.2083
    ## alternative hypothesis: true odds ratio is not equal to 1
    ## 95 percent confidence interval:
    ##  0.2802773 1.3105351
    ## sample estimates:
    ## odds ratio 
    ##  0.6112424

> The difference under 0Pi is significant, but not under rich media
> condition.

## Msn4<sup>nuc</sup> in *S. cerevisiae* vs *C. glabrata* under different stresses

### data

``` r
dat.f5 <- read_tsv("input/20230322-wildtype-multiple-conditions-raw.tsv", col_types = cols())
dat.f5 %>% group_by(species, treatment) %>% 
  summarize(n_days = length(unique(date)), 
            n_pics = length(unique(picture_name)), 
            total_cells = sum(total_fluorescent_cell), 
            .groups = "drop") %>% 
  arrange(treatment, species)
```

    ## # A tibble: 9 × 5
    ##   species       treatment n_days n_pics total_cells
    ##   <chr>         <chr>      <int>  <int>       <dbl>
    ## 1 C. glabrata   0Glu           2      9         106
    ## 2 S. cerevisiae 0Glu           1      8          63
    ## 3 C. glabrata   0Pi            5     10         135
    ## 4 S. cerevisiae 0Pi            2     12         133
    ## 5 C. glabrata   Ctrl           5     22         164
    ## 6 S. cerevisiae Ctrl           2      8          86
    ## 7 S. cerevisiae H2O2           1      1          53
    ## 8 C. glabrata   Rapa           2     16         110
    ## 9 S. cerevisiae Rapa           1     15         131

### summary and stat test

1.  sum the total number of nuc and cyto cells for the same strain
    across replicates
2.  calculate the percentage of Msn4<sup>nuc</sup> cells in each
    genotype
3.  conduct Fisher’s exact test to determine if the difference between
    strains under -Pi or rich conditions are significant

``` r
sum.f5 <- dat.f5 %>% 
  group_by(treatment, species) %>% 
  summarize(across(nuc:cyto, sum), .groups = "drop") %>% 
  mutate(percent = scales::percent(nuc / (nuc+cyto)))
sum.f5
```

    ## # A tibble: 9 × 5
    ##   treatment species         nuc  cyto percent
    ##   <chr>     <chr>         <dbl> <dbl> <chr>  
    ## 1 0Glu      C. glabrata      81    25 76.42% 
    ## 2 0Glu      S. cerevisiae    46    17 73.02% 
    ## 3 0Pi       C. glabrata      63    72 46.67% 
    ## 4 0Pi       S. cerevisiae     5   128 3.76%  
    ## 5 Ctrl      C. glabrata       3   161 1.83%  
    ## 6 Ctrl      S. cerevisiae     1    85 1.16%  
    ## 7 H2O2      S. cerevisiae    46     7 86.79% 
    ## 8 Rapa      C. glabrata      79    31 71.82% 
    ## 9 Rapa      S. cerevisiae    19   112 14.50%

Fisher’s exact test comparing *rim15∆* vs wild type under 0Pi condition

``` r
my_fisher_test <- function(data, treat){
  #sprintf("Testing %s", treat)
  tmp <- data %>% 
    filter(treatment == treat) %>% 
    select(species, nuc, cyto) %>% 
    column_to_rownames(var = "species") %>% 
    as.matrix()
  fisher.test(tmp)
}
```

``` r
treatments <- setdiff(sum.f5$treatment, "H2O2")
FET.res <- sapply(treatments, function(x) my_fisher_test(sum.f5, x)) %>% 
  t() %>% as.data.frame() %>% 
  rownames_to_column(var = "treatment") %>% 
  as_tibble() %>% 
  select(treatment, p.value, odds.ratio = estimate) %>% 
  unnest(p.value:odds.ratio) %>% 
  mutate(p.adj = p.adjust(p.value, method = "bonf"))
FET.res %>% select(treatment, odds.ratio, p.value, p.adj) %>% arrange(desc(odds.ratio))
```

    ## # A tibble: 4 × 4
    ##   treatment odds.ratio  p.value    p.adj
    ##   <chr>          <dbl>    <dbl>    <dbl>
    ## 1 0Pi            22.2  2.07e-17 8.28e-17
    ## 2 Rapa           14.8  5.54e-20 2.22e-19
    ## 3 Ctrl            1.58 1   e+ 0 1   e+ 0
    ## 4 0Glu            1.20 7.13e- 1 1   e+ 0
