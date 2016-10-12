library(gdata)
library(reshape2)
library(ggplot2)
library(psych)
library(lavaan)
library(semPlot)
library(nFactors)

load("Data/SASR-Cerego.Rda")
sasr.cerego <- sasr.cerego[complete.cases(sasr.cerego),]
sasr.mapping <- read.xls('Data/SASR.xlsx', 
						 sheet=1, stringsAsFactors=FALSE)
sasr34 <- sasr.mapping[!is.na(sasr.mapping$SASR34ID),]
subscales <- unique(sasr34$Subscale)

# Convert factors to integers
for(i in 1:ncol(sasr.cerego)) {  
	sasr.cerego[,i] <- as.integer((sasr.cerego[,i]))
}

# Only using the columns for the 34-item version
sasr34.cerego <- sasr.cerego[,which(!is.na(sasr.mapping$SASR34ID))]

for(i in subscales) {
	reverse <- sasr34[which(sasr34$Subscale == i),]$Reverse.Score == 'Yes'
	scores <- sasr34.cerego[, which(sasr34$Subscale == i)]
	names(scores) <- sasr34[which(sasr34$Subscale == i),]$SASR34ID
	for(j in which(reverse)) {
		scores[,j] <- 6 - scores[,j]
	}
	sasr34.cerego[,i] <- apply(scores, 1, sum, na.rm=TRUE)
	sasr34.cerego[,paste0(i, '-Percent')] <- sasr34.cerego[,i] / 
						(5 * ncol(scores))
}

View(sasr34.cerego[,35:44])

sasr.totals <- sasr34.cerego[,c(36,38,40,42,44)]
sasr.totals.melted <- melt(sasr.totals)

quantile(sasr.totals[,1], probs=c(.33,.66))

ggplot(sasr.totals.melted, aes(x=value, color=variable)) + 
	geom_density() +
	facet_wrap(~ variable, ncol=1)

describeBy(sasr.totals.melted$value, group=sasr.totals.melted$variable, mat=TRUE)

#save(sasr.totals, file='shiny/SASR-Totals.Rda')

##### 34-Item version

sasr34.model0 <- '
	IntrinsicMotivation =~ SASR1 + SASR9 + SASR16 + SASR17 + SASR24 + SASR38 + SASR49
	ExtrinsicMotivation =~ SASR3 + SASR11 + SASR26 + SASR48 + SASR59
	SelfRegulation =~ SASR10 + SASR15 + SASR18 + SASR30 + SASR47 + SASR55 + SASR57
	Metacognition =~ SASR13 + SASR14 + SASR21 + SASR22 + SASR28 + SASR33 + SASR34 + SASR40 + SASR50 + SASR52 + SASR61
	SelfEfficacy =~ SASR36 + SASR44 + SASR53 + SASR58
'

sasr34.cov <- cov(sasr.cerego[,1:34])

sasr34.fit0 <- lavaan::cfa(sasr34.model0, data=sasr.cerego)
summary(sasr34.fit0, fit.measures=TRUE)
sasr34.fits0 <- inspect(sasr34.fit0, 'fit')

semPaths(sasr34.fit0, rotation=4, curvePilot=TRUE, title=FALSE)
title('SASR CFA Model', line=3)

mi34.0 <- modindices(sasr34.fit0)
head(mi34.0[order(mi34.0$mi, decreasing=TRUE),], n=20)

sasr34.model1 <- paste0(
	sasr34.model0, '
	SASR18 ~~ SASR30
	SASR10 ~~ SASR18
	SASR59 ~~ SASR44
	SASR53 ~~ SASR58
	SASR10 ~~ SASR30
	'
)

sasr34.fit1 <- lavaan::cfa(sasr34.model1, data=sasr.cerego)
summary(sasr34.fit1, fit.measures=TRUE)
sasr34.fits1 <- inspect(sasr34.fit1, 'fit')

sasr34.fits0['chisq'] / sasr34.fits0['df']
pchisq(q=(sasr34.fits0['chisq'] / sasr34.fits0['df']), df=sasr34.fits0['df'], lower.tail=TRUE)

sasr34.fits1['chisq'] / sasr34.fits1['df']
pchisq(q=(sasr34.fits1['chisq'] / sasr34.fits1['df']), df=sasr34.fits1['df'], lower.tail=TRUE)

sasr34.fits0[c('cfi','tli','rmsea')]
sasr34.fits1[c('cfi','tli','rmsea')]


