###############################################
# Course: IST 687
# Assignment: Final Project Deliverable
# Team Members: Deery-Schmitt, Sam
#               Huang, Cliff
#               Onyeugbo, Glory
###############################################

packrat::init()

# if packrat::init() fails then run the pkg install function and then run packrat::init()

# List the packages to install
pkg <- c("packrat", "dplyr", "viridis", "Interpol.T", "lubridate", "ggExtra", "tidyr", "reshape2", "grid", "gridExtra", "lattice", "e1071")

# Use this function to install packages
install_if_missing <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) {
    install.packages(new.pkg, dependencies = TRUE)
  }
}

# Now apply the function on the packages
install_if_missing(pkg)

# libraries

require(ggplot2)
require(dplyr)
require(viridis)
require(Interpol.T)
require(lubridate)
require(ggExtra)
require(tidyr)
require(reshape2)
require(grid)
require(gridExtra)
require(lattice)
require(e1071)

# run if having issues
# unlink("./packrat", recursive = TRUE)
# packrat::clean()
# packrat::restore()

packrat::snapshot()

# run this if getting wrong snapshot
# packrat::snapshot(ignore.stale=TRUE)


###############################################
# data
# subset of the csv files available from
# 'https://www.kaggle.com/sudalairajkumar/cryptocurrencypricehistory'

#------------------------------------------------------------------------------
# II. DATA ACQUISITION AND MUNGING
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Data Acquisition
#------------------------------------------------------------------------------

bitcoin <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Bitcoin.csv")
cardano <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Cardano.csv")
dogecoin <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Dogecoin.csv")
eos <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_EOS.csv")
ethereum <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Ethereum.csv")
iota <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Iota.csv")
litecoin <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Litecoin.csv")
monero <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Monero.csv")
stellar <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Stellar.csv")
tron <- read.csv("C:\\Users\\SamDe\\Desktop\\MS\\IST_687_Applied_Data_Science\\coin_Tron.csv")

#------------------------------------------------------------------------------
# Structure and Summary of Raw Data
#------------------------------------------------------------------------------

str(bitcoin)
summary(bitcoin)
str(cardano)
summary(cardano)
str(dogecoin)
summary(dogecoin)
str(ethereum)
summary(ethereum)
str(eos)
summary(eos)
str(iota)
summary(iota)
str(litecoin)
summary(litecoin)
str(monero)
summary(monero)
str(stellar)
summary(stellar)
str(tron)
summary(tron)

#------------------------------------------------------------------------------
# Munging
#------------------------------------------------------------------------------
# Creating a composite data frame

# identify the shortest data frame
head(cardano)
# cardano starts at 2017-10-02
# get all data frames to same time frame
bitcoin <- bitcoin[which(bitcoin$Date == '2017-10-02 23:59:59'): dim(bitcoin)[1],]
dogecoin <- dogecoin[which(dogecoin$Date == '2017-10-02 23:59:59'): dim(dogecoin)[1],]
eos <- eos[which(eos$Date == '2017-10-02 23:59:59'): dim(eos)[1],]
ethereum <- ethereum[which(ethereum$Date == '2017-10-02 23:59:59'): dim(ethereum)[1],]
iota <- iota[which(iota$Date == '2017-10-02 23:59:59'): dim(iota)[1],]
litecoin <- litecoin[which(litecoin$Date == '2017-10-02 23:59:59'): dim(litecoin)[1],]
monero <- monero[which(monero$Date == '2017-10-02 23:59:59'): dim(monero)[1],]
stellar <- stellar[which(stellar$Date == '2017-10-02 23:59:59'): dim(stellar)[1],]
tron <- tron[which(tron$Date == '2017-10-02 23:59:59'): dim(tron)[1],]

#check to see if dates match
all.equal(bitcoin$Date,
          cardano$Date,
          dogecoin$Date,
          eos.df$Date,
          iota$Date,
          iota.df$Date,
          litecoin$Date,
          monero$Date,
          stellar$Date,
          tron$Date
)

