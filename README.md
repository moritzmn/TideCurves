<!-- README.md is generated from README.Rmd. Please edit that file -->

# TideCurves

This packages provides functions for synthesizing tide curves. Ideally
you collected data for 19 years for a fixed location. Shorter periods
are also possible and will produce good results.

The functions are based on the Harmonic Representation of Inequalities
(HRoI) and not on the harmonic method. Please consult the following
links for a detailed description of HRoI:

  - <https://www.bsh.de/DE/PUBLIKATIONEN/_Anlagen/Downloads/Meer_und_Umwelt/Berichte-des-BSH/Berichte-des-BSH_50_de.pdf?__blob=publicationFile&v=13/>

  - <https://doi.org/10.5194/os-15-1363-2019>

## Why should i use this package?

You should use this package for producing tide curves from past data.

## How do i use it?

Import your data set first and transform it to a readable form. See
attached data ‘observation’ for an example data frame.

``` r
library(TideCurves)
tideObservation[1:10, ]
#>    observation_date observation_time height
#> 1        2015/06/01         00:00:00  6.570
#> 2        2015/06/01         00:30:00  6.528
#> 3        2015/06/01         01:00:00  6.410
#> 4        2015/06/01         01:30:00  6.200
#> 5        2015/06/01         02:00:00  5.893
#> 6        2015/06/01         02:30:00  5.556
#> 7        2015/06/01         03:00:00  5.248
#> 8        2015/06/01         03:30:00  4.970
#> 9        2015/06/01         04:00:00  4.745
#> 10       2015/06/01         04:30:00  4.550

sapply(tideObservation, typeof)
#> observation_date observation_time           height 
#>      "character"      "character"         "double"
```

AS of version 0.0.5 you have the option to build a model of class
“tidecurve” and then synthesize different periods using this model.
The “TideCurve” functions on the other hand builds and synthesizes in
one go. The different options are explained below.

### TideCurve

You can now use your data as input for the function ‘TideCurve’. Setting
the periods for analyzing and synthesizing and wait for the table to be
produced. Afterwards you can compute the differences between the
observed data and lunar and solar tide curves

``` r
mytidecurve <- TideCurve(dataInput = tideObservation, asdate = "2015/12/06",
             astime = "00:00:00",      aedate = "2015/12/31",
             aetime = "23:30:00",      ssdate = "2015/12/17",
             sstime = "00:00:00",      sedate = "2015/12/31",
             setime = "23:30:00")

mydifferences <- ResCurve(tcData = mytidecurve, obsData = tideObservation)
```

