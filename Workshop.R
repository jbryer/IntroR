#The working directory is where R will look for files by default
setwd("~/Dropbox/Projects/IntroR")
getwd()

#The search command returns a list of loaded (or attached) packages
search()

#The library command returns the packages that have been installed, but not
#necessarily loaded.
library()

#Return some information about the R environment. This will be useful when
#asking for help
Sys.info()
R.version

#Returns the paths where R packages have been installed. When using the library
#or require functions to load a package, they will traverse this list until it
#the desired package is found.
.libPaths()

#Load the packages we will use
require(foreign) #Used for reading SPSS files
require(gdata)   #Used for reading Excel files
require(ggplot2) #Used for plotting
require(xtable)  #Used for create LaTeX tables from R data frames
require(ipeds)   #Used for getting data from IPEDS
require(psych)   #Lots of useful functions here. http://www.personality-project.org/r/
require(retention) #Package for calculating retention and completion rates. 

data(surveys) #From the ipeds package. Lists available datasets from IPEDS
data(students) #From the retention package
data(graduates) #From the retention package

#This block shows a simple if, then, else logic block. In this case we want to
#do something special depending on the users platform.
if(Sys.info()['sysname'] == 'Windows') {
	memory.limit(size=4095) #Set to 4GB (for 64-bit Windows, this can be much larger)
	print("Welcome Windows user")
} else if(Sys.info()['sysname'] == 'Darwin') {
	print("Welcome Mac OS X user")
} else {
	print(paste("Welcome", Sys.info()['sysname'], "user"))
}

################################################################################
#The first data frame we will load contains the number of citations to R prepared
#by David Firth from the ISI Web of Knowledge and Google Scholar.
#Available at http://blogs.warwick.ac.uk/davidfirth/entry/r_and_citations/
rcitations = read.csv('Data/rcitations.csv')
#The read.csv returns a data frame (in essence this is R's name for tables).
#There are a number of functions we can use to examine the structure of the data
#frame. The names functions returns the column (aka variable) names. Note that
#variable names must begin with an alphabetic character. Therefore R automatically
#adds an X to the beginning of the columns that begin with a number.
names(rcitations)
#To get more detailed information about the table, including the variable types,
#use the str function.
str(rcitations)
#The str function can be used on virtually every R object. 
str(names)
#The nrow and ncol functions return the number of rows and columns, respectively.
nrow(rcitations)
ncol(rcitations)
#The head and tail functions return the first or last n (6 by default) rows
head(rcitations)
tail(rcitations)
#The apply function is usefull for applying a function to a series of rows (1)
#or columns of a data frame or matrix. In this case, we wil sum the number of
#citations for each year.
totals = apply(rcitations[,2:ncol(rcitations)], 2, sum, na.rm=TRUE)
totals
#The apply function returns a named vector. It is often more useful to convert
#this to a data frame.
class(totals)
totals = as.data.frame(totals)
totals
#After converting totals to a data frame the data is presented vertically but
#only contains one column. We can create a new variable (column) easily.
ncol(totals)
rownames(totals)
totals$Year = as.character(substr(rownames(totals), 2,5))
totals
#We can then rename the variables
names(totals) = c("Citations", "Year")
#We can also rename the row names
rownames(totals) = 1:nrow(totals)
totals

#Using ggplot we can create a histogram
ggplot(totals, aes(x=Year, y=Citations, label=Citations)) + 
	geom_histogram(alpha=.5) + geom_text(size=3, vjust=-.5)


##### GETTING HELP #############################################################
#There are lots of ways of getting help with R. If you know a function name
#simply putting ? before the function name will bring up that functions help
#page.
?xtable
#However, if you know the package but not the function name, you can get a list
#of functions within a package with the ls function. The parameter can match
#anything returned from the search function.
search()
ls('package:xtable')
#You can get to a package's help file using the help function.
help(package='xtable')
#And of course there are other parameters to the help function, use ?help to
#learn more.
?help
#You can search for a phrase within the locally available packages with the
#help.search function.
help.search('regression')
#You can initiate a search of the R website with the RSiteSearch function.
RSiteSearch('regression')

##### Factors ##################################################################
f <- factor(letters[1:6], levels=letters[1:12], labels=toupper(letters[1:12]))
f
as.integer(f)
as.character(f)
table(f, useNA='ifany')

