# List of packages to install
pkgs <- c('Deducer', 'devtools', 'doBy', 'dplyr', 'foreign', 'gdata', 'ggplot2',
		  'ggthemes','ggvis', 'haven', 'Hmisc', 'JGR', 'knitr','lubridate', 
		  'maps', 'mapdata', 'maptools', 'psych', 'RCurl', 'readr', 'readxl',
		  'reshape2', 'rmarkdown', 'RODBC', 'roxygen2', 'seqinr', 'shiny',
		  'shinydashboards','sm', 'sp', 'sqldf', 'stringr', 'survey', 
		  'WriteXLS', 'XML', 'xtable')

.libPaths()[1] #This is where R will install the packages

#This will install the list of packages above. Good for a new installation
is_installed <- function(mypkg) { is.element(mypkg, installed.packages()[,1]) }
for(l in pkgs) {
	if(!is_installed(l)) {
		if(Sys.info()['sysname'] == 'Windows') {
			install.packages(l, dependencies=TRUE,
				repos=c("http://www.stats.ox.ac.uk/pub/RWin", 
						"http://cran.r-project.org"))
		} else {
			install.packages(l, dependencies=TRUE,
							 repos=c("http://cran.r-project.org"))			
		}
	}
}

#If you already have R installed, this function will look for updates to any
#installed packages.
update.packages(ask=FALSE, repos='http://cran.r-project.org')

#The following packages will be installed from github.com. The install_github
#function is in the devtools package.
require(devtools)
install_github('jbryer/likert')
install_github('jbryer/sqlutils')
install_github('jbryer/ipeds')
install_github('jbryer/timeline')
install_github('jbryer/retention')
install_github('jbryer/DataCache')
install_github('jbryer/makeR')
install_github('jbryer/qualtrics')
install_github('jbryer/multilevelPSA')
install_github('jbryer/TriMatch')
install_github('jbryer/PSAboot')
install_github('jbryer/IS606')

library() #Return list of installed packages
search() #Return list of loaded packages