``` r
mydifferences
#> $lunar.res
#>       numm imm tmmttmond dmheight numm_imm           date_time    time1
#>   1: 23275   1  42352.70 5.833343  23275_1 2015/12/16 16:46:55 42352.70
#>   2: 23275   2  42352.72 5.554384  23275_2 2015/12/16 17:17:58 42352.72
#>   3: 23275   3  42352.74 5.137982  23275_3 2015/12/16 17:49:02 42352.74
#>   4: 23275   4  42352.76 4.819359  23275_4 2015/12/16 18:20:05 42352.76
#>   5: 23275   5  42352.79 4.529649  23275_5 2015/12/16 18:51:08 42352.79
#>  ---                                                                   
#> 716:    NA  NA        NA       NA 23289_44 2016/01/01 02:48:45 42368.12
#> 717:    NA  NA        NA       NA 23289_45 2016/01/01 03:19:48 42368.14
#> 718:    NA  NA        NA       NA 23289_46 2016/01/01 03:50:51 42368.16
#> 719:    NA  NA        NA       NA 23289_47 2016/01/01 04:21:54 42368.18
#> 720:    NA  NA        NA       NA 23289_48 2016/01/01 04:52:57 42368.20
#>      lsheight     i  k prediction_date prediction_time        res
#>   1: 5.986578 23275  1      2015/12/16        16:46:55 -0.1532351
#>   2: 5.729373 23275  2      2015/12/16        17:17:58 -0.1749886
#>   3: 5.384323 23275  3      2015/12/16        17:49:02 -0.2463415
#>   4: 5.050630 23275  4      2015/12/16        18:20:05 -0.2312703
#>   5: 4.753140 23275  5      2015/12/16        18:51:08 -0.2234906
#>  ---                                                             
#> 716: 6.179895 23289 44      2016/01/01        02:48:45         NA
#> 717: 6.278912 23289 45      2016/01/01        03:19:48         NA
#> 718: 6.335339 23289 46      2016/01/01        03:50:51         NA
#> 719: 6.308614 23289 47      2016/01/01        04:21:54         NA
#> 720: 6.211828 23289 48      2016/01/01        04:52:57         NA
#> 
#> $solar.res
#>      observation_date observation_time obheight           date_time    time1
#>   1:       2015/12/17         00:00:00    4.180 2015/12/17 00:00:00 42353.00
#>   2:       2015/12/17         00:30:00    4.780 2015/12/17 00:30:00 42353.02
#>   3:       2015/12/17         01:00:00    5.340 2015/12/17 01:00:00 42353.04
#>   4:       2015/12/17         01:30:00    5.820 2015/12/17 01:30:00 42353.06
#>   5:       2015/12/17         02:00:00    6.130 2015/12/17 02:00:00 42353.08
#>  ---                                                                        
#> 716:       2015/12/31         21:30:00    5.007 2015/12/31 21:30:00 42367.90
#> 717:       2015/12/31         22:00:00    4.775 2015/12/31 22:00:00 42367.92
#> 718:       2015/12/31         22:30:00    4.550 2015/12/31 22:30:00 42367.94
#> 719:       2015/12/31         23:00:00    4.330 2015/12/31 23:00:00 42367.96
#> 720:       2015/12/31         23:30:00    4.150 2015/12/31 23:30:00 42367.98
#>      tsheight prediction_date prediction_time        res
#>   1: 4.085008      2015/12/17        00:00:00 0.09499181
#>   2: 4.591633      2015/12/17        00:30:00 0.18836680
#>   3: 5.120420      2015/12/17        01:00:00 0.21957968
#>   4: 5.608902      2015/12/17        01:30:00 0.21109807
#>   5: 5.954887      2015/12/17        02:00:00 0.17511274
#>  ---                                                    
#> 716: 4.225695      2015/12/31        21:30:00 0.78130549
#> 717: 4.038341      2015/12/31        22:00:00 0.73665870
#> 718: 3.487573      2015/12/31        22:30:00 1.06242661
#> 719: 3.243748      2015/12/31        23:00:00 1.08625218
#> 720: 3.267625      2015/12/31        23:30:00 0.88237527
```

### BuildTC & SynTC

Model building and synthesis are now decoupled. You need to build a
model with “BuildTC”, setting the analysis period and afterwards you
call SynTC for a defined synthesis period.

``` r
tc_model <- BuildTC(dataInput = tideObservation, asdate = "2015/12/06",
             astime = "00:00:00", aedate = "2016/12/31",
             aetime = "23:30:00")
```

