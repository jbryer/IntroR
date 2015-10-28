# Installing R and LaTeX

## Table of Contents ##

* [Downloads](#downloads) Links to download the necessary software.

* [R Packages](#rsetup) Once R and the supporting software has been installed, it is necessary to install a core set of R packages commonly used.


## Download Links <a id='downloads'></a> ##

These direct download links are provided for convenience and represent the latest versions as of October 2012. It is generally advisable to download the software from each site to ensure getting the latest version.

##### Windows #####

* [R](https://cran.r-project.org/bin/windows/base/)
* [RStudio](https://www.rstudio.com/products/rstudio/download/)
* [Rtools](https://cran.r-project.org/bin/windows/Rtools/)
* [MiKTeX](http://miktex.org/download)
* [ActivePerl](http://www.activestate.com/activeperl/downloads)

##### Mac #####

* [R](https://cran.r-project.org/bin/macosx/)
* [Basic TeX](https://tug.org/mactex/morepackages.html) (Note: MacTex is a large, often slow, download. Basic Tex is a smaller version and is sufficient for this workshop.)
* [RStudio](https://www.rstudio.com/products/rstudio/download/)
* [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) - Once installed, start Xcode (located in the Applications folder) and accept the user agreement. Once accepted, you can quit the application.
* [Java](https://support.apple.com/kb/DL1572?locale=en_US) - This is an optional install.

[^ Top](#)


## Installing R Packages <a name='rsetup'></a> ##

Now we will install the first set of R packages. I have provided a setup script that will install the packages we will use. `Setup.r` can be downloaded from [Github here](https://raw.github.com/jbryer/CompStats/master/Installation/Setup.r). Open this script in Rstudio. Once open, click the `Source` button. Or, simply copy and paste this command into R:

```
source('https://raw.githubusercontent.com/jbryer/IntroR/master/Installation/Setup.r')
```

![RStudio Setup.r](https://github.com/jbryer/CompStats/blob/master/Installation/Figures/Rstudio-SetupScript.png?raw=true)

[^ Top](#)