# create composite data frame
cryptos <- data.frame(bitcoin$Date,
                      bitcoin$Symbol,  bitcoin$High,  bitcoin$Low,   bitcoin$Open,    bitcoin$Close,      bitcoin$Volume,  bitcoin$Marketcap,
                      cardano$Symbol,  cardano$High,  cardano$Low,   cardano$Open,    cardano$Close,      cardano$Volume,  cardano$Marketcap,
                      dogecoin$Symbol, dogecoin$High, dogecoin$Low,  dogecoin$Open,   dogecoin$Close,     dogecoin$Volume, dogecoin$Marketcap,
                      eos$Symbol,      eos$High,      eos$Low,       eos$Open,        eos$Close,          eos$Volume,      eos$Marketcap,
                      ethereum$Symbol, ethereum$High, ethereum$Low,  ethereum$Open,   ethereum$Close,     ethereum$Volume, ethereum$Marketcap,
                      iota$Symbol,     iota$High,     iota$Low,      iota$Open,       iota$Close,         iota$Volume,     iota$Marketcap,
                      litecoin$Symbol, litecoin$High, litecoin$Low,  litecoin$Open,   litecoin$Close,     litecoin$Volume, litecoin$Marketcap,
                      monero$Symbol,   monero$High,   monero$Low,    monero$Open,     monero$Close,       monero$Volume,   monero$Marketcap,
                      stellar$Symbol,  stellar$High,  stellar$Low,   stellar$Open,    stellar$Close,      stellar$Volume,  stellar$Marketcap,
                      tron$Symbol,     tron$High,     tron$Low,      tron$Open,       tron$Close,         tron$Volume,     tron$Marketcap)
# give intuitive column names
colnames(cryptos) <- c('date',
                       'btc.symbol',  'btc.high',  'btc.low',  'btc.open',  'btc.close',  'btc.vol',  'btc.mktcap',
                       'ada.symbol',  'ada.high',  'ada.low',  'ada.open',  'ada.close',  'ada.vol',  'ada.mktcap',
                       'doge.symbol', 'doge.high', 'doge.low', 'doge.open', 'doge.close', 'doge.vol', 'doge.mktcap',
                       'eos.symbol',  'eos.high',  'eos.low',  'eos.open',  'eos.close',  'eos.vol',  'eos.mktcap',
                       'eth.symbol',  'eth.high',  'eth.low',  'eth.open',  'eth.close',  'eth.vol',  'eth.mktcap',
                       'iota.symbol', 'iota.high', 'iota.low', 'iota.open', 'iota.close', 'iota.vol', 'iota.mktcap',
                       'ltc.symbol',  'ltc.high',  'ltc.low',  'ltc.open',  'ltc.close',  'ltc.vol',  'ltc.mktcap',
                       'xmr.symbol',  'xmr.high',  'xmr.low',  'xmr.open',  'xmr.close',  'xmr.vol',  'xmr.mktcap',
                       'xlm.symbol',  'xlm.high',  'xlm.low',  'xlm.open',  'xlm.close',  'xlm.vol',  'xlm.mktcap',
                       'trx.symbol',  'trx.high',  'trx.low',  'trx.open',  'trx.close',  'trx.vol',  'trx.mktcap')

# change from character to date; remove hours, minutes, seconds
cryptos$date <- as.Date(cryptos$date) 

# create calculated columns

attach(cryptos)
# create a function to calculate the percent change over 24 hours between the values in any two columns
daily_change <- function(current_value, previous_value) {
  DailyPercentChange <- 100*(current_value - previous_value)/previous_value
  return(DailyPercentChange)
} 

# calculate daily percent returns for each coin
cryptos$btc.daily_return  <- daily_change(btc.close, btc.open)
cryptos$ada.daily_return  <- daily_change(ada.close,ada.open)
cryptos$doge.daily_return <- daily_change(doge.close, doge.open)
cryptos$eos.daily_return  <- daily_change(eos.close, eos.open)
cryptos$eth.daily_return  <- daily_change(eth.close, eth.open)
cryptos$iota.daily_return <- daily_change(iota.close, iota.open)
cryptos$ltc.daily_return  <- daily_change(ltc.close, ltc.open)
cryptos$xmr.daily_return  <- daily_change(xmr.close, xmr.open)
cryptos$xlm.daily_return  <- daily_change(xlm.close, xlm.open)
cryptos$trx.daily_return  <- daily_change(trx.close, trx.open)

# create a function to calculate daily percent change in volume
daily_volume_change <- function(coin.vol){
  volume_change <- daily_change(coin.vol, c(coin.vol[1], coin.vol[-length(coin.vol)]))
  return(volume_change)
}

