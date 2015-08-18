quiz1<-function(){
  library(dplyr)
  if(!file.exists("./data")){dir.create("./data")}
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
  download.file(fileUrl, destfile = "./data/housing.csv")
  housing <- read.csv("./data/housing.csv")
  agricultureLogical <- c(housing$ACR == 3 & housing$AGS == 6)
  print(which(agricultureLogical)[1:3])
}

quiz2<-function(){
  library(jpeg)
  if(!file.exists("./data"))dir.create("./data")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
  download.file(fileUrl, destfile = "./data/getdataJeff.jpg", mode = "wb")
  img <- readJPEG("./data/getdataJeff.jpg", native = TRUE)
  quantile(x = img, probs = c(0.3, 0.8), type = 1)

}

quiz3<-function(){
  library(data.table)
  library(dplyr)
  if(!file.exists("./data"))dir.create("./data")
  fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
  fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
  gdp_row <- fread(input = fileUrl1, skip = 4, nrows = 231, select = c(1:2,4:5))
  setnames(gdp_row, c("CountryCode", "Ranking", "LongName", "gdp"))
  gdp <- gdp_row[1:190,]
  cty_row <- fread(input = fileUrl2, select = (1:9))
  print(sum(!is.na(match(gdp$CountryCode, cty_row$CountryCode))))
  print(arrange(gdp, desc(Ranking))$LongName[13])
  gdp_dt <- data.table(gdp)
  setkey(gdp_dt, CountryCode)
  cty_dt <- data.table(cty_tbl_df)
  setkey(cty_dt, CountryCode)
  gdp_cty_merge <- merge(gdp_dt, cty_dt)
  gdp_cty_tbl_df <- tbl_df(gdp_cty_merge)
  gdp_cty_tbl_df %>%
    select(Ranking, `Income Group`) %>%
    filter(!is.na(Ranking)) %>%
    group_by(`Income Group`) %>%
    summarise(mean(Ranking))

}

