

# PT_PHELPER
Addon script for Profit Trailer to automatically enable SOM for a specific pair if it goes beyond the user limit
The script can also enable global SOM in percentage average for TOP 10 market cap altcoins exceeds the limit

This is a very simple Bourne Shell script aimed to help avoiding bags in Profit Trailer.
It scans % difference for last 24 hours of all coins and if the percentage has crossed the limit, the PT_PHELPER
enables a SOM mode for the specific pair.

You can avoid buying a pair if it grew or dropped more than x% you specify as a parameter

The similar function is also implemented for global SOM, in this case the parameter indicates the limit
for percentage change of TOP 10 marketcap altcoins.

### Features

1) Enable coin-specific SOM is it crosses user limit
2) Enable global SOM if Top10 marketcap ALTs cross the user limit

### Instructions

point FILE variable to your PT PAIRS.properties file
setup a crontab statement to run the script every 5 minutes or so:

*/5     *       *       *       * /var/scripts/pairs_helper.sh BITTREX 15 15

There are 3 arguments:

1) exchange:   BITTREX / BINANCE / POLONIEX
2) coin SOM:   threshold to enable coin specific SOM in % (counted as change within 24h)
3) global SOM: threshold to enable global SOM if Top10 ALTs corss the avergae limit (within 24 hours) 

You can disable either 2) or 3) or both by specifying 0

### Requirements

Bourne Shell & curl

#### Result
The PT_PHELPER modifies your active PAIR.properties file changing all affected coins to SOM.

(it is recommended you do a backup of your PAIRS.properties file)

e.g.

BTC-UCASH_sell_only_mode = true

BTC-ZCL_sell_only_mode = true

##########################################################################

Even though it is a very simple script any donations are welcome :)))

BTC: 127vURZ3MwzFCmNLp1TubfGyxU7bb5BwQc

ETH: 0xe254cd63d727ed63eb7e4fa78bf5af8c4f5fe328

LTC: LP4x1TfDe36QcCj7o79Br8mWxTipLNdhY5