``` r
str(tc_model)
#> List of 7
#>  $ lm.coeff     :List of 48
#>   ..$ 1 : num [1, 1:43] 2.98e+14 -3.94e+14 9.34e+13 9.60e+13 -4.83e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 2 : num [1, 1:43] 5.70e+14 -7.52e+14 1.89e+14 1.82e+14 -9.78e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 3 : num [1, 1:43] 8.50e+14 -1.12e+15 2.86e+14 2.70e+14 -1.48e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 4 : num [1, 1:43] 1.06e+15 -1.40e+15 3.59e+14 3.36e+14 -1.86e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 5 : num [1, 1:43] 1.23e+15 -1.62e+15 4.18e+14 3.89e+14 -2.16e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 6 : num [1, 1:43] 1.29e+15 -1.70e+15 4.42e+14 4.10e+14 -2.28e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 7 : num [1, 1:43] 1.22e+15 -1.61e+15 4.18e+14 3.88e+14 -2.16e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 8 : num [1, 1:43] 1.11e+15 -1.46e+15 3.79e+14 3.51e+14 -1.96e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 9 : num [1, 1:43] 9.72e+14 -1.28e+15 3.34e+14 3.08e+14 -1.72e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 10: num [1, 1:43] 8.48e+14 -1.12e+15 2.91e+14 2.69e+14 -1.51e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 11: num [1, 1:43] 7.12e+14 -9.38e+14 2.45e+14 2.25e+14 -1.26e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 12: num [1, 1:43] 5.37e+14 -7.07e+14 1.86e+14 1.69e+14 -9.57e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 13: num [1, 1:43] 3.20e+14 -4.21e+14 1.13e+14 1.00e+14 -5.79e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 14: num [1, 1:43] 1.34e+13 -1.58e+13 8.51e+12 2.38e+12 -3.99e+12 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 15: num [1, 1:43] -2.91e+14 3.85e+14 -9.54e+13 -9.42e+13 4.98e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 16: num [1, 1:43] -5.20e+14 6.87e+14 -1.75e+14 -1.67e+14 9.07e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 17: num [1, 1:43] -5.60e+14 7.40e+14 -1.88e+14 -1.79e+14 9.76e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 18: num [1, 1:43] -5.34e+14 7.05e+14 -1.80e+14 -1.71e+14 9.37e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 19: num [1, 1:43] -4.72e+14 6.23e+14 -1.58e+14 -1.51e+14 8.23e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 20: num [1, 1:43] -4.63e+14 6.12e+14 -1.54e+14 -1.49e+14 8.01e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 21: num [1, 1:43] -4.94e+14 6.53e+14 -1.64e+14 -1.58e+14 8.52e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 22: num [1, 1:43] -5.64e+14 7.45e+14 -1.87e+14 -1.81e+14 9.72e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 23: num [1, 1:43] -6.44e+14 8.51e+14 -2.13e+14 -2.07e+14 1.10e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 24: num [1, 1:43] -7.51e+14 9.93e+14 -2.48e+14 -2.41e+14 1.29e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 25: num [1, 1:43] -8.68e+14 1.15e+15 -2.87e+14 -2.78e+14 1.48e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 26: num [1, 1:43] -9.13e+14 1.21e+15 -3.00e+14 -2.92e+14 1.55e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 27: num [1, 1:43] -1.08e+15 1.43e+15 -3.56e+14 -3.45e+14 1.84e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 28: num [1, 1:43] -1.14e+15 1.50e+15 -3.74e+14 -3.64e+14 1.94e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 29: num [1, 1:43] -1.14e+15 1.50e+15 -3.74e+14 -3.64e+14 1.94e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 30: num [1, 1:43] -1.14e+15 1.50e+15 -3.74e+14 -3.64e+14 1.93e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 31: num [1, 1:43] -1.09e+15 1.44e+15 -3.56e+14 -3.48e+14 1.85e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 32: num [1, 1:43] -9.79e+14 1.29e+15 -3.20e+14 -3.14e+14 1.66e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 33: num [1, 1:43] -8.46e+14 1.12e+15 -2.74e+14 -2.72e+14 1.42e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 34: num [1, 1:43] -1.77e+15 2.33e+15 -6.25e+14 -5.56e+14 3.22e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 35: num [1, 1:43] -1.59e+15 2.09e+15 -5.63e+14 -5.00e+14 2.90e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 36: num [1, 1:43] -1.32e+15 1.73e+15 -4.66e+14 -4.12e+14 2.40e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 37: num [1, 1:43] -1.14e+15 1.50e+15 -4.04e+14 -3.57e+14 2.08e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 38: num [1, 1:43] -9.20e+14 1.21e+15 -3.24e+14 -2.88e+14 1.67e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 39: num [1, 1:43] -8.68e+14 1.14e+15 -3.05e+14 -2.72e+14 1.56e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 40: num [1, 1:43] -7.47e+14 9.82e+14 -2.60e+14 -2.34e+14 1.34e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 41: num [1, 1:43] -7.09e+14 9.33e+14 -2.46e+14 -2.23e+14 1.26e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 42: num [1, 1:43] -6.44e+14 8.47e+14 -2.23e+14 -2.02e+14 1.15e+14 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 43: num [1, 1:43] -5.10e+14 6.71e+14 -1.75e+14 -1.61e+14 9.01e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 44: num [1, 1:43] -4.42e+14 5.82e+14 -1.50e+14 -1.40e+14 7.72e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 45: num [1, 1:43] -5.08e+14 6.68e+14 -1.74e+14 -1.60e+14 8.94e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 46: num [1, 1:43] -4.58e+14 6.02e+14 -1.56e+14 -1.44e+14 8.03e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 47: num [1, 1:43] -4.39e+14 5.78e+14 -1.50e+14 -1.38e+14 7.69e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>   ..$ 48: num [1, 1:43] -4.49e+14 5.91e+14 -1.54e+14 -1.41e+14 7.91e+13 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : NULL
#>   .. .. ..$ : chr [1:43] "V1" "V2" "V3" "V4" ...
#>  $ tdiff.analyse: num 380
#>  $ km           : num 48
#>  $ mindt        : num 30
#>  $ otz.24       : num 0.0417
#>  $ tplus        : num 18262
#>  $ tm24         : num 1.04
#>  - attr(*, "class")= chr "tidecurve"
```