##### 63-Item version
sasr63.model0 <- '
	IntrinsicMotivation =~ SASR1 + SASR8 + SASR9 + SASR16 + SASR17 + SASR24 + 
				SASR38 + SASR49 + SASR51
	ExtrinsicMotivation =~ SASR3 + SASR11 + SASR26 + SASR48 + SASR59
	SelfRegulation =~ SASR2 + SASR10 + SASR15 + SASR18 + SASR19 + SASR25 + 
				SASR27 + SASR30 + SASR35 + SASR47 + SASR55 + SASR57 + SASR63
	Metacognition =~ SASR5 + SASR6 + SASR13 + SASR14 + SASR21 + SASR22 + 
				SASR28 + SASR29 + SASR32 + SASR33 + SASR34 + SASR40 + SASR42 + 
				SASR43 + SASR50 + SASR52 + SASR61 + SASR62
	SelfEfficacy =~ SASR4 + SASR12 + SASR20 + SASR36 + SASR39 + SASR44 + 
				SASR53 + SASR58
	PersonalRelevance =~ SASR7 + SASR23 + SASR31 + SASR37 + SASR41 + SASR45 + 
				SASR46 + SASR54 + SASR56 + SASR60
'

# remove 19, 44, and 58
sasr63.model0a <- '
	IntrinsicMotivation =~ SASR1 + SASR8 + SASR9 + SASR16 + SASR17 + SASR24 + 
				SASR38 + SASR49 + SASR51
	ExtrinsicMotivation =~ SASR3 + SASR11 + SASR26 + SASR48 + SASR59
	SelfRegulation =~ SASR2 + SASR10 + SASR15 + SASR18 + SASR25 + 
				SASR27 + SASR30 + SASR35 + SASR47 + SASR55 + SASR57 + SASR63
	Metacognition =~ SASR5 + SASR6 + SASR13 + SASR14 + SASR21 + SASR22 + 
				SASR28 + SASR29 + SASR32 + SASR33 + SASR34 + SASR40 + SASR42 + 
				SASR43 + SASR50 + SASR52 + SASR61 + SASR62
	SelfEfficacy =~ SASR4 + SASR12 + SASR20 + SASR36 + SASR39 +  
				SASR53
	PersonalRelevance =~ SASR7 + SASR23 + SASR31 + SASR37 + SASR41 + SASR45 + 
				SASR46 + SASR54 + SASR56 + SASR60
'

sasr63.cov <- cov(sasr.cerego)

sasr63.fit0 <- lavaan::cfa(sasr63.model0, data=sasr.cerego)
summary(sasr63.fit0, fit.measures=TRUE)
sasr63.fits0 <- inspect(sasr63.fit0, 'fit')

semPaths(sasr63.fit0, rotation=4, curvePilot=TRUE, title=FALSE)
title('SASR CFA Model', line=3)

mi63.0 <- modindices(sasr63.fit0)
head(mi[order(mi63.0$mi, decreasing=TRUE),], n=20)

sasr63.fit0a <- lavaan::cfa(sasr63.model0a, data=sasr.cerego)
summary(sasr63.fit0a, fit.measures=TRUE)
sasr63.fits0a <- inspect(sasr63.fit0a, 'fit')


# NOTE: need to look at the items to determine if we would expect these items to
# be correlated. Are the measuring the same or similar thing?
sasr63.model1 <- paste0( # Correlating errors where items have a mi > 150
	sasr34.model0, '
	SASR53 ~~ SASR58
	SASR18 ~~ SASR30
	SASR18 ~~ SASR27
	SASR59 ~~ SASR44
	'
)

sasr63.fit1 <- lavaan::cfa(sasr63.model1, data=sasr.cerego)
summary(sasr63.fit1, fit.measures=TRUE)
sasr63.fits1 <- inspect(sasr63.fit1, 'fit')

sasr63.fits0[c('cfi','tli','rmsea')]
sasr63.fits0a[c('cfi','tli','rmsea')]
sasr63.fits1[c('cfi','tli','rmsea')]


##### Exploratory Factor analysis

ev <- eigen(cov(sasr.cerego)) # get eigenvalues
ap <- nFactors::parallel(subject=nrow(bfi),var=ncol(bfi), rep=100,cent=.05)
nS <- nScree(ev$values, ap$eigen$qevpea)
plotnScree(nS, legend=FALSE)

fit <- factanal(sasr.cerego, 6, rotation="promax")
print(fit, digits=2, cutoff=.3, sort=TRUE)

