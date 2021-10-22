#First Mini Project 

getwd() #checking the working directory
setwd("/Desktop/specdata") #setting the working directory to where the files that will be used are located

#1

pollutantMean <- function(directory, pollutant, id= 1:332){
  DataMean <- c()
  files <- list.files(getwd(), full.names=TRUE) 
  data <- data.frame()
  for(num in id){
    data <- rbind(data, read.csv(files[num]))
    selected_data <- data[pollutant]
  }
  DataMean <- c(DataMean, selected_data[!is.na(selected_data)])
  mean(DataMean)
}
#sample output
pollutantMean("specdata", "sulfate",1:10)
#result: 4.064128
pollutantMean("specdata", "nitrate",70:72)
#result: 1.706047
pollutantMean("specdata", "nitrate",23)
#result: 1.280833


#2
complete <- function(directory, id = 1:332){
  
  output <- data.frame(id=numeric(0), nobs=numeric(0))
  files <- list.files(getwd(), full.names=TRUE) 
  data <- data.frame()
  for(num in id){
    data <- read.csv(files[num])
    selected_data <- data[(!is.na(data$sulfate)), ]
    selected_data <- selected_data[(!is.na(selected_data$nitrate)), ]
    nobs <- nrow(selected_data)
    output <- rbind(output, data.frame(id=num, nobs=nobs))
  }
  output
}
#Sample Output
complete("specdata", 1)
#result:      id    nobs    
#     1        1    117
complete("specdata", c(2,4,8,10,12))
#result:      id    nobs
#     1       2     1041
#     2       4     474
#     3       8     192
#     4       10    148
#     5       12    96
complete("specdata", 30:25)
#result:      id    nobs
#     1       30    932
#     2       29    711
#     3       28    475
#     4       27    338
#     5       26    586
#     6       25    463
complete("specdata", 3)
#result:      id    nobs
#     1       3     243


#3

corr <- function(directory, threshold = 0){
  corr_result <- numeric(0)
  
  c <- complete(directory)
  c <- c[c$nobs>threshold, ]
  
  if(nrow(c)>0){
    files <- list.files(getwd(), full.names=TRUE) 
    data <- data.frame()
    for(num in c$id){
      data <- read.csv(files[num])
      selected_data <- data[(!is.na(data$sulfate)), ]
      selected_data <- selected_data[(!is.na(selected_data$nitrate)), ]
      sulfate <- selected_data["sulfate"]
      nitrate <- selected_data["nitrate"]
      corr_result <- c(corr_result, cor(sulfate, nitrate))
    }
  }
  corr_result
}

#Sample output

cr<-corr("specdata", 150)
head(cr); summary(cr)
#result:
# -0.01895754 -0.14051254 -0.04389737 -0.06815956 -0.12350667 -0.07588814
#     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-0.21057 -0.05147  0.09333  0.12401  0.26836  0.76313 

cr<-corr("specdata", 400)
head(cr); summary(cr)
#result:
#-0.01895754 -0.04389737 -0.06815956 -0.07588814  0.76312884 -0.15782860
#     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
#-0.17623 -0.03109  0.10021  0.13969  0.26849  0.76313 

cr<-corr("specdata", 5000)
head(cr); summary(cr); length(cr)
#result:  numeric(0)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#[1] 0

cr<-corr("specdata")
head(cr); summary(cr); length(cr)
#[1] -0.22255256 -0.01895754 -0.14051254 -0.04389737 -0.06815956 -0.12350667
#     Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
# -1.00000 -0.05282  0.10719  0.13684  0.27831  1.00000        9 
#[1] 332


#4

setwd("/Desktop") #setting the working directory to where the files are located
outcome <- read.csv('outcome-of-care-measures.csv', colClasses = "character")

head(outcome)

ncol(outcome) 
#result: 46
nrow(outcome)
#result: 4706
names(outcome)

outcome[, 11] <- as.numeric(outcome[, 11])

hist(outcome[, 11], main="Hospital 30-Day Death (Mortality) Rates from Heart Attack", xlab="Deaths", ylab="Frequency", col="light blue")
