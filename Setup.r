pkgs <- c('Deducer', 'devtools', 'doBy', 'foreign', 'gdata', 'ggplot2',
          'gmaps', 'Hmisc', 'JGR', 'knitr', 'lubridate', 'maps', 'mapdata', 'mapprov',
          'maptools', 'psych', 'R2wd', 'RCurl', 'reshape', 'RODBC',
          'roxygen2', 'seqinr', 'sm', 'sp', 'sqldf', 'stringr', 'survey', 'WriteXLS',
          'XML', 'xtable')

#We can change the library path to work of the flash drive.
if(Sys.info()['sysname'] == 'Darwin') {
	.libPaths('/Volumes/NEAIR/R/mac')
} else if(Sys.info()['sysname'] == 'Windows') {
	.libPaths('E:/R/win')
}

.libPaths()[1] #This is where R will install the packages

#This will install the list of packages above. Good for a new installation
is_installed <- function(mypkg) { is.element(mypkg, installed.packages()[,1]) }
for(l in pkgs) {
	if(!is_installed(l)) {
		install.packages(l, dependencies=TRUE,
			repos=c("http://www.stats.ox.ac.uk/pub/RWin", "http://cran.r-project.org"))
	}
}

#If you already have R installed, this function will look for updates to any
#installed packages.
update.packages(ask=FALSE)

#The following packages will be installed from github.com. The install_github
#function is in the devtools package.
require(devtools)
install_github('retention','jbryer')
install_github('irutils','jbryer')
install_github('ipeds','jbryer')
install_github('makeR','jbryer')
install_github('pisa','jbryer')
install_github('multilevelPSA','jbryer')
install_github('sqlutils','jbryer')
install_github('likert','jbryer')

library() #Return list of installed packages
search() #Return list of loaded packages
