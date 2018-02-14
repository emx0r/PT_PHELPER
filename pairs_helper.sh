#!/bin/sh
# Description
# -------------
# PT_PHELPER script aims to avoid DCA bags by constantly watching
# percentage changes for ALT coins and if 24h limit given by user
# is exceeded, it activates COIN-specific SOM.
#
# It can also enable global SOM, if TOP10 ALTcoins cross the 
# % average change.
# 
# Instructions
#
# Let the script run from cron, passing your echange and limits as 
# parameters.
# 
# 1. parm: BITTREX / BINANCE / POLONIEX
# 2. parm: 24h % change for altcoins to enable COIN specific SOM
# 3. parm: 24h % change average for TOP 10 marketcap altcoins 
#    	   to enable global SOM
#
# Functions 2 and 3 can be disabled by using "0" 
#
# e.g. */5 * * * * /var/scripts/pairs_helper.sh BITTREX 15 15
#
# Donations are welcome
# ----------------------
# BTC: 127vURZ3MwzFCmNLp1TubfGyxU7bb5BwQc
# ETH: 0xe254cd63d727ed63eb7e4fa78bf5af8c4f5fe328
# LTC: LP4x1TfDe36QcCj7o79Br8mWxTipLNdhY5

writePair()
{
	a=$1
    b=$2
    o=$3
    case `echo "a=$a;b=$b;r=-1;if(a==b)r=0;if(a"$o"b)r=1;r"|bc` in
           1) echo  $cEx"_sell_only_mode = true" >> $file; echo "# $diffPct% $o $limit%" >> $file
           ;; esac

}

writeSOM()
{
	a=$1
	b=$2
	o=$3
	case `echo "a=$a;b=$b;r=-1;if(a==b)r=0;if(a"$o"b)r=1;r"|bc` in
          1) echo  "ALL_sell_only_mode = true" >> $file; echo "# Average for Top10 ALTs beyond limit: $a $o $b" >> $file
          ;; esac
}


####MAIN PART####

exchange=$1  #PASS BITTREX, BINANCE, POLONIEX
limit=$2     #PASS % LIMIT TO PUT A PAIR INTO SOM; 0 DISABLES THIS FUNCTION
altSOM=$3    #PASS % FOR AVERAGE OF TOP 10 ALTCOINS WHEN TO ENABLE GLOBAL SOM; 0 DISABLES THIS FUNCTION
market=BTC   # by default we trade BTC, change if needed
file=PAIRS.properties #put the path to your PAIRS.properties file

dt=`date`





list=`curl --silent https://api.coinmarketcap.com/v1/ticker/ | grep -e symbol -e percent_change_24h | cut -f4 -d'"' | xargs -n 2 | awk '{ print $1":"$2 }'`
btcPct=`curl --silent https://api.coinmarketcap.com/v1/ticker/bitcoin/ | grep percent_change_24h | cut -f4 -d'"'`
altPct=`curl --silent https://api.coinmarketcap.com/v1/ticker/ | grep -e symbol -e percent_change_24h | cut -f4 -d'"' | xargs -n 2 | awk '{ print $1":"$2 }' | grep -v $market | head -n 10 | cut -f2 -d":"`


`sed -i '/#PAIRS_HELPER@MK/,$d' $file`
echo "#PAIRS_HELPER@MK" >> $file
echo "# $dt" >> $file
for i in $list 
do
		coin=`echo $i | cut -f1 -d':'`;
        pct=`echo $i | cut -f2 -d':'`;
        diffPct=`echo "$pct - $btcPct" | bc`;

	# set PAIR naming for each exchange
	case $exchange in
		BITTREX)  cEx="$market-$coin"
				   ;;
		BINANCE)  cEx="$coin"$market
				   ;;
		POLONIEX) cEx="$market_$coin"
				   ;;
		*)		   echo "Error: wrong exchange specified"; exit
				   ;;
	esac

     	
	a=$diffPct
	b=$limit
    if [ "$limit" != "0" ]; then
    	writePair $a $b ">"
    	b=`echo "$limit * -1" | bc`
    	writePair $a $b "<"
    fi
done
   
if [ "$altSOM" != "0" ]; then
 sumAlt=`echo $altPct | tr " " "+"`
 diffAlt=`echo "("$sumAlt")"/10 | bc`
 writeSOM $diffAlt $altSOM ">"
 b=`echo "$altSOM * -1" | bc`
 writeSOM $diffAlt $b "<"
fi