# calculate daily change in volume for each coin
cryptos$btc.daily_volume_change <- daily_volume_change(btc.vol)
cryptos$ada.daily_volume_change <- daily_volume_change(ada.vol)
cryptos$doge.daily_volume_change <- daily_volume_change(doge.vol)
cryptos$eos.daily_volume_change <- daily_volume_change(eos.vol)
cryptos$eth.daily_volume_change <- daily_volume_change(eth.vol)
cryptos$iota.daily_volume_change <- daily_volume_change(iota.vol)
cryptos$ltc.daily_volume_change <- daily_volume_change(ltc.vol)
cryptos$xmr.daily_volume_change <- daily_volume_change(xmr.vol)
cryptos$xlm.daily_volume_change <- daily_volume_change(xlm.vol)
cryptos$trx.daily_volume_change <- daily_volume_change(trx.vol)

# create a function to define 'big day' as a day with at least 5% returns
isBigDay <- function(col){
  returncol <- c()
  for(i in 1:length(col)){
    if(col[i]>=5){
      returncol[i] <- 1
    } else {
      returncol[i] <- 0
    }
  }
  return(returncol)
}

attach(cryptos)

# make a big_days column 
cryptos$btc.big_day <- as.factor(isBigDay(btc.daily_return))
cryptos$ada.big_day <- as.factor(isBigDay(ada.daily_return))
cryptos$doge.big_day <- as.factor(isBigDay(doge.daily_return))
cryptos$eos.big_day <- as.factor(isBigDay(eos.daily_return))
cryptos$eth.big_day <- as.factor(isBigDay(eth.daily_return))
cryptos$iota.big_day <- as.factor(isBigDay(iota.daily_return))
cryptos$ltc.big_day <- as.factor(isBigDay(ltc.daily_return))
cryptos$xmr.big_day <- as.factor(isBigDay(xmr.daily_return))
cryptos$xlm.big_day <- as.factor(isBigDay(xlm.daily_return))
cryptos$trx.big_day <- as.factor(isBigDay(trx.daily_return))


# create a function to check vector for NAs, just in case there are NAs in the calculated columns
NAcheck <- function(vector) {
  if (sum(is.na(vector)) > 0)
    paste("WARNING: There are", sum(is.na(vector)), "NAs in", deparse(substitute(vector)))
  else paste("0 NAs")
}

# search every column for NAs
sapply(cryptos, NAcheck)

# melt data frame into 3 columns: date, coin, daily return
# will be used for heat map analysis

cryptos.molten <- melt(data=cryptos, id.vars='date', measure.vars=colnames(cryptos)[72:81])
# View(cryptos.molten)

#------------------------------------------------------------------------------
# Structure and Summary of Munged Data
#------------------------------------------------------------------------------

summary(cryptos)
str(cryptos)

summary(cryptos.molten)
str(cryptos.molten)
unique(cryptos.molten$variable)

#----------------------------------------------------------------------------------------------------------
# Interesting Findings after Munging
#---------------------------------------------------------------------------------------------------------- 

# market cap
mktcap.multiLine <- ggplot(cryptos, aes(x = date)) + geom_line(aes (y = btc.mktcap, color = "btc.mktcap")) + 
  geom_line(aes (y = doge.mktcap, color = "doge.mktcap")) + geom_line(aes(y = xmr.mktcap, color = "xmr.mktcap")) + 
  geom_line(aes(y = xlm.mktcap, color = "xlm.mktcap")) + geom_line(aes(y = ltc.mktcap, color = "ltc.mktcap")) +
  geom_line(aes(y = ada.mktcap, color = "ada.mktcap")) + geom_line(aes(y = eos.mktcap, color = "eos.mktcap")) +
  geom_line(aes(y = eth.mktcap, color = "eth.mktcap")) + geom_line(aes(y = iota.mktcap, color = "iota.mktcap")) +
  geom_line(aes(y = trx.mktcap, color = "trx.mktcap"))
mktcap.multiLine <- mktcap.multiLine + ggtitle("Market Capitalization by Cryptocurrency") + ylab('Market Capitalization in USD')
mktcap.multiLine