################################################################################
students = read.xls('Data/students.xls')
students = read.xls(file.choose()) #The file.choose function is used to locate the file
names(students)
nrow(students)
str(students)

#Crosstabs are done using the table function
table(students$Division)
#As are 2-way crosstabs
table(students$Division, students$Military)
#The prop.table will give a proportion table
prop.table(table(students$Division, students$Military))
prop.table(table(students$Division, students$Military), 1) #Row proportions
prop.table(table(students$Division, students$Military), 2) #Column proportions

#Recode degree type to include more meaningful labels
table(students$Level, useNA='ifany')
levels(students$Level)
levels(students$Level) = c('Graduate', 'Undergraduate')
table(students$Level, useNA='ifany')

#Convert Enrolled from factors to date types
class(students$Enrolled)
head(students$Enrolled)
students$Enrolled = as.Date(students$Enrolled, format='%Y-%m-%d')
str(students)
#See ?as.Date for more info about date formats

#Get the mean credits
mean(students$Credits)
mean(students$Credits, na.rm=TRUE) #Remove missing values to get a mean
median(students$Credits, na.rm=TRUE) #Median
sd(students$Credits, na.rm=TRUE)   #Standard deviation
summary(students$Credits) #Some basic stats including range and quartiles
fivenum(students$Credits) #Quartiles
#The describe function in the psych package provides more summary statistics
describe(students$Credits)
#Can also group descriptive statistics
describeBy(students$Credits, list(students$Division), mat=TRUE)

#Create a histogram of number of credits
hist(students$Credits)

#First ggplot2 example
data(diamonds)
head(diamonds)

p <- ggplot(diamonds, aes(x=carat,y=price,colour=cut)) + geom_point()
print(p)

p <- p + facet_wrap(~cut) + ggtitle("First example")
print(p)

#Create the same histogram using ggplot
ggplot(students, aes(x=Credits)) + geom_histogram(binwidth=3)

#Using ggplot it easy to create separate histograms based upon some grouping variable
ggplot(students, aes(x=Credits)) + geom_histogram(binwidth=3) + facet_wrap(~ Division)

#Perhaps a density plot would be better
ggplot(students, aes(x=Credits)) + geom_density()
ggplot(students, aes(x=Credits, colour=Division)) + geom_density()


##### Merging Data #############################################################
#We will create three dummy data frames
survey1 = data.frame(StudentID=c(1,2,6), Question1=c('A','B','B'))
survey2 = data.frame(Question1=c('A','B','C'), ID=c(2,3,4), Question2=c('No','No','Yes'))
students = data.frame(StdID=c(1,2,3,4,5), Gender=c('Male','Male','Female','Female','Male'))

survey1
survey2
students

names(survey1)
names(survey2)
names(students)

rbind(survey1, survey2) #This won't work since the column names do not match

survey1$Question2 = NA
survey1

names(survey2)
names(survey2)[2] = "StudentID"

survey2 = survey2[,c('StudentID', 'Question1', 'Question2')]

combinedSurvey = rbind(survey1, survey2)
combinedSurvey

survey1$Administration = 1
survey2$Administration = 2
combinedSurvey = rbind(survey1, survey2)
combinedSurvey

duplicated(combinedSurvey$StudentID)
combinedSurvey[ !duplicated(combinedSurvey$StudentID), ]

merge(combinedSurvey, students, by.x='StudentID', by.y='StdID')
merge(combinedSurvey, students, by.x='StudentID', by.y='StdID', all.x=TRUE)
merge(combinedSurvey, students, by.x='StudentID', by.y='StdID', all.x=TRUE, all.y=TRUE)


################################################################################
#IPEDS package
library(ipeds)
data(surveys)
ipedsHelp('F_F1A', 2010)
ipedsHelp('F_F2', 2010)
ipedsHelp('F_F3', 2010)

directory = recodeDirectory(getIPEDSSurvey('HD', 2010))
directory[which(directory$instnm == 'Excelsior College'),]
unitid = directory[which(directory$instnm == 'Excelsior College'),'unitid']
peerIds = c(105668,127918,128780,144777,163204,183257,187046,202806,206279,223816,
			260901,413413,433387,444158,445027,449339)
