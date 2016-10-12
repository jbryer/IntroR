# List of packages to install
pkgs <- c('AER', 'Deducer', 'devtools', 'doBy', 'dplyr', 'foreign', 'gdata', 'ggplot2',
		  'ggthemes','ggvis', 'haven', 'Hmisc', 'JGR', 'knitr','lubridate', 
		  'maps', 'mapdata', 'maptools', 'openintro', 'party', 'psych', 'randomForest',
		  'RCurl', 'readr', 
		  'readxl', 'reshape2', 'rmarkdown', 'ROCR', 'RODBC', 'roxygen2', 'seqinr', 
		  'shiny', 'sm', 'sp', 'sqldf', 'stringr', 'survey', 
		  'WriteXLS', 'XML', 'xtable')
pkgs.github <- c('jbryer/likert', 'jbryer/sqlutils', 'jbryer/ipeds',
				 'jbryer/timeline', 'jbryer/retention', 'jbryer/DataCache',
				 'jbryer/makeR', 'jbryer/qualtrics', 'jbryer/multilevelPSA',
				 'jbryer/TriMatch', 'jbryer/PSAboot', 'jbryer/IS606')

.libPaths()[1] #This is where R will install the packages

repos <- c("http://cran.r-project.org")
if(Sys.info()['sysname'] == 'Windows') {
	repos <- c("http://www.stats.ox.ac.uk/pub/RWin", repos)
}

# package(pkgs, update=TRUE, repos=repos)

# This will install the list of packages above. Good for a new installation
is_installed <- function(mypkg) { is.element(mypkg, installed.packages()[,1]) }
pb <- txtProgressBar(min=0, max=length(pkgs), style=3)
for(i in seq_along(pkgs)) {
	l <- pkgs[i]
	if(!is_installed(l)) {
		install.packages(l, dependencies=TRUE, verbose=FALSE, quiet=TRUE, repos=repos)			
	}
	setTxtProgressBar(pb, i)
}
close(pb)

# If you already have R installed, this function will look for updates to any
# installed packages.
update.packages(ask=FALSE, repos='http://cran.r-project.org')

#The following packages will be installed from github.com. The install_github
#function is in the devtools package.
require(devtools)
pb <- txtProgressBar(min=0, max=length(pkgs.github), style=3)
for(i in seq_along(pkgs.github)) {
	install_github(pkgs.github[i])
	setTxtProgressBar(pb, i)
}
close(pb)

library() #Return list of installed packages
search() #Return list of loaded packages