# daily returns
daily_return.multiLine <- ggplot(cryptos, aes(x = date)) + geom_line(aes (y = btc.daily_return, color = "btc.daily_return")) + 
  geom_line(aes (y = doge.daily_return, color = "doge.daily_return")) + geom_line(aes(y = xmr.daily_return, color = "xmr.daily_return")) + 
  geom_line(aes(y = xlm.daily_return, color = "xlm.daily_return")) + geom_line(aes(y = ltc.daily_return, color = "ltc.daily_return")) +
  geom_line(aes(y = ada.daily_return, color = "ada.daily_return")) + geom_line(aes(y = eos.daily_return, color = "eos.daily_return")) +
  geom_line(aes(y = eth.daily_return, color = "eth.daily_return")) + geom_line(aes(y = iota.daily_return, color = "iota.daily_return")) +
  geom_line(aes(y = trx.daily_return, color = "trx.daily_return"))
daily_return.multiLine <- daily_return.multiLine + ggtitle("Daily Return by Cryptocurrency") + ylab('Daily Return (Percentage)')
daily_return.multiLine

# trading volume
volume.multiLine <- ggplot(cryptos, aes(x = date)) + geom_line(aes (y = btc.vol, color = "btc.vol")) + 
  geom_line(aes (y = doge.vol, color = "doge.vol")) + geom_line(aes(y = xmr.vol, color = "xmr.vol")) + 
  geom_line(aes(y = xlm.vol, color = "xlm.vol")) + geom_line(aes(y = ltc.vol, color = "ltc.vol")) +
  geom_line(aes(y = ada.vol, color = "ada.vol")) + geom_line(aes(y = eos.vol, color = "eos.vol")) +
  geom_line(aes(y = eth.vol, color = "eth.vol")) + geom_line(aes(y = iota.vol, color = "iota.vol")) +
  geom_line(aes(y = trx.vol, color = "trx.vol"))
volume.multiLine <- volume.multiLine + ggtitle("Trading Volume by Cryptocurrency") + ylab('Volume')
volume.multiLine

# daily volume change
daily_volume_change.multiLine <- ggplot(cryptos, aes(x = date)) + geom_line(aes (y = btc.daily_volume_change, color = "btc.daily_volume_change")) + 
  geom_line(aes (y = doge.daily_volume_change, color = "doge.daily_volume_change")) + geom_line(aes(y = xmr.daily_volume_change, color = "xmr.daily_volume_change")) + 
  geom_line(aes(y = xlm.daily_volume_change, color = "xlm.daily_volume_change")) + geom_line(aes(y = ltc.daily_volume_change, color = "ltc.daily_volume_change")) +
  geom_line(aes(y = ada.daily_volume_change, color = "ada.daily_volume_change")) + geom_line(aes(y = eos.daily_volume_change, color = "eos.daily_volume_change")) +
  geom_line(aes(y = eth.daily_volume_change, color = "eth.daily_volume_change")) + geom_line(aes(y = iota.daily_volume_change, color = "iota.daily_volume_change")) +
  geom_line(aes(y = trx.daily_volume_change, color = "trx.vol"))
daily_volume_change.multiLine <- daily_volume_change.multiLine + ggtitle("Daily Volume Change by Cryptocurrency") + ylab('Daily Volume Change (Percent)')
daily_volume_change.multiLine

# price
price.multiLine <- ggplot(cryptos, aes(x = date)) + geom_line(aes (y = btc.high, color = "btc.high")) + 
  geom_line(aes (y = doge.high, color = "doge.high")) + geom_line(aes(y = xmr.high, color = "xmr.high")) + 
  geom_line(aes(y = xlm.high, color = "xlm.high")) + geom_line(aes(y = ltc.high, color = "ltc.high")) +
  geom_line(aes(y = ada.high, color = "ada.high")) + geom_line(aes(y = eos.high, color = "eos.high")) +
  geom_line(aes(y = eth.high, color = "eth.high")) + geom_line(aes(y = iota.high, color = "iota.high")) +
  geom_line(aes(y = trx.high, color = "trx.high"))
price.multiLine <- price.multiLine + ggtitle("Price by Cryptocurrency") + ylab('Daily High in USD')
price.multiLine

#----------------------------------------------------------------------------------------------------------
# III. DATA SET DESCRIPTIVE STATISTICS AND STRUCTURE
#---------------------------------------------------------------------------------------------------------- 
# price vs volume by coin