peers = directory[which(directory$unitid %in% peerIds),]

finPublic = getIPEDSSurvey('F_F1A', 2010)
finNotProfit = getIPEDSSurvey('F_F2', 2010)
finForProfit = getIPEDSSurvey('F_F3', 2010)
finPublic = finPublic[which(finPublic$unitid %in% peerIds),]
finNotProfit = finNotProfit[which(finNotProfit$unitid %in% peerIds),
				tolower(c('XF2A02'))]
finForProfit = finForProfit[which(finForProfit$unitid %in% peerIds),
				tolower(c('XF3A01','XF3A02','XF3A03','XF3A04','XF3B01','XF3B02'))]


################################################################################
#Examine the relationship between SAT scores and retention
#Get the three data files we will need
data(surveys)
directory = getIPEDSSurvey('HD', 2009)
admissions = getIPEDSSurvey("IC", 2009)
retention = getIPEDSSurvey("EFD", 2009)

#For offline use
directory = read.csv('../Data/IPEDS/hd2009.csv')
admissions = read.csv("../Data/IPEDS/ic2009.csv")
retention = read.csv("../Data/IPEDS/ef2009d.csv")
names(directory) = tolower(names(directory))
names(admissions) = tolower(names(admissions))
names(retention) = tolower(names(retention))
#End offline

#Subset the data frames so we only have the columns we need
directory = directory[,c('unitid', 'instnm', 'sector', 'control')]
admissions = admissions[,c('unitid', 'admcon1', 'admcon2', 'admcon7', 'applcnm', 
						   'applcnw', 'applcn', 'admssnm', 'admssnw', 'admssn', 
						   'enrlftm', 'enrlftw', 'enrlptm', 'enrlptw', 'enrlt', 
						   'satnum', 'satpct', 'actnum', 'actpct', 'satvr25', 
						   'satvr75', 'satmt25', 'satmt75', 'satwr25', 'satwr75', 
						   'actcm25', 'actcm75', 'acten25', 'acten75', 'actmt25', 
						   'actmt75', 'actwr25', 'actwr75')]
retention = retention[,c('unitid', 'ret_pcf', 'ret_pcp')]

#Recode admissions condition to a factor from an integer
admissionsLabels = c("Required", "Recommended", "Neither requiered nor recommended", 
					 "Do not know", "Not reported", "Not applicable")
admissions$admcon1 = factor(admissions$admcon1, levels=c(1,2,3,4,-1,-2), 
				labels=admissionsLabels)
admissions$admcon2 = factor(admissions$admcon2, levels=c(1,2,3,4,-1,-2), 
				labels=admissionsLabels)
admissions$admcon7 = factor(admissions$admcon7, levels=c(1,2,3,4,-1,-2), 
				labels=admissionsLabels)

#Rename the columns
names(admissions) = c("unitid", "UseHSGPA", "UseHSRank", "UseAdmissionTestScores", 
					  "ApplicantsMen", "ApplicantsWomen", "ApplicantsTotal", 
					  "AdmissionsMen", "AdmissionsWomen", "AdmissionsTotal", 
					  "EnrolledFullTimeMen", "EnrolledFullTimeWomen", 
					  "EnrolledPartTimeMen", "EnrolledPartTimeWomen", 
					  "EnrolledTotal", "NumSATScores", "PercentSATScores", 
					  "NumACTScores", "PercentACTScores", "SATReading25", 
					  "SATReading75", "SATMath25", "SATMath75", "SATWriting25", 
					  "SATWriting75", "ACTComposite25", "ACTComposite75", 
					  "ACTEnglish25", "ACTEnglish75", "ACTMath25", "ACTMath75", 
					  "ACTWriting25", "ACTWriting75")
names(retention) = c("unitid", "FullTimeRetentionRate", "PartTimeRetentionRate")

#Merge the data frames. Note that schools that do not appear in all three data 
#frames will not be included in the final analysis.
ret = merge(directory, admissions, by="unitid")
ret = merge(ret, retention, by="unitid")
#Use schools that require or recommend admission tests
ret2 = ret[ret$UseAdmissionTestScores %in% 
	c('Required', 'Recommended', 'Neither requiered nor recommended'),] 
