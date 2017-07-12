TropFishR
=====

TropFishR is a collection of fisheries models based on the FAO Manual 
"Introduction to tropical fish stock assessment" by Sparre and Venema 
(1998, 1999). Not only scientists working in the tropics will benefit from 
this new toolbox. The methods work with age based or length-frequency data 
and assist in the assessment of data poor fish stocks. Overall, the package 
comes with 30 functions, 19 data sets and 10 s3 methods. All objects are 
documented and provide examples that allow reproducing the examples from 
the FAO manual. 


## Installation
Download the released version from CRAN:

```R
install.packages(“TropFishR”)
```

Or the development version from github:

```R
# install.packages(devtools)
devtools::install_github(“tokami/TropFishR”)
```


## Citation
Please use the R command `citation("TropFishR")` to receive information on
how to cite this package.


## Vignette
A [tutorial](https://rawgit.com/tokami/TropFishR/master/inst/doc/tutorial.html)
demonstrates the use of some of the main functions of TropFishR for a 
single-species stock assessment with length-frequency data.

## Questions / Issues
In case you have questions or find bugs, please report on 
[TropFishR/issues](https://github.com/tokami/TropFishR/issues).


## References
  1. Sparre, P., Venema, S.C., 1998. Introduction to tropical fish stock 
  assessment. Part 1. Manual. FAO Fisheries Technical Paper, 
  (306.1, Rev. 2). 407 p. [link](http://www.fao.org/docrep/w5449e/w5449e00.htm)
  2. Sparre, P., Venema, S.C., 1999. Introduction to tropical fish stock 
  assessment. Part 2. Excercises. FAO Fisheries Technical Paper, 
  (306.2, Rev. 2). 94 p. [link](http://www.fao.org/docrep/w5448e/w5448e00.htm)
  3. Mildenberger, T. K., Taylor, M. H. and Wolff, M., 2017. TropFishR: an
  R package for fisheries analysis with length-frequency data. Methods in 
  Ecology and Evolution. doi:10.1111/2041-210X.12791 
  [link](http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12791/abstract)
  4. Taylor, M. H., and Mildenberger, T. K., in press. Extending electronic 
  length frequency analysis in R. Fisheries Management and Ecology. 
  doi:10.1111/fme.12232 [link](http://doi.org/10.6084/m9.figshare.4206561)
  