``` r
tc <- SynTC(tmodel = tc_model, ssdate = "2015/12/17", sstime = "00:00:00",
sedate = "2015/12/31", setime = "23:30:00")
```

``` r
str(tc)
#> List of 2
#>  $ synthesis.lunar:Classes 'data.table' and 'data.frame':    720 obs. of  7 variables:
#>   ..$ date_time      : chr [1:720] "2015/12/16 16:46:55" "2015/12/16 17:17:58" "2015/12/16 17:49:02" "2015/12/16 18:20:05" ...
#>   ..$ time1          : num [1:720] 42353 42353 42353 42353 42353 ...
#>   ..$ height         : num [1:720] 5.92 5.78 5.4 5.3 4.8 ...
#>   ..$ i              : num [1:720] 23275 23275 23275 23275 23275 ...
#>   ..$ k              : num [1:720] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ prediction_date: chr [1:720] "2015/12/16" "2015/12/16" "2015/12/16" "2015/12/16" ...
#>   ..$ prediction_time: chr [1:720] "16:46:55" "17:17:58" "17:49:02" "18:20:05" ...
#>   ..- attr(*, ".internal.selfref")=<externalptr> 
#>  $ tide.curve     :Classes 'data.table' and 'data.frame':    720 obs. of  5 variables:
#>   ..$ date_time      : chr [1:720] "2015/12/17 00:00:00" "2015/12/17 00:30:00" "2015/12/17 01:00:00" "2015/12/17 01:30:00" ...
#>   ..$ time1          : num [1:720] 42353 42353 42353 42353 42353 ...
#>   ..$ height         : num [1:720] 4.28 4.79 5.24 5.68 5.96 ...
#>   ..$ prediction_date: chr [1:720] "2015/12/17" "2015/12/17" "2015/12/17" "2015/12/17" ...
#>   ..$ prediction_time: chr [1:720] "00:00:00" "00:30:00" "01:00:00" "01:30:00" ...
#>   ..- attr(*, ".internal.selfref")=<externalptr>
```

Calling ResCurve on tc is currently not possible. This is on the agenda
for the next release.

``` r
#Not possible
imydifferences <- ResCurve(tcData = tc, obsData = tideObservation)
```