#Remove schools with low retention rates. Are these errors in the data?
ret2 = ret2[-which(ret2$FullTimeRetentionRate < 20),] 

#IPEDS only provides the 25th and 75th percentile in SAT and ACT scores. We will use
#the mean of these two values as a proxy for the mean
ret2$SATMath75 = as.numeric(ret2$SATMath75)
ret2$SATMath25 = as.numeric(ret2$SATMath25)
ret2$SATMath = (ret2$SATMath75 + ret2$SATMath25) / 2
ret2$SATWriting75 = as.numeric(ret2$SATWriting75)
ret2$SATWriting25 = as.numeric(ret2$SATWriting25)
ret2$SATWriting = (ret2$SATWriting75 + ret2$SATWriting25) / 2
ret2$SATTotal = ret2$SATMath + ret2$SATWriting

ret2$AcceptanceTotal = as.numeric(ret2$AdmissionsTotal) / as.numeric(ret2$ApplicantsTotal)
ret2$UseAdmissionTestScores = as.factor(as.character(ret2$UseAdmissionTestScores))

#Plot ussing ggplot2
ggplot(ret2, aes(x=FullTimeRetentionRate)) + geom_histogram(binwidth=1, alpha=.6)
ggplot(ret2, aes(x=SATMath)) + geom_histogram(binwidth=10, alpha=.6)
ggplot(ret2, aes(x=SATWriting)) + geom_histogram(binwidth=10, alpha=.6)

retMath = ret2[,c('unitid', 'SATMath25', 'SATMath75', 'SATMath')]
retMath = melt(retMath, id="unitid")
ggplot(retMath, aes(x=value)) + 
	geom_histogram(binwidth=10, alpha=.6) + 
	facet_wrap(~ variable, ncol=1)

retWriting = ret2[,c('unitid', 'SATWriting25', 'SATWriting75', 'SATWriting')]
retWriting = melt(retWriting, id="unitid")
ggplot(retWriting, aes(x=value)) + 
	geom_histogram(binwidth=10, alpha=.6) + 
	facet_wrap(~ variable, ncol=1)

ggplot(ret2, aes(x=SATTotal, y=FullTimeRetentionRate, size=NumSATScores, 
				 color=UseAdmissionTestScores)) + geom_point()

#Regression
fit = lm(FullTimeRetentionRate ~ SATWriting + SATMath + AcceptanceTotal + 
	UseAdmissionTestScores, data=ret2, weights=NumSATScores)
summary(fit)
x = xtable(fit, caption="Regression Results", label="regressionTable")
print(x)


################################################################################
#Google Visualization
library(googleVis)
source('Functions.R')
retlong = getRetentionSAT(2006)
retlong = rbind(retlong, getRetentionSAT(2007))
retlong = rbind(retlong, getRetentionSAT(2008))
retlong = rbind(retlong, getRetentionSAT(2009))
retlong$Institution = paste(retlong$instnm, ' (', retlong$unitid, ')', sep='')
retlong$control = recodeControl(retlong$control)
retlong$sector = recodeSector(retlong$sector)
retlong = retlong[,c('Institution', 'sector', 'control', 'UseHSGPA', 'UseHSRank',
			'UseAdmissionTestScores', 'ApplicantsTotal', 'AdmissionsTotal',
			'EnrolledTotal', 'NumSATScores', 'SATMath', 'SATWriting',
			'SATTotal', 'AcceptanceTotal', 'Year', 'FullTimeRetentionRate')]
retlong$ApplicantsTotal = as.numeric(retlong$ApplicantsTotal)
retlong$AdmissionsTotal = as.numeric(retlong$AdmissionsTotal)
retlong$EnrolledTotal = as.numeric(retlong$EnrolledTotal)
retlong$NumSATScores = as.numeric(retlong$NumSATScores)
str(retlong)

m = gvisMotionChart(retlong, idvar='Institution', timevar='Year', 
		options=list(state='{"time":"2009","xAxisOption":"11","yAxisOption":"16"}'))
cat(m$html$chart)
plot(m)

#This changes the default theme for ggplot2. Specifically, it changes the grey
#background to white which is better for printing.
theme_update(panel.background=element_blank(), 
			 panel.grid.major=element_blank(), 
			 panel.border=element_blank())
