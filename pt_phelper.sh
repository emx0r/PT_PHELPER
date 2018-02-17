#!/bin/sh
# Description
# -----------
# PT_PHELPER script aims to avoid DCA bags by constantly watching
# percentage changes for ALT coins and if 24h limit given by user
# is exceeded, it activates COIN-specific SOM.
#
# It can also enable global SOM, if TOP10 ALTcoins cross the 
# % average change.
#
# The script can utilize Telegram-cli to obtain information
# about newly listed coins on a exchange and can automatically
# enable SOM for any new coin. (you can specify the limit in days)
#
# To have this feature working you need to have Telegram-cli
# configured and be in Coin Listing group: https://t.me/coin_listing
# 
# Telegram feature in in experimental phase and needs a lot of testing
# please report back any bugs
#
# Instructions
# ------------
#
# Let the script run from cron, passing your exchange and limits as 
# parameters.
# 
# 1. parm: BITTREX / BINANCE / POLONIEX
# 2. parm: 24h % change for altcoins to enable COIN specific SOM
# 3. parm: 24h % change average for TOP 10 marketcap altcoins 
#    	   to enable global SOM
# 4. parm: Ignore newly listed coins on exchange - specify number
#	   of days you want to ignore the coin 
#
# Functions 2, 3 and 4 can be disabled by specifying "0" 
#
# e.g. */5 * * * * /var/scripts/pairs_helper.sh BITTREX 15 15
#
# Review/modify configuration variables within Review/Modify
# part.
#
# Most important variables to fill in:
#
# file: 	path to your PAIR.properties config
# market:	what market you trade BTC, ETC ..
# tgPath:	path to your telegram-cli binary
#		if you wish to use ignore function
#		for newly listed coins
#
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
           1) echo  $cEx"_sell_only_mode = true" >> $tmpFile; echo "# $diffPct% $o $b%" >> $tmpFile
           ;; esac

}

writeSOM()
{
	a=$1
	b=$2
	o=$3
	case `echo "a=$a;b=$b;r=-1;if(a==b)r=0;if(a"$o"b)r=1;r"|bc` in
          1) echo  "ALL_sell_only_mode = true" >> $tmpFile; echo "# Average for Top10 ALTs beyond limit: $a $o $b" >> $tmpFile
          ;; esac
}

telegram()
{
	tDaysU=`echo "$1 * 86400" | bc`
        tPday=$1
	tCurrU=`date +"%s"`
        tFromU=`echo "$tCurrU - $tDaysU" | bc`
	tExchange=$3
	tMarket=$2
	tmpfile=$4
	tgOut=`$tgPath -k tg-server.pub -e "search Coin_listing 100 $tFromU $tCurrU $tExchange" -W | grep -o '[A-Z0-9]*/'$tMarket'' | cut -f1 -d"/"`
	echo "# Following coins are SOMed as newly listed - less than $tPday days old" >> $tmpFile
        for i in $tgOut
	do
		exchangeFormat $exchange $i $tMarket
		echo  $cEx"_sell_only_mode = true" >> $tmpFile

	done
	echo '#' >> $tmpFile

}

exchangeFormat()
{
	        exchange=$1
		coin=$2
		market=$3

		case $exchange in
                BITTREX)  cEx="$market-$coin"
                                   ;;
                BINANCE)  cEx="$coin"$market
                                   ;;
                POLONIEX) cEx="$market_$coin"
                                   ;;
                *)                 echo "Error: wrong exchange specified"; exit
                                   ;;
        	esac

}

checkArg()
{

   	case $1 in
    	''|*[!0-9]*) echo "Argument must be a number - verify 2nd, 3rd and 4th option"; exit ;;
    	*) ;;
	esac

}

######### REVIEW / MODIFY OPTIONS BELOW #########

exchange=$1  								#PASS BITTREX, BINANCE, POLONIEX
limit=$2     								#PASS % LIMIT TO PUT A PAIR INTO SOM; 0 DISABLES THIS FUNCTION
altSOM=$3    								#PASS % FOR AVERAGE OF TOP 10 ALTCOINS WHEN TO ENABLE GLOBAL SOM; 0 DISABLES THIS FUNCTION
tg=$4        								#CHECK IF WE WANT TELEGRAM
tgPath=telegram-cli							#PATH TO TELEGRAM-CLI BINARY
file=PAIRS.properties							#PATH TO YOUR PAIRS CONFIG
market=BTC								#MARKET YOU TRADE
listLimit=200								#HOW MANY COINS YOU WANT TO CHECK - TAKEN FROM MARKETCAP VALUE

######### END OF USER MODIFICATIONS ############# 

checkArg $limit
checkArg $altSOM
checkArg $tg

list=`curl --silent https://api.coinmarketcap.com/v1/ticker/?limit=$listLimit | grep -e symbol -e percent_change_24h | sed s'/null/"@@@"/g' | cut -f4 -d'"' | xargs -n 2 | awk '{ print $1":"$2 }'`
btcPct=`curl --silent https://api.coinmarketcap.com/v1/ticker/bitcoin/ | grep percent_change_24h | cut -f4 -d'"'`
altPct=`curl --silent https://api.coinmarketcap.com/v1/ticker/ | grep -e symbol -e percent_change_24h | cut -f4 -d'"' | xargs -n 2 | awk '{ print $1":"$2 }' | grep -v $market | head -n 10 | cut -f2 -d":"`
dt=`date`
tmpFile="$file".tmp
uid=`id -u`

`cp $file $tmpFile`

if [ "$uid" -eq 0 ]; then

	tgPath="$tgPath -U root"

fi

`sed -i '/#PT_PHELPER@MK/,$d' $tmpFile`
echo "#PT_PHELPER@MK" >> $tmpFile
echo "# $dt" >> $tmpFile

if [ "$tg" != "0" ]; then

	telegram $tg $market $exchange $tmpFile

fi

echo "#Coin specific SOM - limit +- $limit%" >> $tmpFile
for i in $list 
do
	coin=`echo $i | cut -f1 -d':'`;
        pct=`echo $i  | cut -f2 -d':'`;
	
	if [ "$pct" == "@@@" ]; then
                continue
        fi

        diffPct=`echo "$pct - $btcPct" | bc`;

	exchangeFormat $exchange $coin $market
     	
	a=$diffPct
	b=$limit

    if [ "$limit" != "0" ]; then
    	writePair $a $b ">"
    	b=`echo "$limit * -1" | bc`
    	writePair $a $b "<"
    fi
done
echo "#" >> $tmpFile
   
if [ "$altSOM" != "0" ]; then
 sumAlt=`echo $altPct | tr " " "+"`
 diffAlt=`echo "("$sumAlt")"/10 | bc`
 echo "#GLOBAL ALT SOM - limit +- $altSOM% (current average is $diffAlt%)" >> $tmpFile
 writeSOM $diffAlt $altSOM ">"
 b=`echo "$altSOM * -1" | bc`
 writeSOM $diffAlt $b "<"
 echo "#" >> $tmpFile
fi

`cp $tmpFile $file`
