

# PT_PHELPER
Addon [script](https://github.com/emx0r/PT_PHELPER/blob/master/pt_phelper.sh) for Profit Trailer to automatically enable SOM for a specific pair if it goes beyond the user limit.
The script can also enable global SOM if average percentage for TOP 10 market cap altcoins exceeds the limit

This is a very simple Bourne Shell script aimed to help avoiding bags in Profit Trailer.
It scans % difference for last 24 hours of all coins and if the percentage has crossed the limit, the PT_PHELPER
enables a SOM mode for the specific pair.

You can avoid buying a pair if it grew or dropped more than x% you specify as a parameter

The similar function is also implemented for global SOM, in this case the parameter indicates the limit
for percentage change of TOP 10 marketcap altcoins.

PT_PHELPER allows you to set SOM for a token if it was recently listed to an exchange. This functionality uses telegram-cli
and is described in instruction section.

### Features

- 1\) Enable coin-specific SOM if it crosses user limit (% in 24h)
- 2\) Enable global SOM if Top10 marketcap ALTs cross the user limit (avg % in 24h)
- 3\) Enable coin-specific SOM for newly listed token on exchange

### Instructions

Point FILE variable to your PT PAIRS.properties file.
Setup a crontab statement to run the script every 5 minutes or so:

`*/5     *       *       *       * /var/scripts/pairs_helper.sh BITTREX 15 15 14`

There are 4 arguments:

- 1\) exchange:   BITTREX / BINANCE / POLONIEX
- 2\) coin SOM:   threshold to enable coin specific SOM in % (counted as change within 24h)
- 3\) global SOM: threshold to enable global SOM if Top10 ALTs cross the average limit (within 24 hours) 
- 4\) new coin SOM: for how many days you want to have a SOM for newly listed coin on an exchange

You can disable any of 2), 3), 4) functions by passing argument 0

**! Never put your custom PAIR.properties settings below "PT_PHELPER@MK" string. It is an eyecatcher used by the script to
find the location where to write the data !**

** It is recommended to perform a backup of your PAIRS.properties file before running the script for the first time **

**Instructions for pt_phelper.sh script - to use telegram-cli for ignoring newly listed coins on a exchange:**

- Install or compile [telegram-cli](https://github.com/vysheng/tg) for your OS distribution

   (you need following packages or their alternative:  libreadline-dev libconfig-dev libssl1.0-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make)
   
- Run the telegram-cli under the user who will run the pt_phelper.sh script and join [Coin listing](https://t.me/coin_listing) channel
- Update tgPath variable in the script to point to telegram-cli bin
- when running a script use 4th argument to specify for how many days you want to ignore the coin.
  0 disables this feature.
  
  `*/5     *       *       *       * /var/scripts/pt_phelper.sh BITTREX 15 15 7`


### Requirements

Bourne Shell, curl, bc, telegram-cli (optional)

#### Result
The PT_PHELPER modifies your active PAIR.properties file changing all affected coins to SOM.

(it is recommended you do a backup of your PAIRS.properties file)

e.g.


![Alt text](newCoins.png?raw=true "PAIRS")

##########################################################################

Even though it is a very simple script any donations are welcome :)))

BTC: 127vURZ3MwzFCmNLp1TubfGyxU7bb5BwQc

ETH: 0xe254cd63d727ed63eb7e4fa78bf5af8c4f5fe328

LTC: LP4x1TfDe36QcCj7o79Br8mWxTipLNdhY5
