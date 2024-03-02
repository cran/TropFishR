TropFishR :fishing_pole_and_fish:
=====

## Package description

TropFishR is a collection of fisheries models based on the FAO Manual
"Introduction to tropical fish stock assessment" by Sparre and Venema
(1998, 1999). Not only scientists working in the tropics will benefit
from this new toolbox. The methods work with age-based or
length-frequency data and assist in the assessment of data poor fish
stocks. Overall, the package comes with 30 functions, 19 data sets and
10 s3 methods. All objects are documented and provide examples that
allow reproducing the examples from the FAO manual.


## News
You can find detailed descriptions of new features, bug fixes, other changes of
specific package versions [here](NEWS.md).


## Installation
Download the released version of TropFishR from CRAN:

```R
install.packages("TropFishR")
```

Or the development version from GitHub:

```R
# install.packages("remotes")
remotes::install_github("tokami/TropFishR")
```

## Citation
Please use the R command `citation("TropFishR")` to receive information on
how to cite this package.


## Documentation
The "Length-frequency data for TropFishR" tutorial gives a brief description of
LFQ data and illustrates how files with raw length measurements (e.g. excel
files) can be imported into R and trimmed for the use with TropFishR. The "Using
the TropFishR ELEFAN functions" tutorial demonstrates the ELEFAN functions
available in TropFishR in detail and discusses best practices.


## Questions / Issues
In case you have questions or find bugs, please write an email to
[Tobias Mildenberger](mailto:t.k.mildenberger@gmail.com) or post on
[TropFishR/issues](https://github.com/tokami/TropFishR/issues). If you
want to be updated with the development of the package or want to
discuss with TropFishR users and developers, follow the project on
[ResearchGate](https://www.researchgate.net/project/TropFishR).


## References
1. Sparre, P., Venema, S.C., 1998. Introduction to tropical fish stock assessment. Part 1. Manual. FAO Fisheries Technical Paper, (306.1, Rev. 2). 407p. [link](https://www.fao.org/documents/card/en/c/9bb12a06-2f05-5dcb-a6ca-2d6dd3080f65/)
2. Sparre, P., Venema, S.C., 1999. Introduction to tropical fish stock assessment. Part 2. Excercises. FAO Fisheries Technical Paper, (306.2, Rev. 2). 94p. [link](https://www.fao.org/3/W5448E/W5448E00.htm)
3. Mildenberger, T. K., Taylor, M. H. and Wolff, M., 2017. TropFishR: an R package for fisheries analysis with length-frequency data. Methods in Ecology and Evolution, 8: 1520-1527. doi:10.1111/2041-210X.12791 [link](https://doi.org/10.1111/2041-210X.12791)
4. Taylor, M. H., and Mildenberger, T. K., 2017. Extending electronic length frequency analysis in R. Fisheries Management and Ecology, 24:330-338. doi:10.1111/fme.12232 [link](https://doi.org/10.1111/fme.12232)