#btc - price and volume
btc.chart <- ggplot(data=cryptos, aes(date, btc.high)) +   
  geom_point(aes(color=btc.vol, size=btc.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('btc - price and volume')
btc.chart
# we can see that as the price spikes, volume also spikes

#ada - price and volume
ada.chart <- ggplot(data=cryptos, aes(date, ada.high)) +   
  geom_point(aes(color=ada.vol, size=ada.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('ada - price and volume')
ada.chart
# the trend looks consistent and even stronger in cardano

#doge - price and volume
doge.chart <- ggplot(data=cryptos, aes(date, doge.high)) +   
  geom_point(aes(color=doge.vol, size=doge.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('doge - price and volume')
doge.chart

#eos - price and volume
eos.chart <- ggplot(data=cryptos, aes(date, eos.high)) +   
  geom_point(aes(color=eos.vol, size=eos.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('eos - price and volume')
eos.chart
# increase in EOS volume is perhaps a bullish signal based on our inferences

#eth - price and volume
eth.chart <- ggplot(data=cryptos, aes(date, eth.high)) +   
  geom_point(aes(color=eth.vol, size=eth.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('eth - price and volume')
eth.chart

#iota - price and volume
iota.chart <- ggplot(data=cryptos, aes(date, iota.high)) +   
  geom_point(aes(color=iota.vol, size=iota.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('iota - price and volume')
iota.chart

#ltc - price and volume
ltc.chart <- ggplot(data=cryptos, aes(date, ltc.high)) +   
  geom_point(aes(color=ltc.vol, size=ltc.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('ltc - price and volume')
ltc.chart

#xmr - price and volume
xmr.chart <- ggplot(data=cryptos, aes(date, xmr.high)) +   
  geom_point(aes(color=xmr.vol, size=xmr.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('xmr - price and volume')
xmr.chart

#xlm - price and volume
xlm.chart <- ggplot(data=cryptos, aes(date, xlm.high)) +   
  geom_point(aes(color=xlm.vol, size=xlm.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('xlm - price and volume')
xlm.chart

#trx - price and volume
trx.chart <- ggplot(data=cryptos, aes(date, trx.high)) +   
  geom_point(aes(color=trx.vol, size=trx.vol), alpha=0.3) +
  scale_color_gradient(high='red', low='white') +
  theme(panel.background = element_rect(fill = "darkblue")) +
  ggtitle('trx - price and volume')
trx.chart

# Altcoin to BTC price correlation plots

#ada to btc - correlation
adatobtc.plot <- ggplot(data=cryptos, aes(ada.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('ADA to BTC Price Correlation')
adatobtc.plot

#doge to btc - correlation
dogetobtc.plot <- ggplot(data=cryptos, aes(doge.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('DOGE to BTC Price Correlation')
dogetobtc.plot

#eos to btc - correlation
eostobtc.plot <- ggplot(data=cryptos, aes(eos.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('EOS to BTC Price Correlation')
eostobtc.plot

#eth to btc - correlation
ethtobtc.plot <- ggplot(data=cryptos, aes(eth.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('ETH to BTC Price Correlation')
ethtobtc.plot

#iota to btc - correlation
iotatobtc.plot <- ggplot(data=cryptos, aes(iota.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('Iota to BTC Price Correlation')
iotatobtc.plot
#ltc to btc - correlation
ltctobtc.plot <- ggplot(data=cryptos, aes(ltc.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('LTC to BTC Price Correlation')
ltctobtc.plot
#xmr to btc - correlation
xmrtobtc.plot <- ggplot(data=cryptos, aes(xmr.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('XMR to BTC Price Correlation')
xmrtobtc.plot
#xlm to btc - correlation
xlmtobtc.plot <- ggplot(data=cryptos, aes(xlm.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('XLM to BTC Price Correlation')
xlmtobtc.plot
#trx to btc - correlation
trxtobtc.plot <- ggplot(data=cryptos, aes(trx.high, btc.high)) + 
  geom_jitter() + geom_smooth() + ggtitle('TRX to BTC Price Correlation')
trxtobtc.plot

grid.arrange(adatobtc.plot, eostobtc.plot, nrow=1) #eos is the outlier - only one with p-value that is not near-zero (0.6)
grid.arrange(dogetobtc.plot, ethtobtc.plot, nrow=1)

# heat map with all daily returns

# creating heat map
ggplot(data=cryptos.molten, aes(x=date, y=variable, group=variable, fill=value)) + 
  geom_tile(size=0.1) + ggtitle('Volatility Heatmap') +
  scale_fill_gradient2(low='red', mid='white', high='black', midpoint=0)
# on the heat map, we can see the darkest days as the days with extreme volatility on the positive side
# anything areas with a shade of red indicates extreme negative volatility

summary(cryptos.molten)
min(cryptos.molten$value)
max(cryptos.molten$value)
quantile(cryptos.molten$value, c(0.01, 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9, 0.99)) 
# 98% percent of the percent return values lie between -15.08 and 20.82 percent
# the min and max are -42.3 and 355.62, respectively, indicating some heavy outliers

# which altcoin had the most days out of the top 100
# which of the coins produced the most positive outliers?
cryptos.100_most_positive_returns <- cryptos.molten[order(-cryptos.molten$value),]
cryptos.100_most_positive_returns <- cryptos.100_most_positive_returns[1:100,]
cryptos.100_most_positive_returns # view 100 most positive return days
cryptos.100_most_positive_returns <- cryptos.100_most_positive_returns[order(cryptos.100_most_positive_returns$variable, -cryptos.100_most_positive_returns$value),]
cryptos.100_most_positive_returns # view 100 most positive return days by crypto
# only one of the 100 most positive returns belonged to btc
summary(cryptos.100_most_positive_returns$variable)
# stellar had 18 of the top 100 positive outliers, followed by tron (17), cardano (15), iota (14), doge (13), eos (11)

# which of the coins produced the most negative outliers?
cryptos.100_most_negative_returns <- cryptos.molten[order(cryptos.molten$value),]
cryptos.100_most_negative_returns <- cryptos.100_most_negative_returns[1:100,]
cryptos.100_most_negative_returns # view 100 most negative return days
cryptos.100_most_negative_returns <- cryptos.100_most_negative_returns[order(cryptos.100_most_negative_returns$variable, cryptos.100_most_negative_returns$value),]
cryptos.100_most_negative_returns # view 100 most negative return days by crypto
summary(cryptos.100_most_negative_returns$variable)
#btc had 2 of the top 100 negative outliers
#tron had the most (18), eos (16), iota (12), doge (10), cardano (10), stellar (10)

positiveData <- summary(cryptos.100_most_positive_returns$variable)
cryptoNames <- names(positiveData)
names(positiveData) <- NULL
pData <- data.frame(cryptoNames, positiveData)
pData
top100returns <- ggplot(pData, aes(cryptoNames, positiveData)) + 
  geom_bar(stat='identity', aes(fill=cryptoNames)) +
  theme(axis.text.x=element_text(angle = -90, hjust = 0)) +
  theme(panel.background = element_rect(fill = 'white')) + 
  ylab('Number of Days') + xlab('Cryptocurrency') +
  ggtitle('Top 100 Return Days by Crypto')

negativeData <- summary(cryptos.100_most_negative_returns$variable)
cryptoNames <- names(negativeData)
names(negativeData) <- NULL
nData <- data.frame(cryptoNames, negativeData)

neg100returns <- ggplot(nData, aes(cryptoNames, negativeData)) +
  geom_bar(stat='identity', aes(fill=cryptoNames)) +
  theme(axis.text.x=element_text(angle = -90, hjust = 0)) +
  theme(panel.background = element_rect(fill = 'white')) + 
  ylab('Number of Days') + xlab('Cryptocurrency') +
  ggtitle('Lowest 100 Return Days by Crypto')

grid.arrange(top100returns, neg100returns, nrow=1)

# Histograms

btc.histdata <- cryptos[order(-cryptos$btc.daily_return), c('date','btc.symbol','btc.high','btc.daily_return')]
btc.hist <- ggplot(data=btc.histdata, aes(x=btc.daily_return)) + geom_histogram()

ada.histdata <- cryptos[order(-cryptos$ada.daily_return), c('date','ada.symbol','ada.high','ada.daily_return')]
ada.hist <- ggplot(data=ada.histdata, aes(x=ada.daily_return)) + geom_histogram()

doge.histdata <- cryptos[order(-cryptos$doge.daily_return), c('date','doge.symbol','doge.high','doge.daily_return')]
doge.hist <- ggplot(data=doge.histdata, aes(x=doge.daily_return)) + geom_histogram()

eos.histdata <- cryptos[order(-cryptos$eos.daily_return), c('date','eos.symbol','eos.high','eos.daily_return')]
eos.hist <- ggplot(data=eos.histdata, aes(x=eos.daily_return)) + geom_histogram()

eth.histdata <- cryptos[order(-cryptos$eth.daily_return), c('date','eth.symbol','eth.high','eth.daily_return')]
eth.hist <- ggplot(data=eth.histdata, aes(x=eth.daily_return)) + geom_histogram()

iota.histdata <- cryptos[order(-cryptos$iota.daily_return), c('date','iota.symbol','iota.high','iota.daily_return')]
iota.hist <- ggplot(data=iota.histdata, aes(x=iota.daily_return)) + geom_histogram()

ltc.histdata <- cryptos[order(-cryptos$ltc.daily_return), c('date','ltc.symbol','ltc.high','ltc.daily_return')]
ltc.hist <- ggplot(data=ltc.histdata, aes(x=ltc.daily_return)) + geom_histogram()

xmr.histdata <- cryptos[order(-cryptos$xmr.daily_return), c('date','xmr.symbol','xmr.high','xmr.daily_return')]
xmr.hist <- ggplot(data=xmr.histdata, aes(x=xmr.daily_return)) + geom_histogram()

xlm.histdata <- cryptos[order(-cryptos$xlm.daily_return), c('date','xlm.symbol','xlm.high','xlm.daily_return')]
xlm.hist <- ggplot(data=xlm.histdata, aes(x=xlm.daily_return)) + geom_histogram()

trx.histdata <- cryptos[order(-cryptos$trx.daily_return), c('date','trx.symbol','trx.high','trx.daily_return')]
trx.hist <- ggplot(data=trx.histdata, aes(x=trx.daily_return)) + geom_histogram()

grid.arrange(btc.hist, eth.hist, nrow=1) # we can see the daily percent returns all follow a fairly normal distribution
grid.arrange(eos.hist, xlm.hist, nrow=1) # some altcoins have lower counts in the 0 range, around the 400 range
grid.arrange(doge.hist, trx.hist, nrow=1) # some altcoins have very high counts in the 0 range, in the 900 range

#-------------------------------------------------------------------------------------------
# IV. MODELS
#-------------------------------------------------------------------------------------------

# creating linear models
lm.adafrombtc <- lm(formula=ada.high~btc.high)
summary(lm.adafrombtc)

lm.eosfrombtc <- lm(formula=eos.high~btc.high)
summary(lm.eosfrombtc)
#interesting to see that btc~xlm has a p-value of 0.6
#compared to the near zero p-value in btc~ada

lm.iotafrombtc <- lm(formula=iota.high~btc.high)
summary(lm.iotafrombtc)

lm.xlmfrombtc <- lm(formula=xlm.high~btc.high)
summary(lm.xlmfrombtc)

lm.trxfrombtc <- lm(formula=trx.high~btc.high)
summary(lm.trxfrombtc)

lm.dogefrombtc <- lm(formula=doge.high~btc.high)
summary(lm.dogefrombtc)
#eos is the only coin that seems to have a life of its own, so to speak,
#in regards to its price movement

#-------------------------------------------------------------------------------------------
# creating SVMs
#-------------------------------------------------------------------------------------------
# use daily return, and daily volume change to predict volatile days in altcoins

attach(cryptos)
#preparing train and test data
set.seed(150)
randIndex <- sample(1:dim(cryptos)[1]) #creating randomized index to ensure fairness in data selection
cutPoint9_10 <- floor(9 * dim(cryptos)[1]/10) #creating cutpoint to group 9/10 of randomly selected data for training
trainData <-cryptos[randIndex[1:cutPoint9_10],] #create training data set
testData <-cryptos[randIndex[(cutPoint9_10+1):dim(cryptos)[1]],] #create testing data set

#Cardano
ada.svm1 <- svm(ada.big_day~btc.daily_return, data=trainData) #creating models
ada.svm1 
ada.svm2 <- svm(ada.big_day~btc.daily_volume_change, data=trainData) 
ada.svm2
ada.svm3 <- svm(ada.big_day~btc.daily_volume_change + btc.daily_return, data=trainData)
ada.svm3
ada.predict1 <- predict(ada.svm1, testData) #creating predictions
ada.predict2 <- predict(ada.svm2, testData)
ada.predict3 <- predict(ada.svm3, testData)
ada.error1 <- as.numeric(testData$ada.big_day) - as.numeric(ada.predict1) #measuring errors
ada.error2 <- as.numeric(testData$ada.big_day) - as.numeric(ada.predict2)
ada.error3 <- as.numeric(testData$ada.big_day) - as.numeric(ada.predict3)

# model 1 accuracy
ada.svm1.predict.accuracy <- (table(ada.predict1 ,testData$ada.big_day)[1,1] 
                              + table(ada.predict1 ,testData$ada.big_day)[2,2]) / length(testData$ada.big_day)
ada.svm1.predict.accuracy

# model 2 accuracy
ada.svm2.predict.accuracy <- (table(ada.predict2 ,testData$ada.big_day)[1,1] 
                              + table(ada.predict2 ,testData$ada.big_day)[2,2]) / length(testData$ada.big_day)
ada.svm2.predict.accuracy

# model 3 accuracy
ada.svm3.predict.accuracy <- (table(ada.predict3 ,testData$ada.big_day)[1,1] 
                              + table(ada.predict3 ,testData$ada.big_day)[2,2]) / length(testData$ada.big_day)
ada.svm3.predict.accuracy

#Eos
eos.svm1 <- svm(eos.big_day~btc.daily_return, data=trainData) #creating models
eos.svm1
eos.svm2 <- svm(eos.big_day~btc.daily_volume_change, data=trainData) 
eos.svm2
eos.svm3 <- svm(eos.big_day~btc.daily_volume_change + btc.daily_return, data=trainData)
eos.svm3
eos.predict1 <- predict(eos.svm1, testData) #creating predictions
eos.predict2 <- predict(eos.svm2, testData)
eos.predict3 <- predict(eos.svm3, testData)
eos.error1 <- as.numeric(testData$eos.big_day) - as.numeric(eos.predict1) #measuring errors
eos.error2 <- as.numeric(testData$eos.big_day) - as.numeric(eos.predict2)
eos.error3 <- as.numeric(testData$eos.big_day) - as.numeric(eos.predict3)

# model 1 accuracy
eos.svm1.predict.accuracy <- (table(eos.predict1 ,testData$eos.big_day)[1,1] 
                              + table(eos.predict1 ,testData$eos.big_day)[2,2]) / length(testData$eos.big_day)
eos.svm1.predict.accuracy

# model 2 accuracy
eos.svm2.predict.accuracy <- (table(eos.predict2 ,testData$eos.big_day)[1,1] 
                              + table(eos.predict2 ,testData$eos.big_day)[2,2]) / length(testData$eos.big_day)
eos.svm2.predict.accuracy

# model 3 accuracy
eos.svm3.predict.accuracy <- (table(eos.predict3 ,testData$eos.big_day)[1,1] 
                              + table(eos.predict3 ,testData$eos.big_day)[2,2]) / length(testData$eos.big_day)
eos.svm3.predict.accuracy


#eth
eth.svm1 <- svm(eth.big_day~btc.daily_return, data=trainData) #creating models
eth.svm1
eth.svm2 <- svm(eth.big_day~btc.daily_volume_change, data=trainData) 
eth.svm2
eth.svm3 <- svm(eth.big_day~btc.daily_volume_change + btc.daily_return, data=trainData)
eth.svm3
eth.predict1 <- predict(eth.svm1, testData) #creating predictions
eth.predict2 <- predict(eth.svm2, testData)
eth.predict3 <- predict(eth.svm3, testData)
eth.error1 <- as.numeric(testData$eth.big_day) - as.numeric(eth.predict1) #measuring errors
eth.error2 <- as.numeric(testData$eth.big_day) - as.numeric(eth.predict2)
eth.error3 <- as.numeric(testData$eth.big_day) - as.numeric(eth.predict3)

# model 1 accuracy
eth.svm1.predict.accuracy <- (table(eth.predict1 ,testData$eth.big_day)[1,1] 
                              + table(eth.predict1 ,testData$eth.big_day)[2,2]) / length(testData$eth.big_day)
eth.svm1.predict.accuracy

# model 2 accuracy
eth.svm2.predict.accuracy <- (table(eth.predict2 ,testData$eth.big_day)[1,1] 
                              + table(eth.predict2 ,testData$eth.big_day)[2,2]) / length(testData$eth.big_day)
eth.svm2.predict.accuracy

# model 3 accuracy
eth.svm3.predict.accuracy <- (table(eth.predict3 ,testData$eth.big_day)[1,1] 
                              + table(eth.predict3 ,testData$eth.big_day)[2,2]) / length(testData$eth.big_day)
eth.svm3.predict.accuracy

#to predict the big return days for altcoins, using only the volatility of btc was the best performer
# adding the percent change in volume of btc did not improve the model
#at times it actually weakened the model

detach(cryptos)
