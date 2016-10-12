if(!require(rChoiceDialogs)) {
	devtools::install_github('cran/rChoiceDialogs')
	#install.packages('rChoiceDialogs’', repos='http://cran.r-project.org')
	library(rChoiceDialogs)
}
#dir <- tk_choose.dir(getwd(), "Choose where to download workshop files")
rchoose.dir()
